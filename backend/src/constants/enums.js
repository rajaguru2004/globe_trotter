/**
 * Application Constants and Enums
 * Centralized location for all application-level constants
 */

// User Roles
export const UserRole = {
    USER: 'USER',
    ADMIN: 'ADMIN'
};

// Trip Status
export const TripStatus = {
    DRAFT: 'DRAFT',
    UPCOMING: 'UPCOMING',
    ONGOING: 'ONGOING',
    COMPLETED: 'COMPLETED'
};

// Expense Categories
export const ExpenseCategory = {
    STAY: 'STAY',
    FOOD: 'FOOD',
    ACTIVITY: 'ACTIVITY',
    TRANSPORT: 'TRANSPORT'
};

// HTTP Status Codes
export const HttpStatus = {
    OK: 200,
    CREATED: 201,
    NO_CONTENT: 204,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_SERVER_ERROR: 500
};

// Pagination Defaults
export const Pagination = {
    DEFAULT_PAGE: 1,
    DEFAULT_LIMIT: 10,
    MAX_LIMIT: 100
};

// Date Formats
export const DateFormat = {
    ISO: 'YYYY-MM-DD',
    DATETIME: 'YYYY-MM-DD HH:mm:ss'
};

// Error Messages
export const ErrorMessages = {
    UNAUTHORIZED: 'Authentication required',
    FORBIDDEN: 'You do not have permission to perform this action',
    NOT_FOUND: 'Resource not found',
    VALIDATION_ERROR: 'Validation failed',
    INTERNAL_ERROR: 'An internal error occurred',
    INVALID_CREDENTIALS: 'Invalid email or password',
    EMAIL_EXISTS: 'Email already registered',
    TRIP_NOT_FOUND: 'Trip not found',
    NOT_TRIP_OWNER: 'You are not the owner of this trip'
};
