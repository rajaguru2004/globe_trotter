/**
 * User Validation Schemas
 */

import Joi from 'joi';

export const updateProfileSchema = Joi.object({
    firstName: Joi.string().min(2).max(50).optional(),
    lastName: Joi.string().min(2).max(50).optional(),
    profileImage: Joi.string().uri().optional().allow(null, '')
});
