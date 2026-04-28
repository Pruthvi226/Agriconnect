#!/usr/bin/env bash
# ============================================================
#  swap-setup.sh — Add 2GB Swap Space to Oracle Free VM
#
#  WHY? Oracle's always-free VMs only have 1GB RAM.
#  Running Docker + MySQL + Tomcat + Java needs ~1.5-2GB.
#  Without swap, the OOM killer will terminate your app!
#
#  Usage: sudo ./swap-setup.sh
# ============================================================
set -e

echo "╔══════════════════════════════════════════════════════╗"
echo "║  🔧 Adding 2GB Swap Space to Oracle VM              ║"
echo "╚══════════════════════════════════════════════════════╝"

# Check if swap already exists
if swapon --show | grep -q /swapfile; then
    echo "⚠️  Swap already active — skipping creation."
    swapon --show
    exit 0
fi

echo "▶ STEP 1: Allocating 2GB swap file at /swapfile..."
fallocate -l 2G /swapfile
echo "✅  File created!"

echo "▶ STEP 2: Setting permissions (root-only)..."
chmod 600 /swapfile

echo "▶ STEP 3: Formatting as swap space..."
mkswap /swapfile

echo "▶ STEP 4: Activating swap now..."
swapon /swapfile
echo "✅  Swap is ACTIVE!"
free -h

echo "▶ STEP 5: Persisting swap across reboots (/etc/fstab)..."
grep -q "/swapfile" /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo "✅  Added to /etc/fstab"

echo "▶ STEP 6: Tuning swappiness to 10..."
echo "   (Default=60 swaps too eagerly; 10=prefer RAM, swap only when needed)"
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50

grep -q "vm.swappiness" /etc/sysctl.conf \
    && sed -i 's/vm.swappiness=.*/vm.swappiness=10/' /etc/sysctl.conf \
    || echo "vm.swappiness=10" >> /etc/sysctl.conf

grep -q "vm.vfs_cache_pressure" /etc/sysctl.conf \
    && sed -i 's/vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=50/' /etc/sysctl.conf \
    || echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Swap Setup Complete!                             ║"
echo "║                                                      ║"
echo "║  Pro tips for 1GB RAM:                               ║"
echo "║  • JVM heap:  JAVA_OPTS=-Xmx512m -Xms256m           ║"
echo "║  • MySQL:     innodb_buffer_pool_size=256M           ║"
echo "╚══════════════════════════════════════════════════════╝"
free -h
