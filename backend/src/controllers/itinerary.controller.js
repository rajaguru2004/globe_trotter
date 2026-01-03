/**
 * Itinerary Controller
 */

import asyncHandler from '../utils/asyncHandler.js';
import * as itineraryService from '../services/itinerary.service.js';
import { HttpStatus } from '../constants/enums.js';

// ===== TRIP STOP CONTROLLERS =====

export const addStop = asyncHandler(async (req, res) => {
    const stop = await itineraryService.addStop(req.params.tripId, req.user.id, req.body);

    res.status(HttpStatus.CREATED).json({
        success: true,
        message: 'Stop added successfully',
        data: { stop }
    });
});

export const updateStop = asyncHandler(async (req, res) => {
    const stop = await itineraryService.updateStop(req.params.stopId, req.user.id, req.body);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Stop updated successfully',
        data: { stop }
    });
});

export const deleteStop = asyncHandler(async (req, res) => {
    await itineraryService.deleteStop(req.params.stopId, req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Stop deleted successfully'
    });
});

export const reorderStops = asyncHandler(async (req, res) => {
    const result = await itineraryService.reorderStops(req.params.tripId, req.user.id, req.body.stops);

    res.status(HttpStatus.OK).json({
        success: true,
        ...result
    });
});

// ===== ACTIVITY CONTROLLERS =====

export const addActivity = asyncHandler(async (req, res) => {
    const activity = await itineraryService.addActivity(req.params.stopId, req.user.id, req.body);

    res.status(HttpStatus.CREATED).json({
        success: true,
        message: 'Activity added successfully',
        data: { activity }
    });
});

export const updateActivity = asyncHandler(async (req, res) => {
    const activity = await itineraryService.updateActivity(req.params.activityId, req.user.id, req.body);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Activity updated successfully',
        data: { activity }
    });
});

export const deleteActivity = asyncHandler(async (req, res) => {
    await itineraryService.deleteActivity(req.params.activityId, req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Activity deleted successfully'
    });
});
