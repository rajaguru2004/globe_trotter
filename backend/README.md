# GlobeTrotter Backend API

Complete REST API backend for the GlobeTrotter travel planning application built with Node.js, Express, PostgreSQL, and Prisma ORM.

## 🚀 Features

- ✅ JWT Authentication & Authorization
- ✅ User Management (Profile, Soft Delete)
- ✅ Trip Planning (CRUD with Auto-Status Calculation)
- ✅ Itinerary Builder (Trip Stops & Activities)
- ✅ Budget Tracking & Aggregation
- ✅ City & Activity Search
- ✅ Dashboard Analytics
- ✅ Trip Sharing & Community Feed
- ✅ Admin Analytics
- ✅ Comprehensive Input Validation
- ✅ Centralized Error Handling
- ✅ Role-Based Access Control

## 📋 Prerequisites

- Node.js >= 16.x
- PostgreSQL >= 13.x
- npm or yarn

## 🛠️ Installation

```bash
# Clone the repository
cd backend

# Install dependencies
npm install

# Configure environment variables
cp .env.example .env
# Edit .env with your database credentials

# Run database migration
npx prisma migrate dev

# Generate Prisma Client
npx prisma generate

# Start development server
npm run dev
```

## 🌐 Environment Variables

Create a `.env` file with the following:

```env
DATABASE_URL="postgresql://username:password@localhost:5432/globetrotter_db?schema=public"
PORT=3000
NODE_ENV=development
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=15m
```

## 📚 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Authentication Endpoints

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123!"
}
```

#### Get Profile
```http
GET /api/auth/me
Authorization: Bearer <token>
```

### Trip Management

#### Create Trip
```http
POST /api/trips
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Europe Adventure",
  "description": "2-week European tour",
  "startDate": "2026-06-01T00:00:00Z",
  "endDate": "2026-06-15T00:00:00Z"
}
```

#### Get All Trips
```http
GET /api/trips?page=1&limit=10&status=UPCOMING
Authorization: Bearer <token>
```

#### Get Trip by ID
```http
GET /api/trips/:id
Authorization: Bearer <token>
```

#### Update Trip
```http
PUT /api/trips/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Trip Name",
  "status": "ONGOING"
}
```

#### Delete Trip
```http
DELETE /api/trips/:id
Authorization: Bearer <token>
```

### Itinerary Builder

#### Add Stop to Trip
```http
POST /api/itinerary/trips/:tripId/stops
Authorization: Bearer <token>
Content-Type: application/json

{
  "cityId": "city-uuid",
  "startDate": "2026-06-01T00:00:00Z",
  "endDate": "2026-06-05T00:00:00Z",
  "orderIndex": 0
}
```

#### Add Activity to Stop
```http
POST /api/itinerary/stops/:stopId/activities
Authorization: Bearer <token>
Content-Type: application/json

{
  "activityMasterId": "activity-uuid",
  "scheduledDate": "2026-06-02T00:00:00Z",
  "startTime": "09:00",
  "durationInHours": 3,
  "estimatedCost": 50
}
```

#### Reorder Stops
```http
POST /api/itinerary/trips/:tripId/stops/reorder
Authorization: Bearer <token>
Content-Type: application/json

{
  "stops": [
    { "id": "stop-uuid-1", "orderIndex": 0 },
    { "id": "stop-uuid-2", "orderIndex": 1 }
  ]
}
```

### Search

#### Search Cities
```http
GET /api/cities/search?q=Paris&limit=10
Authorization: Bearer <token>
```

#### Search Activities
```http
GET /api/activities/search?q=museum&cityId=city-uuid&limit=20
Authorization: Bearer <token>
```

### Budget & Dashboard

#### Get Trip Budget
```http
GET /api/trips/:tripId/budget
Authorization: Bearer <token>
```

#### Get Dashboard Overview
```http
GET /api/dashboard/overview
Authorization: Bearer <token>
```

### Sharing & Community

#### Share Trip
```http
POST /api/trips/:tripId/share
Authorization: Bearer <token>
```

#### Get Shared Trip (Public)
```http
GET /api/shared/:slug
```

#### Get Community Feed
```http
GET /api/community/feed?page=1&limit=10
Authorization: Bearer <token>
```

#### Copy Shared Trip
```http
POST /api/community/shared-trips/:sharedTripId/copy
Authorization: Bearer <token>
```

### Admin (Requires ADMIN role)

#### Get Platform Stats
```http
GET /api/admin/stats
Authorization: Bearer <token>
```

#### Get Top Cities
```http
GET /api/admin/top-cities?limit=10
Authorization: Bearer <token>
```

## 📦 Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # Prisma client
│   ├── constants/
│   │   └── enums.js             # Application constants
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── user.controller.js
│   │   ├── trip.controller.js
│   │   ├── itinerary.controller.js
│   │   ├── combined.controller.js  # Search, Budget, Dashboard, Sharing
│   │   └── admin.controller.js
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── user.service.js
│   │   ├── trip.service.js
│   │   ├── itinerary.service.js
│   │   ├── search.service.js
│   │   ├── budget.service.js
│   │   ├── dashboard.service.js
│   │   ├── sharing.service.js
│   │   └── admin.service.js
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── user.routes.js
│   │   ├── trip.routes.js
│   │   ├── itinerary.routes.js
│   │   ├── combined.routes.js
│   │   └── admin.routes.js
│   ├── middlewares/
│   │   ├── auth.js              # JWT authentication
│   │   ├── validator.js         # Joi validation
│   │   └── errorHandler.js      # Error handling
│   ├── validations/
│   │   ├── auth.validation.js
│   │   ├── user.validation.js
│   │   ├── trip.validation.js
│   │   └── itinerary.validation.js
│   ├── utils/
│   │   ├── jwt.js               # JWT utilities
│   │   ├── asyncHandler.js      # Async wrapper
│   │   └── errors.js            # Custom error classes
│   └── server.js                # Express app setup
├── prisma/
│   └── schema.prisma            # Database schema
├── .env
├── .env.example
├── package.json
└── README.md
```

## 🗄️ Database Schema

### Transactional Tables

- **users** - User accounts with authentication
- **trips** - User trip planning
- **trip_stops** - Cities within trips
- **activity_instances** - Scheduled activities
- **expenses** - Trip expense tracking
- **public_shared_trips** - Public trip sharing
- **community_posts** - Community feed posts

### Master Data Tables

- **city_master** - Cities with cost indices
- **activity_category_master** - Activity categories
- **activity_master** - Activity templates
- **cost_reference_master** - City cost data
- **currency_master** - Currency exchange rates

## 🔒 Security Features

- **Password Hashing**: bcrypt with salt rounds of 12
- **JWT Tokens**: 15-minute expiry for security
- **Role-Based Access**: USER and ADMIN roles
- **Input Validation**: Joi schemas on all endpoints
- **SQL Injection Protection**: Prisma ORM parameterized queries
- **Ownership Verification**: Users can only access their own data

## 🧪 Testing

```bash
# Test server health
curl http://localhost:3000/health

# Test registration
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123!",
    "firstName": "Test",
    "lastName": "User"
  }'

# Test login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123!"
  }'
```

## 📝 Scripts

```bash
npm run dev              # Start development server with nodemon
npm start                # Start production server
npm run prisma:generate  # Generate Prisma Client
npm run prisma:push      # Push schema to database
npm run prisma:studio    # Open Prisma Studio
```

## 🚧 Development Notes

- All API responses follow consistent format: `{ success: boolean, data?: any, error?: string }`
- Trip status auto-calculates based on dates (UPCOMING → ONGOING → COMPLETED)
- Soft delete pattern used for trips (isDeleted flag)
- Pagination supported on list endpoints
- Search uses case-insensitive fuzzy matching

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Test thoroughly
4. Submit pull request

## 📄 License

ISC

## 👥 Team

Team Skill Hive

---

**Built with ❤️ for hackathon success**
