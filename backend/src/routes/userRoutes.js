import express from 'express';
import * as userController from '../controllers/userController.js';

const router = express.Router();

/**
 * User Routes
 * Base path: /api/users
 */

// POST /api/users - Create new user
router.post('/', userController.createUser);

// GET /api/users - Get all users
router.get('/', userController.getAllUsers);

// GET /api/users/:id - Get user by ID
router.get('/:id', userController.getUserById);

// PUT /api/users/:id - Update user
router.put('/:id', userController.updateUser);

// DELETE /api/users/:id - Delete user
router.delete('/:id', userController.deleteUser);

export default router;
