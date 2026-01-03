/**
 * Authentication Middleware
 * Handles JWT verification and user authentication
 */

import prisma from '../config/database.js';
import { verifyToken } from '../utils/jwt.js';
import { AuthenticationError, ForbiddenError } from '../utils/errors.js';
import asyncHandler from '../utils/asyncHandler.js';

/**
 * Verify JWT token and attach user to request
 */
export const authenticate = asyncHandler(async (req, res, next) => {
    let token;

    // Check for Bearer token in Authorization header
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
        throw new AuthenticationError('No token provided. Please login.');
    }

    // Verify token
    const decoded = verifyToken(token);

    // Fetch user from database
    const user = await prisma.user.findUnique({
        where: { id: decoded.userId },
        select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            role: true,
            isActive: true
        }
    });

    if (!user) {
        throw new AuthenticationError('User not found');
    }

    if (!user.isActive) {
        throw new AuthenticationError('Account is inactive');
    }

    // Attach user to request object
    req.user = user;
    next();
});

/**
 * Require specific role for access
 * @param {string} role - Required role (e.g., 'ADMIN')
 */
export const requireRole = (role) => {
    return asyncHandler(async (req, res, next) => {
        if (!req.user) {
            throw new AuthenticationError('Authentication required');
        }

        if (req.user.role !== role) {
            throw new ForbiddenError(`Requires ${role} role`);
        }

        next();
    });
};
