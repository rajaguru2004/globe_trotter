# Prisma + PostgreSQL Complete Guide

Production-ready guide for using Prisma ORM with PostgreSQL in Node.js. Written for developers with MongoDB/Mongoose experience.

---

## 📚 Table of Contents

1. [Prisma vs Mongoose](#prisma-vs-mongoose)
2. [Setup Instructions](#setup-instructions)
3. [Database Sync Strategy](#database-sync-strategy)
4. [Prisma Client Usage](#prisma-client-usage)
5. [Production Best Practices](#production-best-practices)
6. [Common Errors & Solutions](#common-errors--solutions)
7. [Testing the Setup](#testing-the-setup)
8. [Folder Structure](#folder-structure)

---

## Prisma vs Mongoose

### Key Conceptual Differences

| Concept | Mongoose | Prisma |
|---------|----------|--------|
| **Schema Definition** | JavaScript/TypeScript | Prisma Schema Language (.prisma file) |
| **Client Generation** | Model.create() directly available | Must run `prisma generate` first |
| **Migrations** | Manual or via plugins | Built-in migration system |
| **Type Safety** | Requires TypeScript definitions | Auto-generated TypeScript types |
| **Relations** | Ref + populate() | Declarative with `@relation` |
| **Connection** | mongoose.connect() | Auto-managed connection pooling |

### Query Comparison

```javascript
// MONGOOSE
const user = await User.findById(id).populate('trips');
await User.create({ email, name });
await User.findByIdAndUpdate(id, updateData);
await User.findByIdAndDelete(id);

// PRISMA
const user = await prisma.user.findUnique({ 
  where: { id },
  include: { trips: true }  // Like .populate()
});
await prisma.user.create({ data: { email, name } });
await prisma.user.update({ where: { id }, data: updateData });
await prisma.user.delete({ where: { id } });
```

**Key Insight**: Prisma uses `where` clauses for all queries and `include` for relations (similar to populate).

---

## Setup Instructions

### Step 1: Install Dependencies

```bash
cd /home/suryaguru/StudioProjects/flutter_v_338/globe_trotter/backend

# Install production dependencies
npm install express @prisma/client dotenv cors

# Install development dependencies
npm install -D prisma nodemon
```

**Why separate dependencies?**
- `prisma` (CLI) - Development tool for schema management
- `@prisma/client` - Runtime query engine for production

### Step 2: Environment Configuration

The `.env` file is already created with your PostgreSQL credentials:

```env
DATABASE_URL="postgresql://travelplanar:travelplanar_password@localhost:5432/travelplanar_db?schema=public"
```

**Connection String Breakdown:**
- `postgresql://` - Database type (postgres/mysql/sqlite)
- `travelplanar:travelplanar_password` - Username and password
- `localhost:5432` - Host and port (Docker exposes 5432)
- `travelplanar_db` - Database name
- `?schema=public` - PostgreSQL schema (namespace for tables)

**Verify Docker is Running:**
```bash
docker ps
# Should show PostgreSQL container on port 5432
```

### Step 3: Generate Prisma Client

```bash
# Generate the Prisma Client (creates @prisma/client)
npm run prisma:generate
```

**What This Does:**
- Reads `prisma/schema.prisma`
- Generates TypeScript types in `node_modules/@prisma/client`
- Creates type-safe query methods for each model
- **Must run after any schema changes!**

### Step 4: Sync Database Schema

```bash
# Push schema to database (creates tables)
npm run prisma:push
```

**What This Does:**
- Creates `users`, `trips`, `bookings` tables in PostgreSQL
- Applies all field definitions, indexes, and relations
- No migration files generated (perfect for rapid development)

### Step 5: Verify Database

```bash
# Open Prisma Studio (GUI for database)
npm run prisma:studio
```

Opens `http://localhost:5555` - You can:
- View all tables
- Manually create/edit records
- Verify relations work
- Test your schema

---

## Database Sync Strategy

### `prisma db push` vs `prisma migrate dev`

| Feature | `prisma db push` | `prisma migrate dev` |
|---------|------------------|----------------------|
| **Use Case** | Rapid prototyping | Production-ready apps |
| **Migration Files** | ❌ No files created | ✅ Creates SQL migration history |
| **Schema Drift** | Resets on conflicts | Version-controlled migrations |
| **Best For** | Startups, MVPs, fast iteration | Production deployments |
| **Rollback** | ❌ Not possible | ✅ Can rollback migrations |

### Our Choice: `prisma db push`

**Why we use it:**
1. **Fast iteration** - No migration files to manage
2. **Startup-friendly** - Focus on features, not migration history
3. **Direct sync** - Schema changes immediately reflected
4. **Simple workflow** - Edit schema → push → done

**When to switch to migrations:**
- Moving to production
- Need rollback capability
- Team collaboration on schema changes
- Want version-controlled database history

**How to switch later:**
```bash
# Initialize migrations from current schema
npx prisma migrate dev --name init
```

---

## Prisma Client Usage

### Initialization (Singleton Pattern)

**File:** `src/config/database.js`

```javascript
import { PrismaClient } from '@prisma/client';

const globalForPrisma = global;

// Singleton: One client instance across the app
const prisma = globalForPrisma.prisma || new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

export default prisma;
```

**Why This Pattern?**
- **Hot reload safety** - Prevents creating new client on file changes
- **Connection pooling** - Reuses connections efficiently
- **Memory safety** - Avoids "too many clients" errors

### CRUD Operations

#### Create

```javascript
// MONGOOSE STYLE
const user = await User.create({ email: 'test@example.com', name: 'John' });

// PRISMA STYLE
const user = await prisma.user.create({
  data: {
    email: 'test@example.com',
    name: 'John'
  }
});
```

**With Relations:**
```javascript
// Create trip connected to user
const trip = await prisma.trip.create({
  data: {
    title: 'Paris Vacation',
    destination: 'Paris',
    startDate: new Date('2026-06-01'),
    endDate: new Date('2026-06-10'),
    userId: '<user-id>'  // Foreign key
  },
  include: {
    user: true  // Return user data too
  }
});
```

#### Read (Find)

```javascript
// FIND ALL
const users = await prisma.user.findMany({
  orderBy: { createdAt: 'desc' },
  take: 10  // Limit to 10 results
});

// FIND BY ID
const user = await prisma.user.findUnique({
  where: { id: '<user-id>' }
});

// FIND BY EMAIL
const user = await prisma.user.findUnique({
  where: { email: 'test@example.com' }
});

// FIND WITH FILTERS
const trips = await prisma.trip.findMany({
  where: {
    status: 'planned',
    startDate: {
      gte: new Date('2026-01-01')  // Greater than or equal
    }
  }
});
```

**With Relations (Like .populate()):**
```javascript
const user = await prisma.user.findUnique({
  where: { id: '<user-id>' },
  include: {
    trips: true,      // Include all trips
    bookings: {       // Include bookings with filters
      where: { status: 'confirmed' }
    }
  }
});
```

**Nested Reads:**
```javascript
const trip = await prisma.trip.findUnique({
  where: { id: '<trip-id>' },
  include: {
    user: {
      select: {  // Select specific fields
        id: true,
        name: true,
        email: true
      }
    },
    bookings: true
  }
});
```

#### Update

```javascript
// MONGOOSE STYLE
await User.findByIdAndUpdate(id, { name: 'Updated Name' });

// PRISMA STYLE
const user = await prisma.user.update({
  where: { id },
  data: { name: 'Updated Name' }
});

// UPDATE MANY
await prisma.trip.updateMany({
  where: { status: 'ongoing' },
  data: { status: 'completed' }
});
```

#### Delete

```javascript
// DELETE ONE
await prisma.user.delete({
  where: { id }
});

// DELETE MANY
await prisma.booking.deleteMany({
  where: { status: 'cancelled' }
});
```

**Cascade Deletes:**
Our schema uses `onDelete: Cascade`, so deleting a user automatically deletes their trips and bookings.

### Advanced Queries

#### Counting

```javascript
const userCount = await prisma.user.count();
const confirmedBookings = await prisma.booking.count({
  where: { status: 'confirmed' }
});
```

#### Aggregation

```javascript
const stats = await prisma.booking.aggregate({
  _sum: { totalAmount: true },
  _avg: { totalAmount: true },
  _count: true,
  where: { userId: '<user-id>' }
});
```

#### Grouping

```javascript
const tripsByStatus = await prisma.trip.groupBy({
  by: ['status'],
  _count: true
});
```

---

## Production Best Practices

### 1. Singleton Prisma Client ✅

**Already implemented in `src/config/database.js`**

**Why it matters:**
- Prevents "too many database connections" errors
- Handles development hot reloads gracefully
- Ensures efficient connection pooling

### 2. Error Handling

```javascript
import { Prisma } from '@prisma/client';

try {
  await prisma.user.create({ data: { email } });
} catch (error) {
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    if (error.code === 'P2002') {
      // Unique constraint violation
      console.error('Email already exists');
    }
  }
  throw error;
}
```

**Common Prisma Error Codes:**
- `P2002` - Unique constraint violation
- `P2025` - Record not found
- `P1001` - Can't reach database
- `P1017` - Server closed connection

### 3. Environment Variables

**Never commit `.env` to Git!**

```bash
# .gitignore already includes
.env
.env.local
.env.*.local
```

**Production checklist:**
- Use environment-specific `.env` files
- Store credentials in secure vaults (AWS Secrets Manager, etc.)
- Never log `DATABASE_URL`

### 4. Connection Management

**Our server handles this:**

```javascript
// Graceful shutdown in src/server.js
process.on('SIGTERM', async () => {
  await prisma.$disconnect();
  process.exit(0);
});
```

**When to disconnect:**
- Server shutdown
- Serverless function completion
- End of script execution

**When NOT to disconnect:**
- During request handling
- In middleware
- In service functions

### 5. Query Optimization

**Use `select` to fetch only needed fields:**
```javascript
const users = await prisma.user.findMany({
  select: {
    id: true,
    email: true,
    name: true
  }
});
```

**Pagination for large datasets:**
```javascript
const trips = await prisma.trip.findMany({
  skip: (page - 1) * pageSize,
  take: pageSize
});
```

### 6. Logging in Development

Already configured:
```javascript
new PrismaClient({
  log: process.env.NODE_ENV === 'development' 
    ? ['query', 'error', 'warn'] 
    : ['error']
});
```

---

## Common Errors & Solutions

### Error: P1001 - Can't reach database server

```
Error: P1001: Can't reach database server at `localhost:5432`
```

**Causes & Solutions:**

1. **Docker not running**
   ```bash
   docker ps  # Check if PostgreSQL container is running
   docker start <container-name>  # Start container
   ```

2. **Wrong port in .env**
   ```env
   # Verify port matches Docker configuration
   DATABASE_URL="postgresql://...@localhost:5432/..."
   ```

3. **Database not initialized**
   ```bash
   # Check Docker logs
   docker logs <container-name>
   ```

### Error: Prisma Client not generated

```
Error: @prisma/client did not initialize yet
```

**Solution:**
```bash
npm run prisma:generate
```

**Always run after:**
- Installing dependencies
- Changing schema
- Switching branches (if schema changed)

### Error: Port 5432 already in use

```
Error: Port 5432 is already allocated
```

**Solutions:**

1. **Another PostgreSQL instance running**
   ```bash
   sudo systemctl stop postgresql  # Linux
   brew services stop postgresql   # macOS
   ```

2. **Use different port**
   ```yaml
   # docker-compose.yml
   ports:
     - "5433:5432"  # Host port 5433
   ```
   ```env
   # .env
   DATABASE_URL="postgresql://...@localhost:5433/..."
   ```

### Error: Database does not exist

```
Error: Database `travelplanar_db` does not exist
```

**Solution:**
```bash
# Connect to Docker container
docker exec -it <container-name> psql -U travelplanar

# Create database
CREATE DATABASE travelplanar_db;
\q

# Then run
npm run prisma:push
```

### Error: Migration conflicts

```
Error: Schema drift detected
```

**Solution (using db push):**
```bash
# Force push (resets conflicting tables)
npx prisma db push --accept-data-loss
```

**⚠️ Warning:** This can delete data! Only use in development.

---

## Testing the Setup

### 1. Verify Docker & Database

```bash
# Check Docker container
docker ps

# Connect to PostgreSQL
docker exec -it <container-name> psql -U travelplanar -d travelplanar_db

# List tables
\dt

# Exit
\q
```

Should show: `users`, `trips`, `bookings` tables

### 2. Start Development Server

```bash
npm run dev
```

Expected output:
```
╔═══════════════════════════════════════════════════════╗
║  🚀 Globe Trotter Backend Server                      ║
║  Status:     Running                                  ║
║  Port:       3000                                      ║
╚═══════════════════════════════════════════════════════╝
```

### 3. Test Health Endpoint

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "success": true,
  "message": "Server is running",
  "database": "Connected"
}
```

### 4. Create a User

```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "name": "John Doe",
    "phone": "+1234567890"
  }'
```

Expected response:
```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john@example.com",
    "name": "John Doe",
    "phone": "+1234567890",
    "avatar": null,
    "createdAt": "2026-01-03T05:00:00.000Z",
    "updatedAt": "2026-01-03T05:00:00.000Z"
  }
}
```

### 5. Get All Users

```bash
curl http://localhost:3000/api/users
```

### 6. Create a Trip

```bash
# Use the user ID from step 4
curl -X POST http://localhost:3000/api/trips \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Paris Vacation",
    "description": "Summer trip to Paris",
    "destination": "Paris, France",
    "startDate": "2026-06-01T00:00:00Z",
    "endDate": "2026-06-10T00:00:00Z",
    "budget": 5000,
    "userId": "<USER_ID_FROM_STEP_4>"
  }'
```

### 7. Verify in Prisma Studio

```bash
npm run prisma:studio
```

- Open `http://localhost:5555`
- Click on `User` model
- See your created user
- Click on `Trip` model
- See your created trip with user relation

---

## Folder Structure

```
backend/
├── prisma/
│   └── schema.prisma          # Database schema (models, relations)
│
├── src/
│   ├── config/
│   │   └── database.js        # Prisma Client singleton
│   │
│   ├── services/              # Business logic (like Mongoose models)
│   │   ├── userService.js     # User CRUD operations
│   │   ├── tripService.js     # Trip CRUD operations
│   │   └── bookingService.js  # Booking CRUD operations
│   │
│   ├── controllers/           # HTTP request handlers
│   │   ├── userController.js  # User endpoints logic
│   │   └── tripController.js  # Trip endpoints logic
│   │
│   ├── routes/                # Express route definitions
│   │   ├── userRoutes.js      # /api/users routes
│   │   └── tripRoutes.js      # /api/trips routes
│   │
│   └── server.js              # Express app & server setup
│
├── .env                        # Environment variables (NOT in Git)
├── .gitignore                  # Git ignore rules
├── package.json                # Dependencies & scripts
└── PRISMA_GUIDE.md            # This guide

Generated (not in Git):
├── node_modules/               # Dependencies
└── node_modules/@prisma/client/  # Generated Prisma Client
```

**Architecture Pattern: Route → Controller → Service → Database**

1. **Routes** - Define endpoint paths
2. **Controllers** - Handle HTTP req/res, validation
3. **Services** - Business logic, Prisma queries
4. **Database** - Prisma Client singleton

**Benefits:**
- Clear separation of concerns
- Easy to test each layer
- Scalable as app grows
- Similar to standard Express patterns

---

## Quick Reference

### Essential Commands

```bash
# Install dependencies
npm install

# Generate Prisma Client (after schema changes)
npm run prisma:generate

# Sync database schema
npm run prisma:push

# Open database GUI
npm run prisma:studio

# Start development server
npm run dev

# Start production server
npm start
```

### Common Workflows

**Adding a new field to User model:**
1. Edit `prisma/schema.prisma`
2. Run `npm run prisma:generate`
3. Run `npm run prisma:push`
4. Update service/controller if needed

**Creating a new model:**
1. Add model to `schema.prisma`
2. Run `npm run prisma:generate`
3. Run `npm run prisma:push`
4. Create service file (`src/services/modelService.js`)
5. Create controller (`src/controllers/modelController.js`)
6. Create routes (`src/routes/modelRoutes.js`)
7. Mount routes in `server.js`

---

## Additional Resources

- **Prisma Docs**: https://www.prisma.io/docs
- **Prisma Schema Reference**: https://www.prisma.io/docs/reference/api-reference/prisma-schema-reference
- **Error Code Reference**: https://www.prisma.io/docs/reference/api-reference/error-reference
- **Prisma Examples**: https://github.com/prisma/prisma-examples

---

**🎉 Your Prisma + PostgreSQL backend is now ready for development!**
