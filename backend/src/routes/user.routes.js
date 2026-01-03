/**
 * User Routes
 */

import express from 'express';
import * as userController from '../controllers/user.controller.js';
import { authenticate } from '../middlewares/auth.js';
import { validate } from '../middlewares/validator.js';
import { updateProfileSchema } from '../validations/user.validation.js';

const router = express.Router();

// All user routes require authentication
router.use(authenticate);

router.get('/profile', userController.getProfile);
router.put('/profile', validate(updateProfileSchema), userController.updateProfile);
router.delete('/account', userController.deleteAccount);

export default router;
