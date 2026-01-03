import { PrismaClient } from '@prisma/client';

/**
 * Prisma Client Singleton Pattern (Production Best Practice)
 * 
 * WHY THIS IS IMPORTANT:
 * - Prevents creating multiple Prisma Client instances
 * - Handles development server restarts (hot reloading)
 * - Ensures connection pooling works efficiently
 * 
 * HOW IT WORKS:
 * - In production: Creates one client instance
 * - In development: Stores client in global scope to survive hot reloads
 * 
 * THINK OF IT LIKE: Creating a single MongoDB connection that's reused
 */

const globalForPrisma = global;

const prisma = globalForPrisma.prisma || new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

if (process.env.NODE_ENV !== 'production') {
    globalForPrisma.prisma = prisma;
}

// Graceful shutdown handler
process.on('beforeExit', async () => {
    await prisma.$disconnect();
});

export default prisma;
