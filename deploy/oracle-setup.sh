#!/usr/bin/env bash
# ============================================================
#  oracle-setup.sh — Set up AgriConnect on Oracle Cloud Free VM
#
#  Run this AFTER you SSH into your Oracle VM:
#    ssh -i ~/.ssh/oracle_key ubuntu@YOUR_VM_PUBLIC_IP
#
#  Then:
#    chmod +x oracle-setup.sh && sudo ./oracle-setup.sh
#
#  Estimated time: ~10 minutes
# ============================================================
set -e

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  ☁️   AgriConnect → Oracle Cloud VM Setup Script        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 1 — System update
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 1: Updating system packages (takes ~2 min)..."
apt-get update -y && apt-get upgrade -y
echo "✅  System updated!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 2 — Install Docker
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 2: Installing Docker..."
apt-get install -y \
    docker.io \
    docker-compose-plugin \
    curl \
    git \
    ufw \
    netfilter-persistent \
    iptables-persistent

# Start Docker and enable it on boot
systemctl enable docker
systemctl start docker

# Allow the ubuntu user to run Docker without sudo
usermod -aG docker ubuntu

echo "✅  Docker $(docker --version) installed!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 3 — Configure firewall (UFW)
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 3: Configuring UFW firewall..."
ufw --force enable
ufw allow 22/tcp   # SSH — NEVER block this or you'll lock yourself out!
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw status
echo "✅  UFW firewall configured!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 4 — Oracle VM requires iptables rules ADDITIONALLY
#   (Oracle's VMs have their own packet filtering layer
#    that ignores UFW — you MUST add these rules separately)
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 4: Opening Oracle's iptables (REQUIRED for Oracle VMs)..."
echo "   ⚠️  Oracle VMs block ports at the OS level even if UFW says 'allow'."
echo "   We need to manually insert iptables rules for port 80 and 443."
echo ""

iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80  -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT

# Also open port 8080 for testing before you set up Nginx reverse proxy
echo "   Saving iptables rules so they survive reboots..."
netfilter-persistent save

echo "✅  iptables rules saved!"
echo ""
echo "   ⚠️  ALSO REQUIRED: Go to Oracle Cloud Console →"
echo "       Networking → Virtual Cloud Networks → your VCN"
echo "       → Security Lists → Add Ingress Rules for port 80 and 443"
echo "       (Oracle has a cloud-level firewall too — it's layered!)"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 5 — Clone the AgriConnect repository
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 5: Cloning AgriConnect repository..."
echo "   Change the URL below to your actual GitHub repo URL!"
echo ""

REPO_URL="https://github.com/YOUR_USERNAME/AgriConnect.git"
APP_DIR="/opt/agriconnect"

if [ -d "$APP_DIR" ]; then
    echo "   Directory already exists. Pulling latest changes..."
    cd "$APP_DIR" && git pull
else
    git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

echo "✅  Repository ready at $APP_DIR"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 6 — Create the .env file with your secrets
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 6: Creating .env file..."
echo "   ⚠️  EDIT the values below before running this script!"
echo "   Or run: nano /opt/agriconnect/.env  after the script finishes."
echo ""

cat > "$APP_DIR/.env" << 'EOF'
# ── AgriConnect Production Environment Variables ──
# Edit these values before deploying!

DB_USER=agriconnect_user
DB_PASS=CHANGE_ME_strong_password_here

# Generate a random JWT secret (at least 32 characters):
# openssl rand -hex 32
JWT_SECRET=CHANGE_ME_generate_with_openssl_rand_hex_32

# Generate a random AES key (exactly 32 chars for AES-256):
# openssl rand -hex 16
AES_KEY=CHANGE_ME_16byte_aes_key_here_xx

SPRING_PROFILES_ACTIVE=production
EOF

chmod 600 "$APP_DIR/.env"  # Only root can read this file
echo "✅  .env file created at $APP_DIR/.env"
echo "   Please edit it now: nano $APP_DIR/.env"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 7 — Build WAR and start the production stack
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 7: Building and starting AgriConnect production stack..."
echo "   This runs: docker compose up --build -d"
echo "   First build takes ~5 minutes (Maven download + compile)"
echo ""

cd "$APP_DIR"

# Build the WAR file first (inside a Maven Docker container to avoid
# needing Java/Maven installed on the VM)
echo "   Building WAR with Maven Docker image..."
docker run --rm \
    -v "$APP_DIR":/workspace \
    -w /workspace \
    maven:3.9.6-eclipse-temurin-21 \
    mvn clean package -DskipTests -q

echo "✅  WAR built: target/agriconnect.war"
echo ""

echo "   Starting all services (app + MySQL + Adminer)..."
docker compose up --build -d

echo ""
echo "✅  All services started!"
echo ""

# ─────────────────────────────────────────────────────────────
# STEP 8 — Final status check
# ─────────────────────────────────────────────────────────────
echo "▶ STEP 8: Checking service status..."
sleep 10  # Give containers a moment to start
docker compose ps
echo ""

PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "YOUR_VM_IP")
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  🌾 AgriConnect is deploying!                           ║"
echo "║                                                          ║"
echo "║  Access your app in ~2 minutes at:                      ║"
echo "║  http://$PUBLIC_IP:8080                           ║"
echo "║                                                          ║"
echo "║  Monitor logs: docker compose logs -f app               ║"
echo "║  Check health: curl http://localhost:8080/actuator/health║"
echo "╚══════════════════════════════════════════════════════════╝"
