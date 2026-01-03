# 🐳 GlobeTrotter Backend - Docker Quick Start

## One-Command Deployment

```bash
# Start everything (PostgreSQL + Backend API)
sudo docker compose up -d

# Check if running
sudo docker compose ps

# View logs
sudo docker compose logs -f backend

# Test API
curl http://localhost:3000/health
```

## What You Get

✅ **PostgreSQL Database** (Port 5432)  
✅ **Backend API** (Port 3000)  
✅ **Automatic Prisma Migrations**  
✅ **Health Checks Enabled**  
✅ **Production-Ready Configuration**

## Common Commands

```bash
# Stop services
sudo docker compose down

# Rebuild after code changes
sudo docker compose up -d --build

# View backend logs
sudo docker compose logs -f backend

# Access backend container
sudo docker compose exec backend sh

# Backup database
sudo docker compose exec postgres pg_dump -U travelplanar travelplanar_db > backup.sql
```

## Files Created

- ✅ `Dockerfile` - Multi-stage Node.js build
- ✅ `docker-compose.yml` - Complete stack definition
- ✅ `.dockerignore` - Build optimization
- ✅ `.env.docker.example` - Environment template
- ✅ `DOCKER_DEPLOYMENT.md` - Full deployment guide

---

**Ready to deploy!** 🚀
