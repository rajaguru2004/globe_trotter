/**
 * Admin Controller & Routes
 */

import express from 'express';
import asyncHandler from '../utils/asyncHandler.js';
import * as adminService from '../services/admin.service.js';
import { authenticate, requireRole } from '../middlewares/auth.js';
import { HttpStatus } from '../constants/enums.js';

// Controllers
const getStats = asyncHandler(async (req, res) => {
    const stats = await adminService.getStats();
    res.status(HttpStatus.OK).json({ success: true, data: { stats } });
});

const getTopCities = asyncHandler(async (req, res) => {
    const cities = await adminService.getTopCities(req.query.limit);
    res.status(HttpStatus.OK).json({ success: true, data: { cities } });
});

// Routes
const router = express.Router();
router.use(authenticate, requireRole('ADMIN'));

router.get('/stats', getStats);
router.get('/top-cities', getTopCities);

export default router;
