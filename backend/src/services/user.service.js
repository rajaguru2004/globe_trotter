/**
 * User Service
 */

import prisma from '../config/database.js';
import { NotFoundError } from '../utils/errors.js';

export const getProfile = async (userId) => {
    const user = await prisma.user.findUnique({
        where: { id: userId },
        select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            profileImage: true,
            role: true,
            createdAt: true,
            updatedAt: true
        }
    });

    if (!user) {
        throw new NotFoundError('User not found');
    }

    return user;
};

export const updateProfile = async (userId, data) => {
    const user = await prisma.user.update({
        where: { id: userId },
        data,
        select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            profileImage: true,
            role: true,
            updatedAt: true
        }
    });

    return user;
};

export const deleteAccount = async (userId) => {
    await prisma.user.update({
        where: { id: userId },
        data: { isActive: false }
    });
};
