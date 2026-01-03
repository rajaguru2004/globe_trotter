/**
 * Trip Routes
 */

import express from 'express';
import * as tripController from '../controllers/trip.controller.js';
import { authenticate } from '../middlewares/auth.js';
import { validate } from '../middlewares/validator.js';
import { createTripSchema, updateTripSchema, getTripQuery } from '../validations/trip.validation.js';

const router = express.Router();

// All trip routes require authentication
router.use(authenticate);

router.post('/', validate(createTripSchema), tripController.createTrip);
router.get('/', validate(getTripQuery, 'query'), tripController.getTrips);
router.get('/:id', tripController.getTrip);
router.put('/:id', validate(updateTripSchema), tripController.updateTrip);
router.delete('/:id', tripController.deleteTrip);

export default router;
