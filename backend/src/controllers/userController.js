import * as userService from '../services/userService.js';

/**
 * User Controller - Express Request Handlers
 * Handles HTTP requests and responses
 */

// Create user
export const createUser = async (req, res) => {
    try {
        const { email, name, phone, avatar } = req.body;

        // Basic validation
        if (!email) {
            return res.status(400).json({
                success: false,
                error: 'Email is required'
            });
        }

        // Check if user already exists
        const existingUser = await userService.getUserByEmail(email);
        if (existingUser) {
            return res.status(409).json({
                success: false,
                error: 'User with this email already exists'
            });
        }

        const user = await userService.createUser({ email, name, phone, avatar });

        res.status(201).json({
            success: true,
            data: user
        });
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to create user',
            message: error.message
        });
    }
};

// Get all users
export const getAllUsers = async (req, res) => {
    try {
        const users = await userService.getAllUsers();

        res.status(200).json({
            success: true,
            data: users,
            count: users.length
        });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch users',
            message: error.message
        });
    }
};

// Get user by ID
export const getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await userService.getUserById(id);

        if (!user) {
            return res.status(404).json({
                success: false,
                error: 'User not found'
            });
        }

        res.status(200).json({
            success: true,
            data: user
        });
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch user',
            message: error.message
        });
    }
};

// Update user
export const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const updateData = req.body;

        // Check if user exists
        const existingUser = await userService.getUserById(id);
        if (!existingUser) {
            return res.status(404).json({
                success: false,
                error: 'User not found'
            });
        }

        const user = await userService.updateUser(id, updateData);

        res.status(200).json({
            success: true,
            data: user
        });
    } catch (error) {
        console.error('Error updating user:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to update user',
            message: error.message
        });
    }
};

// Delete user
export const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        // Check if user exists
        const existingUser = await userService.getUserById(id);
        if (!existingUser) {
            return res.status(404).json({
                success: false,
                error: 'User not found'
            });
        }

        await userService.deleteUser(id);

        res.status(200).json({
            success: true,
            message: 'User deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete user',
            message: error.message
        });
    }
};
