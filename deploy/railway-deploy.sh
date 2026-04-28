#!/usr/bin/env bash
# ============================================================
#  railway-deploy.sh — Deploy AgriConnect to Railway (Free Tier)
#  Run this script step by step OR execute it all at once.
#  Estimated time: ~15 minutes for first-time setup
# ============================================================
set -e  # Stop immediately if any command fails

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   🚂  AgriConnect → Railway Deployment Script           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 1 — Install the Railway CLI
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 1: Installing Railway CLI..."
echo "   This gives you the 'railway' command to control your project."
echo "   Requires Node.js ≥ 18. Check with: node --version"
echo ""
npm install -g @railway/cli
echo "✅  Railway CLI installed. Version:"
railway --version
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 2 — Login to Railway
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 2: Logging into Railway..."
echo "   Your browser will open. Sign in with GitHub (recommended)."
echo "   Railway gives 500 free hours/month on the Hobby plan."
echo ""
railway login
echo "✅  Logged in!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 3 — Create a new Railway project
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 3: Initializing Railway project in this directory..."
echo "   This creates a railway.json linking this folder to your Railway project."
echo "   Give your project a name like: agriconnect-demo"
echo ""
railway init
echo "✅  Project created!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 4 — Add MySQL (manual step in Railway Dashboard)
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 4: Add MySQL Plugin (manual — 2 minutes)"
echo ""
echo "   1. Open your browser and go to: https://railway.app/dashboard"
echo "   2. Click on your 'agriconnect-demo' project"
echo "   3. Click the big [ + New ] button"
echo "   4. Select 'Database' → 'Add MySQL'"
echo "   5. Railway will spin up a managed MySQL 8 instance for FREE"
echo "   6. Click on the MySQL service → 'Variables' tab"
echo "   7. Copy the values for:"
echo "      MYSQL_PUBLIC_URL  (looks like: mysql://user:pass@host:port/railway)"
echo "      MYSQLUSER"
echo "      MYSQLPASSWORD"
echo ""
echo "   ⚠️  NOTE: Railway also provides a JDBC-format URL. Look for:"
echo "      JDBC_DATABASE_URL  OR  copy MYSQL_PUBLIC_URL and replace"
echo "      'mysql://' with 'jdbc:mysql://' manually."
echo ""
read -rp "   Press ENTER once you've added MySQL and copied the credentials..."
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 5 — Set Environment Variables
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 5: Setting environment variables..."
echo "   Replace the placeholder values below with your actual credentials!"
echo "   You can run these commands one by one if you prefer."
echo ""

# ── Paste your actual values here ──────────────────────────────
DB_URL_VALUE="jdbc:mysql://YOUR_MYSQL_HOST:PORT/railway?useSSL=true&serverTimezone=UTC"
DB_USER_VALUE="YOUR_MYSQL_USER"
DB_PASS_VALUE="YOUR_MYSQL_PASSWORD"
JWT_SECRET_VALUE="your-super-secret-jwt-key-min-32-chars-long"
AES_KEY_VALUE="your-aes-256-bit-secret-key-here"
# ───────────────────────────────────────────────────────────────

echo "   Setting SPRING_PROFILES_ACTIVE=railway ..."
railway variables set SPRING_PROFILES_ACTIVE=railway

echo "   Setting DB_URL ..."
railway variables set DB_URL="$DB_URL_VALUE"

echo "   Setting DB_USER ..."
railway variables set DB_USER="$DB_USER_VALUE"

echo "   Setting DB_PASS ..."
railway variables set DB_PASS="$DB_PASS_VALUE"

echo "   Setting JWT_SECRET ..."
railway variables set JWT_SECRET="$JWT_SECRET_VALUE"

echo "   Setting AES_SECRET_KEY ..."
railway variables set AES_SECRET_KEY="$AES_KEY_VALUE"

echo ""
echo "✅  Environment variables set! Verify them at:"
echo "    https://railway.app/dashboard → your project → Variables tab"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 6 — Link MySQL variables (optional shortcut)
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 6: (Optional) Link MySQL plugin variables directly"
echo "   Instead of hardcoding DB_URL above, Railway lets you reference"
echo "   variables from another service using \${{MySQL.VARIABLE_NAME}}."
echo ""
echo "   In the Railway Dashboard:"
echo "   1. Go to your App service → Variables → Add Variable"
echo "   2. Name: DB_URL"
echo "   3. Value: jdbc:mysql://\${{MySQL.MYSQLDOMAIN}}:\${{MySQL.MYSQLPORT}}/\${{MySQL.MYSQLDATABASE}}?useSSL=true&serverTimezone=UTC"
echo "   4. Similarly: DB_USER = \${{MySQL.MYSQLUSER}}"
echo "   5. Similarly: DB_PASS = \${{MySQL.MYSQLPASSWORD}}"
echo ""
echo "   This way, if MySQL credentials rotate, your app auto-updates! 🎉"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 7 — Build the WAR and Deploy
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 7: Building AgriConnect WAR with Maven..."
echo "   This compiles your Java code and packages it into agriconnect.war"
echo ""
mvn clean package -DskipTests
echo "✅  Build successful! WAR is at: target/agriconnect.war"
echo ""

echo "▶ STEP 8: Deploying to Railway..."
echo "   Railway will:"
echo "   1. Upload your code"
echo "   2. Run: docker build -t agriconnect . (using your Dockerfile)"
echo "   3. Start Tomcat with: catalina.sh run"
echo "   4. Check /actuator/health every 30s"
echo ""
railway up
echo "✅  Deployment triggered!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 9 — Get your public URL
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 9: Generating your public URL..."
echo "   Railway gives you a free subdomain like: agriconnect-demo.up.railway.app"
echo ""
railway domain
echo ""
echo "✅  Your AgriConnect app is LIVE! 🌾🚀"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 10 — (Optional) Attach a custom domain
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 10 (Optional): Attaching a custom domain"
echo ""
echo "   If you own a domain (e.g. pruthvi-agriconnect.com):"
echo "   1. Dashboard → your App service → Settings → Networking"
echo "   2. Click 'Custom Domain' → enter your domain"
echo "   3. Add the CNAME record Railway shows you to your DNS provider"
echo "   4. Railway handles SSL/HTTPS automatically (Let's Encrypt) — FREE!"
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  🎉 Deployment complete! Add this URL to your resume:   ║"
echo "║     https://YOUR-APP.up.railway.app                     ║"
echo "║                                                          ║"
echo "║  Monitor logs: railway logs                              ║"
echo "║  Re-deploy:    railway up                                ║"
echo "║  Tear down:    railway down                              ║"
echo "╚══════════════════════════════════════════════════════════╝"
