/**
 * Combined Controllers for Search, Budget, Dashboard, Sharing
 */

import asyncHandler from '../utils/asyncHandler.js';
import * as searchService from '../services/search.service.js';
import * as budgetService from '../services/budget.service.js';
import * as dashboardService from '../services/dashboard.service.js';
import * as sharingService from '../services/sharing.service.js';
import { HttpStatus } from '../constants/enums.js';

// ===== SEARCH =====
export const searchCities = asyncHandler(async (req, res) => {
    const cities = await searchService.searchCities(req.query.q || '', req.query);
    res.status(HttpStatus.OK).json({ success: true, data: { cities } });
});

export const searchActivities = asyncHandler(async (req, res) => {
    const activities = await searchService.searchActivities(req.query.q || '', req.query);
    res.status(HttpStatus.OK).json({ success: true, data: { activities } });
});

// ===== BUDGET =====
export const getTripBudget = asyncHandler(async (req, res) => {
    const budget = await budgetService.calculateTripBudget(req.params.tripId, req.user.id);
    res.status(HttpStatus.OK).json({ success: true, data: { budget } });
});

// ===== DASHBOARD =====
export const getDashboard = asyncHandler(async (req, res) => {
    const dashboard = await dashboardService.getDashboardOverview(req.user.id);
    res.status(HttpStatus.OK).json({ success: true, data: dashboard });
});

// ===== SHARING =====
export const shareTrip = asyncHandler(async (req, res) => {
    const sharedTrip = await sharingService.shareTrip(req.params.tripId, req.user.id);
    res.status(HttpStatus.CREATED).json({ success: true, message: 'Trip shared successfully', data: { sharedTrip } });
});

export const getSharedTrip = asyncHandler(async (req, res) => {
    const sharedTrip = await sharingService.getSharedTrip(req.params.slug);
    res.status(HttpStatus.OK).json({ success: true, data: { sharedTrip } });
});

export const getCommunityFeed = asyncHandler(async (req, res) => {
    const result = await sharingService.getCommunityFeed(req.query);
    res.status(HttpStatus.OK).json({ success: true, data: result });
});

export const copyTrip = asyncHandler(async (req, res) => {
    const trip = await sharingService.copySharedTrip(req.params.sharedTripId, req.user.id);
    res.status(HttpStatus.CREATED).json({ success: true, message: 'Trip copied successfully', data: { trip } });
});
