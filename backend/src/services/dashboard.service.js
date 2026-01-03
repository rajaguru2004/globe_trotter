/**
 * Dashboard Service
 */

import prisma from '../config/database.js';

export const getDashboardOverview = async (userId) => {
    // Get upcoming trips
    const upcomingTrips = await prisma.trip.findMany({
        where: {
            userId,
            isDeleted: false,
            status: { in: ['UPCOMING', 'ONGOING'] }
        },
        take: 5,
        orderBy: { startDate: 'asc' },
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
    });

    // Get trip stats
    const tripStats = await prisma.trip.groupBy({
        by: ['status'],
        where: {
            userId,
            isDeleted: false
        },
        _count: {
            id: true
        }
    });

    // Get total budget (rough calculation)
    const tripsWithExpenses = await prisma.trip.findMany({
        where: {
            userId,
            isDeleted: false
        },
        include: {
            stops: {
                include: {
                    expenses: {
                        select: {
                            amount: true
                        }
                    },
                    activities: {
                        select: {
                            estimatedCost: true
                        }
                    }
                }
            }
        }
    });

    let totalSpent = 0;
    let totalEstimated = 0;

    tripsWithExpenses.forEach(trip => {
        trip.stops.forEach(stop => {
            stop.expenses.forEach(expense => {
                totalSpent += expense.amount;
            });
            stop.activities.forEach(activity => {
                if (activity.estimatedCost) {
                    totalEstimated += activity.estimatedCost;
                }
            });
        });
    });

    // Get most visited cities
    const popularCities = await prisma.tripStop.groupBy({
        by: ['cityId'],
        where: {
            trip: {
                userId,
                isDeleted: false
            }
        },
        _count: {
            cityId: true
        },
        orderBy: {
            _count: {
                cityId: 'desc'
            }
        },
        take: 5
    });

    // Fetch city details
    const cityIds = popularCities.map(c => c.cityId);
    const cities = await prisma.city.findMany({
        where: { id: { in: cityIds } },
        select: {
            id: true,
            name: true,
            country: true
        }
    });

    const popularCitiesWithDetails = popularCities.map(pc => ({
        ...cities.find(c => c.id === pc.cityId),
        visitCount: pc._count.cityId
    }));

    return {
        upcomingTrips,
        tripStats: {
            total: tripStats.reduce((acc, stat) => acc + stat._count.id, 0),
            byStatus: tripStats.reduce((acc, stat) => {
                acc[stat.status] = stat._count.id;
                return acc;
            }, {})
        },
        budget: {
            totalEstimated,
            totalSpent,
            remaining: totalEstimated - totalSpent
        },
        popularCities: popularCitiesWithDetails
    };
};
