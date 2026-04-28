# Oracle MySQL Options for AgriConnect

## Overview

When deploying AgriConnect on Oracle Cloud Free Tier, you have **two database options**. This guide explains both so you can pick the right one for your situation.

---

## Option 1: MySQL HeatWave Free Tier (Recommended if Available)

Oracle offers a **always-free MySQL HeatWave** instance — this is a **fully managed database**, meaning Oracle handles backups, patches, and uptime for you.

### ✅ Pros
- No RAM used from your VM (database runs on separate Oracle-managed hardware)
- Automatic backups included
- 50 GB storage free
- Survives even if your VM is deleted

### ❌ Cons
- **Not available in all Oracle regions** — check availability first
- Slightly more complex setup (need to configure VCN Security List)
- Takes 10–15 minutes to provision

### Is It Available in Your Region?
1. Log into [cloud.oracle.com](https://cloud.oracle.com)
2. Go to **Databases → MySQL HeatWave**
3. Click **Create DB System**
4. Select **"Always Free"** shape — if it appears, it's available!
5. If you don't see "Always Free", your region doesn't support it → use Option 2

### Connection String Format (HeatWave)
```properties
# In your application-production.properties or .env file:
DB_URL=jdbc:mysql://10.0.1.X:3306/agriconnect?useSSL=true&requireSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true

# Note: Use the PRIVATE IP of the MySQL instance (not public IP).
# Your VM and MySQL must be in the same VCN (Virtual Cloud Network).
DB_USER=agriconnect_admin
DB_PASS=YourStrongPassword123!
```

### VCN Security List Rule (Required)
You must allow port 3306 between your VM and MySQL:
- Go to: Networking → VCN → Security Lists → Add Ingress Rule
- Source CIDR: `10.0.0.0/16` (your VCN range)
- Port: `3306`
- Protocol: TCP

### Initialize the Schema
```bash
# SSH into your Oracle VM, then:
mysql -h 10.0.1.X -u agriconnect_admin -p agriconnect < /opt/agriconnect/schema.sql
```

---

## Option 2: MySQL in Docker (Simpler, Works Everywhere)

If MySQL HeatWave isn't available, just run MySQL as a Docker container on your VM alongside the app. Your existing `docker-compose.yml` already does this!

### ✅ Pros
- Works in every Oracle region
- Already configured in your `docker-compose.yml`
- Zero extra setup needed
- `schema.sql` is auto-loaded on first boot

### ❌ Cons
- Shares the VM's 1 GB RAM (that's why `swap-setup.sh` is important!)
- Data is lost if the Docker volume is deleted
- You are responsible for backups

### Connection String Format (Docker MySQL)
```properties
# docker-compose.yml already sets this automatically:
DB_URL=jdbc:mysql://db:3306/agriconnect?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true

# 'db' is the Docker service name — Docker's internal DNS resolves it.
# This only works container-to-container. From outside, use 'localhost'.
DB_USER=agriconnect_user
DB_PASS=YourStrongPassword123!
```

### Backup Docker MySQL Data
```bash
# Run this daily (add to cron):
docker exec agriconnect_db \
  mysqldump -u root -p"$DB_PASS" agriconnect \
  > /opt/agriconnect/backups/backup-$(date +%Y%m%d).sql

# Keep last 7 days only:
find /opt/agriconnect/backups -name "*.sql" -mtime +7 -delete
```

---

## Memory Tuning for Docker MySQL on 1GB VM

Add these to your `docker-compose.yml` under the `db` service to prevent MySQL from consuming all available RAM:

```yaml
services:
  db:
    image: mysql:8.3
    # ... existing config ...
    command: >
      --innodb-buffer-pool-size=256M
      --max-connections=50
      --query-cache-size=0
      --tmp-table-size=32M
      --max-heap-table-size=32M
    deploy:
      resources:
        limits:
          memory: 512M
```

---

## Quick Comparison Table

| Feature | HeatWave Free | Docker MySQL |
|---|---|---|
| Setup time | 15–20 min | Already done |
| RAM usage on VM | 0 MB | ~300–400 MB |
| Backups | Automatic | Manual |
| Availability | Region-dependent | Always |
| Data persistence | Oracle-managed | Docker volume |
| Best for | Long-term portfolio | Quick demo |

---

## Recommendation for a Student Portfolio

> **Use Docker MySQL** unless you plan to keep this running for 6+ months.
> It's already configured, uses your existing `docker-compose.yml`, and
> gets you deployed in minutes rather than spending an hour on Oracle networking.
> If the app gains real users, migrate to MySQL HeatWave then.
