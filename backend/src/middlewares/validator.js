/**
 * Request Validation Middleware
 * Validates request data against Joi schemas
 */

import { ValidationError } from '../utils/errors.js';

/**
 * Validate request data against Joi schema
 * @param {Object} schema - Joi validation schema
 * @param {string} property - Request property to validate (body, params, query)
 */
export const validate = (schema, property = 'body') => {
    return (req, res, next) => {
        const { error, value } = schema.validate(req[property], {
            abortEarly: false,
            stripUnknown: true
        });

        if (error) {
            const errorMessage = error.details.map(detail => detail.message).join(', ');
            throw new ValidationError(errorMessage);
        }

        // Replace request data with validated and sanitized data
        req[property] = value;
        next();
    };
};
