/**
 * Authentication Routes
 * Defines routes for authentication endpoints
 */

import express from 'express';
import * as authController from '../controllers/auth.controller.js';
import { authenticate } from '../middlewares/auth.js';
import { validate } from '../middlewares/validator.js';
import { registerSchema, loginSchema } from '../validations/auth.validation.js';

const router = express.Router();

// Public routes
router.post('/register', validate(registerSchema), authController.register);
router.post('/login', validate(loginSchema), authController.login);

// Protected routes
router.get('/me', authenticate, authController.getMe);

export default router;
