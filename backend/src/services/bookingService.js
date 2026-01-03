import prisma from '../config/database.js';

/**
 * Booking Service - CRUD Operations
 * Handles flight, hotel, activity, and car rental bookings
 */

// Create a new booking
export const createBooking = async (bookingData) => {
    const booking = await prisma.booking.create({
        data: {
            type: bookingData.type,
            providerName: bookingData.providerName,
            confirmationNumber: bookingData.confirmationNumber,
            bookingDate: new Date(bookingData.bookingDate),
            startDate: new Date(bookingData.startDate),
            endDate: bookingData.endDate ? new Date(bookingData.endDate) : null,
            totalAmount: bookingData.totalAmount,
            currency: bookingData.currency || 'USD',
            status: bookingData.status || 'confirmed',
            notes: bookingData.notes,
            userId: bookingData.userId,
            tripId: bookingData.tripId || null,
        },
        include: {
            user: true,
            trip: true,
        },
    });
    return booking;
};

// Get all bookings
export const getAllBookings = async () => {
    const bookings = await prisma.booking.findMany({
        include: {
            user: {
                select: {
                    id: true,
                    name: true,
                    email: true,
                },
            },
            trip: {
                select: {
                    id: true,
                    title: true,
                    destination: true,
                },
            },
        },
        orderBy: {
            bookingDate: 'desc',
        },
    });
    return bookings;
};

// Get booking by ID
export const getBookingById = async (id) => {
    const booking = await prisma.booking.findUnique({
        where: { id },
        include: {
            user: true,
            trip: true,
        },
    });
    return booking;
};

// Get bookings by user ID
export const getBookingsByUserId = async (userId) => {
    const bookings = await prisma.booking.findMany({
        where: { userId },
        include: {
            trip: true,
        },
        orderBy: {
            bookingDate: 'desc',
        },
    });
    return bookings;
};

// Get bookings by trip ID
export const getBookingsByTripId = async (tripId) => {
    const bookings = await prisma.booking.findMany({
        where: { tripId },
        orderBy: {
            startDate: 'asc',
        },
    });
    return bookings;
};

// Update booking
export const updateBooking = async (id, bookingData) => {
    const booking = await prisma.booking.update({
        where: { id },
        data: {
            ...bookingData,
            ...(bookingData.bookingDate && { bookingDate: new Date(bookingData.bookingDate) }),
            ...(bookingData.startDate && { startDate: new Date(bookingData.startDate) }),
            ...(bookingData.endDate && { endDate: new Date(bookingData.endDate) }),
        },
        include: {
            user: true,
            trip: true,
        },
    });
    return booking;
};

// Delete booking
export const deleteBooking = async (id) => {
    const booking = await prisma.booking.delete({
        where: { id },
    });
    return booking;
};

// Get bookings by type (flight, hotel, activity, car_rental)
export const getBookingsByType = async (type) => {
    const bookings = await prisma.booking.findMany({
        where: { type },
        include: {
            user: {
                select: {
                    id: true,
                    name: true,
                    email: true,
                },
            },
            trip: {
                select: {
                    id: true,
                    title: true,
                },
            },
        },
        orderBy: {
            bookingDate: 'desc',
        },
    });
    return bookings;
};
