import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import userRoutes from './routes/userRoutes.js';
import tripRoutes from './routes/tripRoutes.js';
import prisma from './config/database.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware (development)
if (process.env.NODE_ENV === 'development') {
    app.use((req, res, next) => {
        console.log(`${req.method} ${req.path}`);
        next();
    });
}

// Health check endpoint
app.get('/health', async (req, res) => {
    try {
        // Test database connection
        await prisma.$queryRaw`SELECT 1`;
        res.status(200).json({
            success: true,
            message: 'Server is running',
            database: 'Connected'
        });
    } catch (error) {
        res.status(503).json({
            success: false,
            message: 'Server is running but database connection failed',
            database: 'Disconnected',
            error: error.message
        });
    }
});

// API Routes
app.use('/api/users', userRoutes);
app.use('/api/trips', tripRoutes);

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Route not found'
    });
});

// Global error handler
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});

// Start server
const server = app.listen(PORT, () => {
    console.log(`
╔═══════════════════════════════════════════════════════╗
║  🚀 Globe Trotter Backend Server                      ║
║                                                        ║
║  Status:     Running                                  ║
║  Port:       ${PORT}                                      ║
║  Mode:       ${process.env.NODE_ENV || 'development'}                            ║
║  Database:   PostgreSQL (Prisma)                      ║
║                                                        ║
║  Endpoints:                                           ║
║  • GET  /health                                       ║
║  • /api/users   - User management                     ║
║  • /api/trips   - Trip management                     ║
╚═══════════════════════════════════════════════════════╝
  `);
});

// Graceful shutdown
const gracefulShutdown = async (signal) => {
    console.log(`\n${signal} received. Starting graceful shutdown...`);

    server.close(async () => {
        console.log('HTTP server closed');

        try {
            await prisma.$disconnect();
            console.log('Database connection closed');
            process.exit(0);
        } catch (error) {
            console.error('Error during shutdown:', error);
            process.exit(1);
        }
    });

    // Force shutdown after 10 seconds
    setTimeout(() => {
        console.error('Forced shutdown after timeout');
        process.exit(1);
    }, 10000);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

export default app;
