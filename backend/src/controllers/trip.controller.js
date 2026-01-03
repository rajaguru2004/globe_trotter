/**
 * Trip Controller
 */

import asyncHandler from '../utils/asyncHandler.js';
import * as tripService from '../services/trip.service.js';
import { HttpStatus } from '../constants/enums.js';

export const createTrip = asyncHandler(async (req, res) => {
    const trip = await tripService.createTrip(req.user.id, req.body);

    res.status(HttpStatus.CREATED).json({
        success: true,
        message: 'Trip created successfully',
        data: { trip }
    });
});

export const getTrips = asyncHandler(async (req, res) => {
    const result = await tripService.getUserTrips(req.user.id, req.query);

    res.status(HttpStatus.OK).json({
        success: true,
        data: result
    });
});

export const getTrip = asyncHandler(async (req, res) => {
    const trip = await tripService.getTripById(req.params.id, req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        data: { trip }
    });
});

export const updateTrip = asyncHandler(async (req, res) => {
    const trip = await tripService.updateTrip(req.params.id, req.user.id, req.body);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Trip updated successfully',
        data: { trip }
    });
});

export const deleteTrip = asyncHandler(async (req, res) => {
    await tripService.deleteTrip(req.params.id, req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Trip deleted successfully'
    });
});
