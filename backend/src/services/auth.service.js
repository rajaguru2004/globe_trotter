/**
 * Authentication Service
 * Business logic for user authentication and registration
 */

import bcrypt from 'bcryptjs';
import prisma from '../config/database.js';
import { generateToken } from '../utils/jwt.js';
import { ConflictError, AuthenticationError, NotFoundError } from '../utils/errors.js';

/**
 * Register a new user
 * @param {Object} data - User registration data
 * @returns {Object} User object and JWT token
 */
export const register = async ({ email, password, firstName, lastName }) => {
    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
        where: { email: email.toLowerCase() }
    });

    if (existingUser) {
        throw new ConflictError('Email already registered');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);

    // Create user
    const user = await prisma.user.create({
        data: {
            email: email.toLowerCase(),
            passwordHash,
            firstName,
            lastName,
            role: 'USER'
        },
        select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            role: true,
            createdAt: true
        }
    });

    // Generate JWT token
    const token = generateToken({ userId: user.id, email: user.email, role: user.role });

    return {
        user,
        token
    };
};

/**
 * Login user
 * @param {string} email - User email
 * @param {string} password - User password
 * @returns {Object} User object and JWT token
 */
export const login = async (email, password) => {
    // Find user by email
    const user = await prisma.user.findUnique({
        where: { email: email.toLowerCase() }
    });

    if (!user) {
        throw new AuthenticationError('Invalid email or password');
    }

    // Check if account is active
    if (!user.isActive) {
        throw new AuthenticationError('Account is inactive. Please contact support.');
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);

    if (!isPasswordValid) {
        throw new AuthenticationError('Invalid email or password');
    }

    // Generate JWT token
    const token = generateToken({ userId: user.id, email: user.email, role: user.role });

    // Return user without password hash
    const { passwordHash, ...userWithoutPassword } = user;

    return {
        user: userWithoutPassword,
        token
    };
};

/**
 * Get user profile by ID
 * @param {string} userId - User ID
 * @returns {Object} User profile
 */
export const getUserById = async (userId) => {
    const user = await prisma.user.findUnique({
        where: { id: userId },
        select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            profileImage: true,
            role: true,
            isActive: true,
            createdAt: true,
            updatedAt: true
        }
    });

    if (!user) {
        throw new NotFoundError('User not found');
    }

    return user;
};
