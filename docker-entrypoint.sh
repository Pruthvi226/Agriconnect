#!/bin/sh
set -eu

# ── Resolve port ──────────────────────────────────────────────────────────────
# Render injects $PORT (usually 10000 on free tier). We default to 8080 locally.
TOMCAT_PORT="${PORT:-8080}"

echo "[AgriConnect] Configuring Tomcat to listen on port ${TOMCAT_PORT} ..."

# Patch server.xml connector port
sed -i "s/port=\"8080\"/port=\"${TOMCAT_PORT}\"/g" \
    /usr/local/tomcat/conf/server.xml

# Verify the patch worked
if grep -q "port=\"${TOMCAT_PORT}\"" /usr/local/tomcat/conf/server.xml; then
    echo "[AgriConnect] Port patch verified: Tomcat will bind to ${TOMCAT_PORT}"
else
    echo "[AgriConnect] WARNING: Port patch may not have applied. Dumping connector config:"
    grep -i "connector" /usr/local/tomcat/conf/server.xml || true
fi

# ── JVM tuning for Render free tier (512 MB RAM) ─────────────────────────────
export JAVA_OPTS="${JAVA_OPTS:-} \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=70.0 \
  -XX:InitialRAMPercentage=40.0 \
  -XX:+ExitOnOutOfMemoryError \
  -Djava.security.egd=file:/dev/./urandom \
  -Dfile.encoding=UTF-8"

echo "[AgriConnect] JVM options: ${JAVA_OPTS}"
echo "[AgriConnect] Starting Tomcat on port ${TOMCAT_PORT} ..."
exec "$@"
