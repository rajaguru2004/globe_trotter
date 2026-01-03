import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import prisma from './config/database.js';
import errorHandler from './middlewares/errorHandler.js';

// Route imports
import authRoutes from './routes/auth.routes.js';
import userRoutes from './routes/user.routes.js';
import tripRoutes from './routes/trip.routes.js';
import itineraryRoutes from './routes/itinerary.routes.js';
import combinedRoutes from './routes/combined.routes.js';
import adminRoutes from './routes/admin.routes.js';

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
            database: 'Connected',
            timestamp: new Date().toISOString()
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
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/itinerary', itineraryRoutes);
app.use('/api', combinedRoutes); // Search, Budget, Dashboard, Sharing
app.use('/api/admin', adminRoutes);

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Route not found'
    });
});

// Global error handler (must be last)
app.use(errorHandler);

// Start server
const server = app.listen(PORT, () => {
    console.log(`
╔═══════════════════════════════════════════════════════╗
║  🌍 GlobeTrotter Backend API Server                   ║
║                                                        ║
║  Status:     Running                                  ║
║  Port:       ${PORT}                                      ║
║  Mode:       ${process.env.NODE_ENV || 'development'}                            ║
║  Database:   PostgreSQL (Prisma)                      ║
║                                                        ║
║  🔐 Authentication:                                    ║
║  • POST  /api/auth/register                           ║
║  • POST  /api/auth/login                              ║
║  • GET   /api/auth/me                                 ║
║                                                        ║
║  👤 User Management:                                   ║
║  • GET   /api/users/profile                           ║
║  • PUT   /api/users/profile                           ║
║  • DEL   /api/users/account                           ║
║                                                        ║
║  ✈️  Trip Management:                                  ║
║  • POST  /api/trips                                   ║
║  • GET   /api/trips                                   ║
║  • GET   /api/trips/:id                               ║
║  • PUT   /api/trips/:id                               ║
║  • DEL   /api/trips/:id                               ║
║                                                        ║
║  🗺️  Itinerary Builder:                                ║
║  • POST  /api/itinerary/trips/:id/stops               ║
║  • PUT   /api/itinerary/stops/:id                     ║
║  • DEL   /api/itinerary/stops/:id                     ║
║  • POST  /api/itinerary/trips/:id/stops/reorder       ║
║  • POST  /api/itinerary/stops/:id/activities          ║
║  • PUT   /api/itinerary/activities/:id                ║
║  • DEL   /api/itinerary/activities/:id                ║
║                                                        ║
║  🔍 Search:                                            ║
║  • GET   /api/cities/search?q=...                     ║
║  • GET   /api/activities/search?q=...                 ║
║                                                        ║
║  💰 Budget & Dashboard:                                ║
║  • GET   /api/trips/:id/budget                        ║
║  • GET   /api/dashboard/overview                      ║
║                                                        ║
║  🌐 Sharing & Community:                               ║
║  • POST  /api/trips/:id/share                         ║
║  • GET   /api/shared/:slug                            ║
║  • GET   /api/community/feed                          ║
║  • POST  /api/community/shared-trips/:id/copy         ║
║                                                        ║
║  🛠️  Admin (ADMIN role required):                      ║
║  • GET   /api/admin/stats                             ║
║  • GET   /api/admin/top-cities                        ║
║                                                        ║
║  📝 Health Check:                                      ║
║  • GET   /health                                      ║
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
