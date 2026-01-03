/**
 * Search Service
 */

import prisma from '../config/database.js';

export const searchCities = async (query, filters = {}) => {
    const { limit = 20 } = filters;

    const cities = await prisma.city.findMany({
        where: {
            isActive: true,
            OR: [
                { name: { contains: query, mode: 'insensitive' } },
                { country: { contains: query, mode: 'insensitive' } }
            ]
        },
        take: parseInt(limit),
        orderBy: [
            { popularityScore: 'desc' },
            { name: 'asc' }
        ],
        include: {
            costReference: true,
            _count: {
                select: {
                    activities: true
                }
            }
        }
    });

    return cities;
};

export const searchActivities = async (query, filters = {}) => {
    const { cityId, categoryId, limit = 20 } = filters;

    const where = {
        isActive: true,
        ...(cityId && { cityId }),
        ...(categoryId && { categoryId }),
        OR: [
            { name: { contains: query, mode: 'insensitive' } },
            { description: { contains: query, mode: 'insensitive' } }
        ]
    };

    const activities = await prisma.activity.findMany({
        where,
        take: parseInt(limit),
        orderBy: [
            { popularityScore: 'desc' },
            { name: 'asc' }
        ],
        include: {
            city: {
                select: {
                    id: true,
                    name: true,
                    country: true
                }
            },
            category: {
                select: {
                    id: true,
                    name: true,
                    icon: true
                }
            }
        }
    });

    return activities;
};
