/**
 * Itinerary Service (TripStops & Activities)
 */

import prisma from '../config/database.js';
import { NotFoundError, ForbiddenError } from '../utils/errors.js';

// ===== TRIP STOP METHODS =====

const verifyTripOwnership = async (tripId, userId) => {
    const trip = await prisma.trip.findFirst({
        where: { id: tripId, userId }
    });

    if (!trip) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    return trip;
};

export const addStop = async (tripId, userId, data) => {
    await verifyTripOwnership(tripId, userId);

    const stop = await prisma.tripStop.create({
        data: {
            ...data,
            tripId
        },
        include: {
            city: true
        }
    });

    return stop;
};

export const updateStop = async (stopId, userId, data) => {
    const stop = await prisma.tripStop.findUnique({
        where: { id: stopId },
        include: { trip: true }
    });

    if (!stop) {
        throw new NotFoundError('Trip stop not found');
    }

    if (stop.trip.userId !== userId) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    const updated = await prisma.tripStop.update({
        where: { id: stopId },
        data,
        include: { city: true }
    });

    return updated;
};

export const deleteStop = async (stopId, userId) => {
    const stop = await prisma.tripStop.findUnique({
        where: { id: stopId },
        include: { trip: true }
    });

    if (!stop) {
        throw new NotFoundError('Trip stop not found');
    }

    if (stop.trip.userId !== userId) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    await prisma.tripStop.delete({
        where: { id: stopId }
    });
};

export const reorderStops = async (tripId, userId, stops) => {
    await verifyTripOwnership(tripId, userId);

    // Update all stops in a transaction
    await prisma.$transaction(
        stops.map(stop =>
            prisma.tripStop.update({
                where: { id: stop.id },
                data: { orderIndex: stop.orderIndex }
            })
        )
    );

    return { message: 'Stops reordered successfully' };
};

// ===== ACTIVITY METHODS =====

export const addActivity = async (stopId, userId, data) => {
    const stop = await prisma.tripStop.findUnique({
        where: { id: stopId },
        include: { trip: true }
    });

    if (!stop) {
        throw new NotFoundError('Trip stop not found');
    }

    if (stop.trip.userId !== userId) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    const activity = await prisma.activityInstance.create({
        data: {
            ...data,
            tripStopId: stopId
        },
        include: {
            activityMaster: true
        }
    });

    return activity;
};

export const updateActivity = async (activityId, userId, data) => {
    const activity = await prisma.activityInstance.findUnique({
        where: { id: activityId },
        include: {
            tripStop: {
                include: { trip: true }
            }
        }
    });

    if (!activity) {
        throw new NotFoundError('Activity not found');
    }

    if (activity.tripStop.trip.userId !== userId) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    const updated = await prisma.activityInstance.update({
        where: { id: activityId },
        data,
        include: { activityMaster: true }
    });

    return updated;
};

export const deleteActivity = async (activityId, userId) => {
    const activity = await prisma.activityInstance.findUnique({
        where: { id: activityId },
        include: {
            tripStop: {
                include: { trip: true }
            }
        }
    });

    if (!activity) {
        throw new NotFoundError('Activity not found');
    }

    if (activity.tripStop.trip.userId !== userId) {
        throw new ForbiddenError('You do not have access to this trip');
    }

    await prisma.activityInstance.delete({
        where: { id: activityId }
    });
};
