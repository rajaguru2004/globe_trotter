# GlobeTrotter Backend - Docker Deployment Guide

## 🐳 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose V2

### One-Command Deployment

```bash
# Start all services (PostgreSQL + Backend)
sudo docker compose up -d

# Check status
sudo docker compose ps

# View logs
sudo docker compose logs -f backend

# Stop all services
sudo docker compose down
```

---

## 📋 What Gets Deployed

When you run `docker compose up -d`, the following services start:

1. **PostgreSQL Database** (`globetrotter_postgres`)
   - Port: 5432
   - Database: `travelplanar_db`
   - User: `travelplanar`
   - Password: `travelplanar_password`
   - Health checks enabled

2. **Backend API** (`globetrotter_backend`)
   - Port: 3000
   - Automatic Prisma migrations on startup
   - Health checks enabled
   - Waits for PostgreSQL to be healthy

---

## 🔧 Configuration

### Environment Variables

Create `.env.docker` file for custom configuration:

```bash
cp .env.docker.example .env.docker
```

Then edit `.env.docker`:

```bash
# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=15m

# CORS Configuration
ALLOWED_ORIGINS=http://your-frontend.com,http://another-domain.com
```

Docker Compose will automatically load this file.

---

## 🚀 Deployment Steps

### 1. Build the Docker Image

```bash
sudo docker compose build
```

### 2. Start Services

```bash
# Start in detached mode
sudo docker compose up -d

# Or with logs
sudo docker compose up
```

### 3. Verify Deployment

```bash
# Check service health
curl http://localhost:3000/health

# Expected response:
# {
#   "success": true,
#   "message": "Server is running",
#   "database": "Connected",
#   "timestamp": "..."
# }
```

---

## 📊 Managing Services

### View Logs

```bash
# All services
sudo docker compose logs -f

# Specific service
sudo docker compose logs -f backend
sudo docker compose logs -f postgres
```

### Restart Services

```bash
# Restart all
sudo docker compose restart

# Restart specific service
sudo docker compose restart backend
```

### Stop Services

```bash
# Stop without removing
sudo docker compose stop

# Stop and remove containers
sudo docker compose down

# Stop and remove containers + volumes (⚠️ deletes database data)
sudo docker compose down -v
```

---

## 🔄 Updates & Migrations

### Update Code

```bash
# Pull latest code
git pull

# Rebuild and restart
sudo docker compose up -d --build
```

### Run Migrations

Migrations run automatically on container start. To run manually:

```bash
sudo docker compose exec backend npx prisma migrate deploy
```

### Access Backend Container

```bash
sudo docker compose exec backend sh
```

---

## 🐛 Troubleshooting

### Backend Won't Start

```bash
# Check logs
sudo docker compose logs backend

# Common issues:
# - Database not ready: Wait for postgres health check
# - Migration failed: Check database credentials
# - Port conflict: Change port in docker-compose.yml
```

### Database Connection Issues

```bash
# Test database connection
sudo docker compose exec postgres psql -U travelplanar -d travelplanar_db -c "SELECT 1;"

# Check database logs
sudo docker compose logs postgres
```

### Reset Database

```bash
# ⚠️ WARNING: This deletes all data!
sudo docker compose down -v
sudo docker compose up -d
```

### Port Already in Use

```bash
# Check what's using the port
sudo lsof -i :3000
sudo lsof -i :5432

# Either stop the conflicting service or change ports in docker-compose.yml
```

---

## 🔒 Production Deployment

### Security Checklist

- [ ] Change JWT_SECRET to a strong random value
- [ ] Update PostgreSQL password
- [ ] Configure CORS for your frontend domain
- [ ] Enable SSL/TLS (use nginx reverse proxy)
- [ ] Set up firewall rules
- [ ] Enable Docker logging driver
- [ ] Set up automated backups

### Production docker-compose.yml

```yaml
# Add to services.backend in docker-compose.yml
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          memory: 256M
      restart_policy:
        condition: on-failure
        max_attempts: 3
```

---

## 📦 Backup & Restore

### Backup Database

```bash
# Create backup
sudo docker compose exec postgres pg_dump -U travelplanar travelplanar_db > backup.sql

# With timestamp
sudo docker compose exec postgres pg_dump -U travelplanar travelplanar_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database

```bash
# Restore from backup
sudo docker compose exec -T postgres psql -U travelplanar -d travelplanar_db < backup.sql
```

---

## 📈 Monitoring

### Health Checks

```bash
# Backend health
curl http://localhost:3000/health

# Container health
sudo docker compose ps
```

### Resource Usage

```bash
# View stats
sudo docker stats globetrotter_backend globetrotter_postgres
```

---

## 🌐 Accessing Services

- **Backend API**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **PostgreSQL**: localhost:5432
- **Prisma Studio** (if enabled): http://localhost:5555

---

## 🎯 Quick Commands Reference

```bash
# Start services
sudo docker compose up -d

# Stop services
sudo docker compose down

# Rebuild and restart
sudo docker compose up -d --build

# View logs
sudo docker compose logs -f

# Check status
sudo docker compose ps

# Access backend shell
sudo docker compose exec backend sh

# Run migrations
sudo docker compose exec backend npx prisma migrate deploy

# Backup database
sudo docker compose exec postgres pg_dump -U travelplanar travelplanar_db > backup.sql

# Check health
curl http://localhost:3000/health
```

---

## 🆘 Support

For issues or questions:
1. Check logs: `sudo docker compose logs -f`
2. Verify health: `sudo docker compose ps`
3. Review configuration in `docker-compose.yml`

---

**Built with ❤️ for Team Skill Hive**
