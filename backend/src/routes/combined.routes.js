/**
 * Combined Routes for Search, Budget, Dashboard, Sharing
 */

import express from 'express';
import * as controller from '../controllers/combined.controller.js';
import { authenticate } from '../middlewares/auth.js';

const router = express.Router();

// Search routes (protected)
router.get('/cities/search', authenticate, controller.searchCities);
router.get('/activities/search', authenticate, controller.searchActivities);

// Budget routes
router.get('/trips/:tripId/budget', authenticate, controller.getTripBudget);

// Dashboard route
router.get('/dashboard/overview', authenticate, controller.getDashboard);

// Sharing routes
router.post('/trips/:tripId/share', authenticate, controller.shareTrip);
router.get('/shared/:slug', controller.getSharedTrip); // Public route
router.get('/community/feed', authenticate, controller.getCommunityFeed);
router.post('/community/shared-trips/:sharedTripId/copy', authenticate, controller.copyTrip);

export default router;
