/**
 * TripStop and Activity Validation Schemas
 */

import Joi from 'joi';

// TripStop schemas
export const createTripStopSchema = Joi.object({
    cityId: Joi.string().uuid().required(),
    startDate: Joi.date().iso().required(),
    endDate: Joi.date().iso().greater(Joi.ref('startDate')).required(),
    orderIndex: Joi.number().integer().min(0).required()
});

export const updateTripStopSchema = Joi.object({
    cityId: Joi.string().uuid().optional(),
    startDate: Joi.date().iso().optional(),
    endDate: Joi.date().iso().optional(),
    orderIndex: Joi.number().integer().min(0).optional()
});

export const reorderStopsSchema = Joi.object({
    stops: Joi.array().items(
        Joi.object({
            id: Joi.string().uuid().required(),
            orderIndex: Joi.number().integer().min(0).required()
        })
    ).min(1).required()
});

// Activity schemas
export const createActivitySchema = Joi.object({
    activityMasterId: Joi.string().uuid().required(),
    scheduledDate: Joi.date().iso().required(),
    startTime: Joi.string().pattern(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/).optional().allow(null, ''),
    durationInHours: Joi.number().min(0).max(24).optional().allow(null),
    estimatedCost: Joi.number().min(0).optional().allow(null)
});

export const updateActivitySchema = Joi.object({
    activityMasterId: Joi.string().uuid().optional(),
    scheduledDate: Joi.date().iso().optional(),
    startTime: Joi.string().pattern(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/).optional().allow(null, ''),
    durationInHours: Joi.number().min(0).max(24).optional().allow(null),
    estimatedCost: Joi.number().min(0).optional().allow(null)
});
