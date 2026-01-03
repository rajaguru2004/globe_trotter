import prisma from '../config/database.js';

/**
 * User Service - CRUD Operations
 * 
 * MONGOOSE COMPARISON:
 * - prisma.user.create() ≈ User.create()
 * - prisma.user.findMany() ≈ User.find()
 * - prisma.user.findUnique() ≈ User.findById()
 * - prisma.user.update() ≈ User.findByIdAndUpdate()
 * - prisma.user.delete() ≈ User.findByIdAndDelete()
 */

// Create a new user
export const createUser = async (userData) => {
    const user = await prisma.user.create({
        data: {
            email: userData.email,
            name: userData.name,
            phone: userData.phone,
            avatar: userData.avatar,
        },
    });
    return user;
};

// Get all users
export const getAllUsers = async () => {
    const users = await prisma.user.findMany({
        include: {
            trips: true,      // Like .populate('trips') in Mongoose
            bookings: true,   // Like .populate('bookings') in Mongoose
        },
        orderBy: {
            createdAt: 'desc',
        },
    });
    return users;
};

// Get user by ID
export const getUserById = async (id) => {
    const user = await prisma.user.findUnique({
        where: { id },
        include: {
            trips: {
                orderBy: { startDate: 'desc' },
            },
            bookings: {
                orderBy: { bookingDate: 'desc' },
            },
        },
    });
    return user;
};

// Update user
export const updateUser = async (id, userData) => {
    const user = await prisma.user.update({
        where: { id },
        data: userData,
    });
    return user;
};

// Delete user
export const deleteUser = async (id) => {
    const user = await prisma.user.delete({
        where: { id },
    });
    return user;
};

// Find user by email (useful for authentication)
export const getUserByEmail = async (email) => {
    const user = await prisma.user.findUnique({
        where: { email },
    });
    return user;
};
