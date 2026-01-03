/**
 * Error Handling Middleware
 * Centralized error handler for all application errors
 */

import { AppError } from '../utils/errors.js';
import { HttpStatus } from '../constants/enums.js';

/**
 * Global error handler middleware
 */
const errorHandler = (err, req, res, next) => {
    let error = { ...err };
    error.message = err.message;

    // Log error in development mode
    if (process.env.NODE_ENV === 'development') {
        console.error('Error:', {
            message: error.message,
            stack: err.stack,
            ...error
        });
    }

    // Prisma errors
    if (err.code === 'P2002') {
        error = new AppError('Duplicate field value entered', HttpStatus.CONFLICT);
    }

    if (err.code === 'P2025') {
        error = new AppError('Record not found', HttpStatus.NOT_FOUND);
    }

    // Joi validation errors
    if (err.isJoi) {
        error = new AppError(err.details[0].message, HttpStatus.BAD_REQUEST);
    }

    // JWT errors
    if (err.name === 'JsonWebTokenError') {
        error = new AppError('Invalid token', HttpStatus.UNAUTHORIZED);
    }

    if (err.name === 'TokenExpiredError') {
        error = new AppError('Token expired', HttpStatus.UNAUTHORIZED);
    }

    const statusCode = error.statusCode || HttpStatus.INTERNAL_SERVER_ERROR;
    const message = error.message || 'Internal server error';

    res.status(statusCode).json({
        success: false,
        error: message,
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};

export default errorHandler;
