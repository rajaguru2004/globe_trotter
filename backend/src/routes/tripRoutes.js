import express from 'express';
import * as tripController from '../controllers/tripController.js';

const router = express.Router();

/**
 * Trip Routes
 * Base path: /api/trips
 */

// POST /api/trips - Create new trip
router.post('/', tripController.createTrip);

// GET /api/trips - Get all trips
router.get('/', tripController.getAllTrips);

// GET /api/trips/:id - Get trip by ID
router.get('/:id', tripController.getTripById);

// GET /api/trips/user/:userId - Get trips by user ID
router.get('/user/:userId', tripController.getTripsByUserId);

// PUT /api/trips/:id - Update trip
router.put('/:id', tripController.updateTrip);

// DELETE /api/trips/:id - Delete trip
router.delete('/:id', tripController.deleteTrip);

export default router;
