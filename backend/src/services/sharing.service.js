/**
 * Sharing & Community Service
 */

import { nanoid } from 'nanoid';
import prisma from '../config/database.js';
import { NotFoundError, ForbiddenError, ConflictError } from '../utils/errors.js';

export const shareTrip = async (tripId, userId) => {
    // Verify ownership
    const trip = await prisma.trip.findFirst({
        where: { id: tripId, userId }
    });

    if (!trip) {
        throw new NotFoundError('Trip not found');
    }

    // Check if already shared
    const existingShare = await prisma.publicSharedTrip.findUnique({
        where: { tripId }
    });

    if (existingShare) {
        return existingShare;
    }

    // Generate unique slug
    const publicSlug = nanoid(10);

    const sharedTrip = await prisma.publicSharedTrip.create({
        data: {
            tripId,
            publicSlug,
            isActive: true
        }
    });

    return sharedTrip;
};

export const getSharedTrip = async (slug) => {
    const sharedTrip = await prisma.publicSharedTrip.findUnique({
        where: { publicSlug: slug, isActive: true },
        include: {
            trip: {
                include: {
                    user: {
                        select: {
                            id: true,
                            firstName: true,
                            lastName: true
                        }
                    },
                    stops: {
                        include: {
                            city: true,
                            activities: {
                                include: {
                                    activityMaster: true
                                }
                            }
                        },
                        orderBy: { orderIndex: 'asc' }
                    }
                }
            }
        }
    });

    if (!sharedTrip) {
        throw new NotFoundError('Shared trip not found');
    }

    return sharedTrip;
};

export const getCommunityFeed = async (filters = {}) => {
    const { page = 1, limit = 10 } = filters;
    const skip = (page - 1) * limit;

    const [posts, total] = await Promise.all([
        prisma.communityPost.findMany({
            skip,
            take: parseInt(limit),
            orderBy: { createdAt: 'desc' },
            include: {
                user: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        profileImage: true
                    }
                },
                sharedTrip: {
                    include: {
                        trip: {
                            select: {
                                id: true,
                                name: true,
                                description: true,
                                startDate: true,
                                endDate: true,
                                coverImage: true,
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
                                }
                            }
                        }
                    }
                }
            }
        }),
        prisma.communityPost.count()
    ]);

    return {
        posts,
        pagination: {
            page: parseInt(page),
            limit: parseInt(limit),
            total,
            pages: Math.ceil(total / limit)
        }
    };
};

export const copySharedTrip = async (sharedTripId, userId) => {
    const sharedTrip = await prisma.publicSharedTrip.findUnique({
        where: { id: sharedTripId },
        include: {
            trip: {
                include: {
                    stops: {
                        include: {
                            activities: true
                        }
                    }
                }
            }
        }
    });

    if (!sharedTrip) {
        throw new NotFoundError('Shared trip not found');
    }

    // Create a copy of the trip
    const newTrip = await prisma.trip.create({
        data: {
            userId,
            name: `${sharedTrip.trip.name} (Copy)`,
            description: sharedTrip.trip.description,
            startDate: sharedTrip.trip.startDate,
            endDate: sharedTrip.trip.endDate,
            coverImage: sharedTrip.trip.coverImage,
            status: 'DRAFT',
            stops: {
                create: sharedTrip.trip.stops.map(stop => ({
                    cityId: stop.cityId,
                    startDate: stop.startDate,
                    endDate: stop.endDate,
                    orderIndex: stop.orderIndex,
                    activities: {
                        create: stop.activities.map(activity => ({
                            activityMasterId: activity.activityMasterId,
                            scheduledDate: activity.scheduledDate,
                            startTime: activity.startTime,
                            durationInHours: activity.durationInHours,
                            estimatedCost: activity.estimatedCost
                        }))
                    }
                }))
            }
        },
        include: {
            stops: {
                include: {
                    city: true,
                    activities: true
                }
            }
        }
    });

    return newTrip;
};
