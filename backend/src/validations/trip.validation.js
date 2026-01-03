/**
 * Trip Validation Schemas
 */

import Joi from 'joi';

export const createTripSchema = Joi.object({
    name: Joi.string().min(3).max(100).required(),
    description: Joi.string().max(500).optional().allow(null, ''),
    startDate: Joi.date().iso().required(),
    endDate: Joi.date().iso().greater(Joi.ref('startDate')).required(),
    coverImage: Joi.string().uri().optional().allow(null, '')
});

export const updateTripSchema = Joi.object({
    name: Joi.string().min(3).max(100).optional(),
    description: Joi.string().max(500).optional().allow(null, ''),
    startDate: Joi.date().iso().optional(),
    endDate: Joi.date().iso().optional(),
    coverImage: Joi.string().uri().optional().allow(null, ''),
    status: Joi.string().valid('DRAFT', 'UPCOMING', 'ONGOING', 'COMPLETED').optional()
});

export const getTripQuery = Joi.object({
    page: Joi.number().integer().min(1).optional().default(1),
    limit: Joi.number().integer().min(1).max(100).optional().default(10),
    status: Joi.string().valid('DRAFT', 'UPCOMING', 'ONGOING', 'COMPLETED').optional()
});
