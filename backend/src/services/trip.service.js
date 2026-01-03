/**
 * Trip Service
 */

import prisma from '../config/database.js';
import { NotFoundError, ForbiddenError } from '../utils/errors.js';
import { TripStatus } from '../constants/enums.js';

/**
 * Calculate trip status based on dates
 */
const calculateTripStatus = (startDate, endDate) => {
    const now = new Date();
    const start = new Date(startDate);
    const end = new Date(endDate);

    if (now < start) return TripStatus.UPCOMING;
    if (now > end) return TripStatus.COMPLETED;
    return TripStatus.ONGOING;
};

/**
 * Verify trip ownership
 */
const verifyOwnership = async (tripId, userId) => {
    const trip = await prisma.trip.findUnique({
        where: { id: tripId },
        select: { userId: true }
    });

    if (!trip) {
        throw new NotFoundError('Trip not found');
    }

    if (trip.userId !== userId) {
        throw new ForbiddenError('You do not own this trip');
    }
};

export const createTrip = async (userId, data) => {
    const status = calculateTripStatus(data.startDate, data.endDate);

    const trip = await prisma.trip.create({
        data: {
            ...data,
            userId,
            status
        },
        include: {
            user: {
                select: {
                    id: true,
                    firstName: true,
                    lastName: true
                }
            }
        }
    });

    return trip;
};

export const getUserTrips = async (userId, filters = {}) => {
    const { page = 1, limit = 10, status } = filters;
    const skip = (page - 1) * limit;

    const where = {
        userId,
        isDeleted: false,
        ...(status && { status })
    };

    const [trips, total] = await Promise.all([
        prisma.trip.findMany({
            where,
            skip,
            take: parseInt(limit),
            orderBy: { createdAt: 'desc' },
            include: {
                stops: {
                    include: {
                        city: {
                            select: {
                                id: true,
                                name: true,
                                country: true
                            }
                        }
                    }
                },
                _count: {
                    select: {
                        stops: true
                    }
                }
            }
        }),
        prisma.trip.count({ where })
    ]);

    return {
        trips,
        pagination: {
            page: parseInt(page),
            limit: parseInt(limit),
            total,
            pages: Math.ceil(total / limit)
        }
    };
};

export const getTripById = async (tripId, userId) => {
    const trip = await prisma.trip.findFirst({
        where: {
            id: tripId,
            userId,
            isDeleted: false
        },
        include: {
            stops: {
                include: {
                    city: true,
                    activities: {
                        include: {
                            activityMaster: true
                        }
                    },
                    expenses: true
                },
                orderBy: { orderIndex: 'asc' }
            },
            user: {
                select: {
                    id: true,
                    firstName: true,
                    lastName: true,
                    email: true
                }
            }
        }
    });

    if (!trip) {
        throw new NotFoundError('Trip not found');
    }

    return trip;
};

export const updateTrip = async (tripId, userId, data) => {
    await verifyOwnership(tripId, userId);

    // Recalculate status if dates changed
    let updateData = { ...data };
    if (data.startDate || data.endDate) {
        const trip = await prisma.trip.findUnique({ where: { id: tripId } });
        const startDate = data.startDate || trip.startDate;
        const endDate = data.endDate || trip.endDate;
        updateData.status = calculateTripStatus(startDate, endDate);
    }

    const trip = await prisma.trip.update({
        where: { id: tripId },
        data: updateData,
        include: {
            stops: {
                include: {
                    city: true
                }
            }
        }
    });

    return trip;
};

export const deleteTrip = async (tripId, userId) => {
    await verifyOwnership(tripId, userId);

    await prisma.trip.update({
        where: { id: tripId },
        data: { isDeleted: true }
    });
};
