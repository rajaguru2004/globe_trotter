/**
 * Admin Service
 */

import prisma from '../config/database.js';

export const getStats = async () => {
    const [totalUsers, totalTrips, totalActivities, totalCommunityPosts] = await Promise.all([
        prisma.user.count({ where: { isActive: true } }),
        prisma.trip.count({ where: { isDeleted: false } }),
        prisma.activityInstance.count(),
        prisma.communityPost.count()
    ]);

    const tripsByStatus = await prisma.trip.groupBy({
        by: ['status'],
        where: { isDeleted: false },
        _count: { id: true }
    });

    return {
        users: totalUsers,
        trips: totalTrips,
        activities: totalActivities,
        communityPosts: totalCommunityPosts,
        tripsByStatus: tripsByStatus.reduce((acc, item) => {
            acc[item.status] = item._count.id;
            return acc;
        }, {})
    };
};

export const getTopCities = async (limit = 10) => {
    const topCities = await prisma.tripStop.groupBy({
        by: ['cityId'],
        _count: { cityId: true },
        orderBy: { _count: { cityId: 'desc' } },
        take: limit
    });

    const cityIds = topCities.map(c => c.cityId);
    const cities = await prisma.city.findMany({
        where: { id: { in: cityIds } },
        include: { _count: { select: { activities: true } } }
    });

    return topCities.map(tc => ({
        ...cities.find(c => c.id === tc.cityId),
        tripCount: tc._count.cityId
    }));
};
