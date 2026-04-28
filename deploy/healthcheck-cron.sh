#!/usr/bin/env bash
# ============================================================
#  healthcheck-cron.sh — AgriConnect Auto Health Monitor
#
#  Runs every 5 minutes via cron. Checks if the app is alive,
#  restarts it if not, and emails you if it keeps failing.
#
#  INSTALLATION (run once on your Oracle VM):
#    sudo cp healthcheck-cron.sh /usr/local/bin/agriconnect-healthcheck.sh
#    sudo chmod +x /usr/local/bin/agriconnect-healthcheck.sh
#    sudo crontab -e
#    # Add this line:
#    */5 * * * * /usr/local/bin/agriconnect-healthcheck.sh
#
#  EMAIL SETUP (free — uses Brevo/Sendinblue SMTP):
#    1. Sign up FREE at https://www.brevo.com (300 emails/day free)
#    2. Go to SMTP & API → SMTP → get your API key
#    3. Set SMTP_API_KEY and ALERT_EMAIL below
# ============================================================

# ─── Configuration ──────────────────────────────────────────
APP_CONTAINER="agriconnect_app"
HEALTH_URL="http://localhost:8080/actuator/health"
LOG_FILE="/var/log/agriconnect-health.log"
FAIL_COUNT_FILE="/tmp/agriconnect_fail_count"
MAX_FAILURES=3          # Email alert after this many consecutive failures
TIMEOUT_SECONDS=10      # Max seconds to wait for health response

# Brevo (formerly Sendinblue) free SMTP — 300 emails/day
SMTP_HOST="smtp-relay.brevo.com"
SMTP_PORT="587"
SMTP_USER="your-brevo-login@email.com"   # ← Your Brevo account email
SMTP_API_KEY="xsmtpib-CHANGE_ME"         # ← Brevo SMTP API key
ALERT_EMAIL="your-personal@email.com"    # ← Where you want alerts sent
APP_NAME="AgriConnect"
# ─────────────────────────────────────────────────────────────

# Ensure log file and fail counter exist
touch "$LOG_FILE"
touch "$FAIL_COUNT_FILE"

# Helper: Write timestamped log entry
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Helper: Get current consecutive failure count
get_fail_count() {
    cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 0
}

# Helper: Set consecutive failure count
set_fail_count() {
    echo "$1" > "$FAIL_COUNT_FILE"
}

# Helper: Send email alert via Brevo SMTP using curl
send_email_alert() {
    local subject="$1"
    local body="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    log "📧 Sending email alert to $ALERT_EMAIL..."

    curl --silent --show-error \
        --url "smtp://${SMTP_HOST}:${SMTP_PORT}" \
        --ssl-reqd \
        --mail-from "$SMTP_USER" \
        --mail-rcpt "$ALERT_EMAIL" \
        --user "${SMTP_USER}:${SMTP_API_KEY}" \
        --upload-file - << EOF
From: $APP_NAME Monitor <$SMTP_USER>
To: $ALERT_EMAIL
Subject: 🚨 [$APP_NAME] $subject
Content-Type: text/plain

$body

Timestamp: $timestamp
Server: $(hostname)
Log file: $LOG_FILE

Last 20 log lines:
$(tail -20 "$LOG_FILE")

-- AgriConnect Health Monitor
EOF

    if [ $? -eq 0 ]; then
        log "✅ Email alert sent successfully"
    else
        log "❌ Failed to send email alert (check SMTP credentials)"
    fi
}

# Helper: Restart the app container
restart_app() {
    log "🔄 Restarting $APP_CONTAINER container..."
    
    # Try docker compose first (preferred), fallback to docker restart
    if [ -f "/opt/agriconnect/docker-compose.yml" ]; then
        cd /opt/agriconnect && docker compose restart app >> "$LOG_FILE" 2>&1
    else
        docker restart "$APP_CONTAINER" >> "$LOG_FILE" 2>&1
    fi

    if [ $? -eq 0 ]; then
        log "✅ Container restart command issued. App will be up in ~60s."
    else
        log "❌ Failed to restart container! Manual intervention needed."
        send_email_alert \
            "CRITICAL: Cannot restart container" \
            "The health monitor tried to restart $APP_CONTAINER but FAILED.
Manual intervention is required immediately.
SSH into your server and run: docker ps -a"
    fi
}

# ─────────────────────────────────────────────────────────────
# MAIN HEALTH CHECK LOGIC
# ─────────────────────────────────────────────────────────────

log "── Health check starting ──"

# Perform the health check
HTTP_STATUS=$(curl \
    --silent \
    --output /dev/null \
    --write-out "%{http_code}" \
    --max-time "$TIMEOUT_SECONDS" \
    "$HEALTH_URL" 2>/dev/null)

log "Health endpoint returned HTTP $HTTP_STATUS (expected 200)"

if [ "$HTTP_STATUS" = "200" ]; then
    # ── App is healthy ────────────────────────────────────────
    log "✅ App is HEALTHY"
    
    PREV_FAILS=$(get_fail_count)
    
    # If app recovered from failures, send a recovery notification
    if [ "$PREV_FAILS" -gt 0 ]; then
        log "🎉 App RECOVERED after $PREV_FAILS failure(s). Sending recovery email..."
        send_email_alert \
            "RECOVERED: App is back online" \
            "$APP_NAME has recovered and is now healthy.
It was down for approximately $((PREV_FAILS * 5)) minutes.
Health URL: $HEALTH_URL"
    fi
    
    # Reset failure counter
    set_fail_count 0

else
    # ── App is unhealthy ──────────────────────────────────────
    FAIL_COUNT=$(get_fail_count)
    FAIL_COUNT=$((FAIL_COUNT + 1))
    set_fail_count "$FAIL_COUNT"

    log "❌ App is UNHEALTHY (failure #$FAIL_COUNT of $MAX_FAILURES before email alert)"

    # Always restart on first failure
    restart_app

    # Send email alert if failure threshold reached
    if [ "$FAIL_COUNT" -ge "$MAX_FAILURES" ]; then
        log "🚨 Failure threshold reached ($FAIL_COUNT failures). Sending alert email..."
        send_email_alert \
            "ALERT: App down for $FAIL_COUNT consecutive checks" \
            "$APP_NAME has been unreachable for $FAIL_COUNT consecutive health checks
(approximately $((FAIL_COUNT * 5)) minutes).

Health URL: $HEALTH_URL
Last HTTP status: $HTTP_STATUS

The monitor has attempted automatic restarts. If you receive this email,
the automatic recovery may not be working.

Please SSH into your server and check:
  docker ps -a
  docker logs $APP_CONTAINER --tail 100
  docker compose logs app"
        
        # Reset counter after alert to avoid email spam
        # (next alert will fire after another MAX_FAILURES checks)
        set_fail_count 0
    fi
fi

log "── Health check complete ──"

# Keep log file from growing forever — keep last 1000 lines
LOG_LINES=$(wc -l < "$LOG_FILE")
if [ "$LOG_LINES" -gt 1000 ]; then
    tail -1000 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    log "📋 Log rotated (kept last 1000 lines)"
fi
