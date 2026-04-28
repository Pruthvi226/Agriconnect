# 🌾 AgriConnect — Free Deployment Guide

> **Hey there! 👋** This guide was written for you — a student or intern deploying
> AgriConnect for your portfolio or a demo. No prior DevOps experience needed.
> Just follow the steps and you'll have a live URL to share within 30 minutes!

---

## 📋 Prerequisites

Make sure you have these before starting:

| Tool | Check Command | Install Link |
|---|---|---|
| Git | `git --version` | [git-scm.com](https://git-scm.com) |
| Java 21 JDK | `java --version` | [adoptium.net](https://adoptium.net) |
| Maven 3.9+ | `mvn --version` | [maven.apache.org](https://maven.apache.org) |
| Docker Desktop | `docker --version` | [docker.com/get-started](https://www.docker.com/get-started) |
| Node.js 18+ | `node --version` | [nodejs.org](https://nodejs.org) (for Railway CLI) |

---

## 🤔 Which Option Should I Pick?

```
┌─────────────────────────────────────────────────────────────┐
│  I need a live URL ASAP for a job interview / demo call     │
│  → Choose OPTION A: Railway (30 min, no credit card)        │
├─────────────────────────────────────────────────────────────┤
│  I want something always-on for my resume for months        │
│  → Choose OPTION B: Oracle Cloud (1-2 hrs, always free)     │
├─────────────────────────────────────────────────────────────┤
│  I'm not sure / first time deploying                        │
│  → Start with Railway. You can migrate to Oracle later.     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚂 OPTION A: Railway (Recommended for Quick Demos)

**Cost:** Free (500 hours/month on Hobby plan — enough for ~3 weeks of 24/7 uptime)
**Estimated setup time:** 20–30 minutes
**Best for:** Job interviews, college presentations, short-term demos

### What Railway Gives You
- Automatic HTTPS URL (e.g., `agriconnect.up.railway.app`)
- Managed MySQL database
- Auto-restarts if app crashes
- Free subdomain you can share right away

### Step 1 — Prepare Your Code

```bash
# Make sure the Railway config file is committed to Git
git add railway.toml src/main/resources/application-railway.properties
git commit -m "chore: add Railway deployment config"
git push origin main
```

### Step 2 — Run the Deploy Script

```bash
# On Windows, use Git Bash or WSL:
chmod +x deploy/railway-deploy.sh
./deploy/railway-deploy.sh
```

**Or run each command manually** (recommended for first time):

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login (opens your browser)
railway login

# 3. Create project
railway init

# 4. Build your WAR file
mvn clean package -DskipTests

# 5. Set your environment variables
railway variables set SPRING_PROFILES_ACTIVE=railway
railway variables set DB_URL="jdbc:mysql://YOUR_HOST:PORT/railway?useSSL=true&serverTimezone=UTC"
railway variables set DB_USER="your_mysql_user"
railway variables set DB_PASS="your_mysql_password"
railway variables set JWT_SECRET="$(openssl rand -hex 32)"
railway variables set AES_SECRET_KEY="$(openssl rand -hex 16)"

# 6. Deploy!
railway up

# 7. Get your URL
railway domain
```

### Step 3 — Add MySQL in Railway Dashboard

1. Go to [railway.app/dashboard](https://railway.app/dashboard)
2. Open your project → Click **[ + New ]**
3. Select **Database → MySQL**
4. Once provisioned, click the MySQL service → **Variables**
5. Copy `MYSQLDOMAIN`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD`
6. Go to your App service → **Variables** → add:
   - `DB_URL` = `jdbc:mysql://{MYSQLDOMAIN}:{MYSQLPORT}/{MYSQLDATABASE}?useSSL=true&serverTimezone=UTC`
   - `DB_USER` = value from `MYSQLUSER`
   - `DB_PASS` = value from `MYSQLPASSWORD`

### Step 4 — Load Your Database Schema

```bash
# Connect to Railway's MySQL and run your schema:
railway run mysql -h $MYSQLDOMAIN -u $MYSQLUSER -p$MYSQLPASSWORD $MYSQLDATABASE < schema.sql
```

### Step 5 — Share Your URL

```
https://YOUR-PROJECT-NAME.up.railway.app
```

That's it! Add this to your resume. ✅

---

## ☁️ OPTION B: Oracle Cloud (Always-Free, Best for Portfolio)

**Cost:** Completely FREE forever (Oracle Always Free tier)
**Estimated setup time:** 60–90 minutes
**Best for:** Long-term portfolio, LinkedIn profile, showing in interviews months later

### What Oracle Gives You
- 2 AMD Micro VMs (1 OCPU, 1GB RAM each) **forever**
- 200 GB block storage
- Static IP address
- Full control (root access via SSH)

### Step 1 — Create an Oracle Cloud Account

1. Go to [cloud.oracle.com](https://cloud.oracle.com) → **Start for Free**
2. Use your real name and a valid credit card (required for verification — **you won't be charged**)
3. Select a **Home Region** close to your location (choose carefully — you can't change it)
4. Wait for account activation email (usually 5–10 minutes)

### Step 2 — Create Your Free VM

1. Login → **Compute → Instances → Create Instance**
2. Name: `agriconnect-server`
3. Shape: Click **Change Shape** → select **VM.Standard.E2.1.Micro** (Always Free)
4. OS Image: **Ubuntu 22.04 Minimal** (recommended)
5. Under **Add SSH Keys** → upload your public key (`~/.ssh/id_rsa.pub`)
   - If you don't have an SSH key: `ssh-keygen -t rsa -b 4096`
6. Click **Create**

### Step 3 — SSH Into Your VM

```bash
# Replace with your VM's Public IP (shown in Oracle Console)
ssh -i ~/.ssh/id_rsa ubuntu@YOUR_VM_PUBLIC_IP
```

### Step 4 — Upload and Run Setup Scripts

```bash
# From your local machine — upload the deploy scripts:
scp -i ~/.ssh/id_rsa deploy/swap-setup.sh ubuntu@YOUR_VM_IP:~/
scp -i ~/.ssh/id_rsa deploy/oracle-setup.sh ubuntu@YOUR_VM_IP:~/

# SSH back in, then run swap FIRST (protects against OOM):
sudo chmod +x swap-setup.sh oracle-setup.sh
sudo ./swap-setup.sh

# Then run the main setup (edit REPO_URL inside the script first!):
sudo ./oracle-setup.sh
```

### Step 5 — Open Oracle's Cloud Firewall

> ⚠️ This step is often forgotten and causes "app not accessible" issues!

1. Oracle Console → **Networking → Virtual Cloud Networks**
2. Click your VCN → **Security Lists** → **Default Security List**
3. Click **Add Ingress Rules** → Add two rules:
   - Port 80 (HTTP): Source `0.0.0.0/0`, Protocol TCP, Port 80
   - Port 443 (HTTPS): Source `0.0.0.0/0`, Protocol TCP, Port 443
4. Click **Add Ingress Rules**

### Step 6 — Set Up Health Monitoring (Optional but Recommended)

```bash
# Upload and install the health monitor:
scp -i ~/.ssh/id_rsa deploy/healthcheck-cron.sh ubuntu@YOUR_VM_IP:~/

ssh ubuntu@YOUR_VM_IP
sudo cp healthcheck-cron.sh /usr/local/bin/agriconnect-healthcheck.sh
sudo chmod +x /usr/local/bin/agriconnect-healthcheck.sh

# Edit the script with your email details:
sudo nano /usr/local/bin/agriconnect-healthcheck.sh

# Add to cron (runs every 5 minutes):
sudo crontab -e
# Add this line:
# */5 * * * * /usr/local/bin/agriconnect-healthcheck.sh
```

---

## 🐛 Common Errors & Fixes

### ❌ "WAR not found" on Railway
**Fix:** Build the WAR first: `mvn clean package -DskipTests`
Then check `target/agriconnect.war` exists before `railway up`

### ❌ Health check fails on Railway (app shows as crashed)
**Fix:** Your app probably doesn't have Spring Actuator exposed.
Change `healthcheckPath` in `railway.toml` to `"/"` or `"/login"`.
Or add Actuator: in `pom.xml`, add `spring-boot-actuator` dependency.

### ❌ "Access denied for user" on Railway MySQL
**Fix:** Double-check your `DB_URL`, `DB_USER`, `DB_PASS` variables.
Run: `railway variables` to see what's set.
Make sure there are no trailing spaces in the values.

### ❌ App starts but shows blank page or 404
**Fix:** Your WAR is deployed as ROOT context, so URLs should work from `/`.
Check logs: `railway logs` or `docker compose logs app`

### ❌ Oracle VM: app works locally but not from browser
**Fix:** Two firewalls to check:
1. **UFW** (inside VM): `sudo ufw status` — port 80 should show ALLOW
2. **iptables** (Oracle OS layer): `sudo iptables -L INPUT -n` — check port 80
3. **Oracle Security List** (cloud level): See Step 5 in Option B above

### ❌ Oracle VM: "Out of memory" / app keeps crashing
**Fix:** Run `swap-setup.sh` first! Then restart: `docker compose restart`
Also check: `free -h` to see current RAM/swap usage.

### ❌ Oracle VM: Docker compose not found
**Fix:** Install docker-compose-plugin: `sudo apt install docker-compose-plugin`
Then use `docker compose` (space, not hyphen).

### ❌ Schema not loading / tables don't exist
```bash
# Manually import schema on Railway:
railway run mysql < schema.sql

# Manually import schema on Oracle VM:
docker exec -i agriconnect_db mysql -u agriconnect_user -p"$DB_PASS" agriconnect < /opt/agriconnect/schema.sql
```

---

## 📁 Files Created for You

```
AgriConnect/
├── railway.toml                              ← Railway build + deploy config
├── deploy/
│   ├── railway-deploy.sh                     ← Option A step-by-step script
│   ├── oracle-setup.sh                       ← Option B VM setup script
│   ├── oracle-mysql-config.md                ← MySQL HeatWave vs Docker guide
│   ├── swap-setup.sh                         ← RAM fix for Oracle 1GB VM
│   └── healthcheck-cron.sh                   ← Auto health monitor + email alerts
└── src/main/resources/
    └── application-railway.properties        ← Railway Spring profile
```

---

## 🎯 Adding Your Live URL to Your Resume / Portfolio

Once deployed, here's how to present it professionally:

### On Your Resume
```
AgriConnect — Agricultural Marketplace Platform         [GitHub] [Live Demo]
• Full-stack Java web app: Spring MVC 6, Hibernate 6, MySQL 8, Spring Security
• Deployed on Railway (Docker/Tomcat 10) with automated health monitoring
• Features: farmer listings, bidding system, matchmaking, notifications
• Tech: Java 21, JSP/JSTL, JWT authentication, AES encryption
```

### On LinkedIn
Post a short video demo walking through the app features, with your live URL in the caption. Use hashtags: `#Java #SpringMVC #Hibernate #DevOps #Portfolio`

### In Interviews
> *"I deployed AgriConnect on Railway's free tier using Docker and Tomcat.
> The app auto-restarts on failure, and I have a cron-based health monitor
> that emails me if it goes down. Here's the live link..."*

This shows you understand production deployment, not just coding. 💪

---

## 📊 Resource Usage Estimates

| Platform | RAM Used | Storage | Monthly Cost |
|---|---|---|---|
| Railway (free) | ~512 MB | Managed | $0 (500 hrs/mo) |
| Oracle VM | ~800 MB (with swap) | 50 GB free | $0 forever |
| Oracle MySQL HeatWave | 0 (separate) | 50 GB free | $0 forever |

---

## 🆘 Still Stuck?

1. Check logs first: `railway logs` or `docker compose logs app --tail 100`
2. Search the error on [stackoverflow.com](https://stackoverflow.com)
3. Railway Discord: [discord.gg/railway](https://discord.gg/railway) — very active community
4. Oracle Cloud forums: [community.oracle.com](https://community.oracle.com)

**Good luck with your deployment! You've got this! 🌾🚀**
