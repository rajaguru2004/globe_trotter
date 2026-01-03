import * as tripService from '../services/tripService.js';

/**
 * Trip Controller - Express Request Handlers
 */

// Create trip
export const createTrip = async (req, res) => {
    try {
        const { title, description, destination, startDate, endDate, budget, userId } = req.body;

        // Validation
        if (!title || !destination || !startDate || !endDate || !userId) {
            return res.status(400).json({
                success: false,
                error: 'Title, destination, start date, end date, and user ID are required'
            });
        }

        const trip = await tripService.createTrip({
            title,
            description,
            destination,
            startDate,
            endDate,
            budget,
            userId,
        });

        res.status(201).json({
            success: true,
            data: trip
        });
    } catch (error) {
        console.error('Error creating trip:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to create trip',
            message: error.message
        });
    }
};

// Get all trips
export const getAllTrips = async (req, res) => {
    try {
        const trips = await tripService.getAllTrips();

        res.status(200).json({
            success: true,
            data: trips,
            count: trips.length
        });
    } catch (error) {
        console.error('Error fetching trips:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch trips',
            message: error.message
        });
    }
};

// Get trip by ID
export const getTripById = async (req, res) => {
    try {
        const { id } = req.params;
        const trip = await tripService.getTripById(id);

        if (!trip) {
            return res.status(404).json({
                success: false,
                error: 'Trip not found'
            });
        }

        res.status(200).json({
            success: true,
            data: trip
        });
    } catch (error) {
        console.error('Error fetching trip:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch trip',
            message: error.message
        });
    }
};

// Get trips by user ID
export const getTripsByUserId = async (req, res) => {
    try {
        const { userId } = req.params;
        const trips = await tripService.getTripsByUserId(userId);

        res.status(200).json({
            success: true,
            data: trips,
            count: trips.length
        });
    } catch (error) {
        console.error('Error fetching user trips:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch user trips',
            message: error.message
        });
    }
};

// Update trip
export const updateTrip = async (req, res) => {
    try {
        const { id } = req.params;
        const updateData = req.body;

        const existingTrip = await tripService.getTripById(id);
        if (!existingTrip) {
            return res.status(404).json({
                success: false,
                error: 'Trip not found'
            });
        }

        const trip = await tripService.updateTrip(id, updateData);

        res.status(200).json({
            success: true,
            data: trip
        });
    } catch (error) {
        console.error('Error updating trip:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to update trip',
            message: error.message
        });
    }
};

// Delete trip
export const deleteTrip = async (req, res) => {
    try {
        const { id } = req.params;

        const existingTrip = await tripService.getTripById(id);
        if (!existingTrip) {
            return res.status(404).json({
                success: false,
                error: 'Trip not found'
            });
        }

        await tripService.deleteTrip(id);

        res.status(200).json({
            success: true,
            message: 'Trip deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting trip:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete trip',
            message: error.message
        });
    }
};
