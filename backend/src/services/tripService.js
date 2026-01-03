import prisma from '../config/database.js';

/**
 * Trip Service - CRUD Operations with Relations
 * 
 * DEMONSTRATES:
 * - Creating records with relations
 * - Populating related data (include)
 * - Filtering and sorting
 */

// Create a new trip
export const createTrip = async (tripData) => {
    const trip = await prisma.trip.create({
        data: {
            title: tripData.title,
            description: tripData.description,
            destination: tripData.destination,
            startDate: new Date(tripData.startDate),
            endDate: new Date(tripData.endDate),
            budget: tripData.budget,
            status: tripData.status || 'planned',
            userId: tripData.userId,  // Foreign key
        },
        include: {
            user: true,  // Populate user data (like .populate('user'))
        },
    });
    return trip;
};

// Get all trips
export const getAllTrips = async () => {
    const trips = await prisma.trip.findMany({
        include: {
            user: {
                select: {
                    id: true,
                    name: true,
                    email: true,
                    avatar: true,
                },
            },
            bookings: true,
        },
        orderBy: {
            startDate: 'desc',
        },
    });
    return trips;
};

// Get trip by ID
export const getTripById = async (id) => {
    const trip = await prisma.trip.findUnique({
        where: { id },
        include: {
            user: true,
            bookings: {
                orderBy: { startDate: 'asc' },
            },
        },
    });
    return trip;
};

// Get trips by user ID
export const getTripsByUserId = async (userId) => {
    const trips = await prisma.trip.findMany({
        where: { userId },
        include: {
            bookings: true,
        },
        orderBy: {
            startDate: 'desc',
        },
    });
    return trips;
};

// Update trip
export const updateTrip = async (id, tripData) => {
    const trip = await prisma.trip.update({
        where: { id },
        data: {
            ...tripData,
            ...(tripData.startDate && { startDate: new Date(tripData.startDate) }),
            ...(tripData.endDate && { endDate: new Date(tripData.endDate) }),
        },
        include: {
            user: true,
            bookings: true,
        },
    });
    return trip;
};

// Delete trip
export const deleteTrip = async (id) => {
    const trip = await prisma.trip.delete({
        where: { id },
    });
    return trip;
};

// Get trips by status
export const getTripsByStatus = async (status) => {
    const trips = await prisma.trip.findMany({
        where: { status },
        include: {
            user: {
                select: {
                    id: true,
                    name: true,
                    email: true,
                },
            },
        },
        orderBy: {
            startDate: 'desc',
        },
    });
    return trips;
};
