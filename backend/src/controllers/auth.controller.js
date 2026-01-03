/**
 * Authentication Controller
 * Handles HTTP requests for authentication endpoints
 */

import asyncHandler from '../utils/asyncHandler.js';
import * as authService from '../services/auth.service.js';
import { HttpStatus } from '../constants/enums.js';

/**
 * Register new user
 * POST /api/auth/register
 */
export const register = asyncHandler(async (req, res) => {
    const { user, token } = await authService.register(req.body);

    res.status(HttpStatus.CREATED).json({
        success: true,
        message: 'User registered successfully',
        data: {
            user,
            token
        }
    });
});

/**
 * Login user
 * POST /api/auth/login
 */
export const login = asyncHandler(async (req, res) => {
    const { email, password } = req.body;
    const { user, token } = await authService.login(email, password);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Login successful',
        data: {
            user,
            token
        }
    });
});

/**
 * Get current user profile
 * GET /api/auth/me
 */
export const getMe = asyncHandler(async (req, res) => {
    const user = await authService.getUserById(req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        data: { user }
    });
});
