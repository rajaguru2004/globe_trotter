/**
 * Itinerary Routes
 */

import express from 'express';
import * as itineraryController from '../controllers/itinerary.controller.js';
import { authenticate } from '../middlewares/auth.js';
import { validate } from '../middlewares/validator.js';
import {
    createTripStopSchema,
    updateTripStopSchema,
    reorderStopsSchema,
    createActivitySchema,
    updateActivitySchema
} from '../validations/itinerary.validation.js';

const router = express.Router();

// All routes require authentication
router.use(authenticate);

// Trip Stop routes
router.post('/trips/:tripId/stops', validate(createTripStopSchema), itineraryController.addStop);
router.put('/stops/:stopId', validate(updateTripStopSchema), itineraryController.updateStop);
router.delete('/stops/:stopId', itineraryController.deleteStop);
router.post('/trips/:tripId/stops/reorder', validate(reorderStopsSchema), itineraryController.reorderStops);

// Activity routes
router.post('/stops/:stopId/activities', validate(createActivitySchema), itineraryController.addActivity);
router.put('/activities/:activityId', validate(updateActivitySchema), itineraryController.updateActivity);
router.delete('/activities/:activityId', itineraryController.deleteActivity);

export default router;
