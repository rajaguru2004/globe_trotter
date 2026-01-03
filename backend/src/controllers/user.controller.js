/**
 * User Controller
 */

import asyncHandler from '../utils/asyncHandler.js';
import * as userService from '../services/user.service.js';
import { HttpStatus } from '../constants/enums.js';

export const getProfile = asyncHandler(async (req, res) => {
    const user = await userService.getProfile(req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        data: { user }
    });
});

export const updateProfile = asyncHandler(async (req, res) => {
    const user = await userService.updateProfile(req.user.id, req.body);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Profile updated successfully',
        data: { user }
    });
});

export const deleteAccount = asyncHandler(async (req, res) => {
    await userService.deleteAccount(req.user.id);

    res.status(HttpStatus.OK).json({
        success: true,
        message: 'Account deleted successfully'
    });
});
