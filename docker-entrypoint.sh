#!/bin/sh
set -eu

# ── Resolve port ──────────────────────────────────────────────────────────────
# Render injects $PORT at runtime (typically 10000 on free tier).
# We fall back to 8080 for local Docker runs.
TOMCAT_PORT="${PORT:-8080}"

echo "[AgriConnect] Starting with PORT=${TOMCAT_PORT}"

# ── Patch Tomcat server.xml connector port ────────────────────────────────────
# Replace ALL numeric connector port values in server.xml with our target port.
# This handles the default 8080 as well as any previously patched value.
SERVER_XML="/usr/local/tomcat/conf/server.xml"

# Only patch if the port isn't already correct (idempotent)
if grep -q "port=\"${TOMCAT_PORT}\"" "${SERVER_XML}"; then
    echo "[AgriConnect] server.xml already set to port ${TOMCAT_PORT}, no patch needed."
else
    # Replace the HTTP Connector port (8080 or whatever it currently is)
    sed -i "s/port=\"8080\"/port=\"${TOMCAT_PORT}\"/" "${SERVER_XML}"
    echo "[AgriConnect] Patched server.xml: HTTP Connector → port ${TOMCAT_PORT}"
fi

# ── Verify patch ──────────────────────────────────────────────────────────────
if grep -q "port=\"${TOMCAT_PORT}\"" "${SERVER_XML}"; then
    echo "[AgriConnect] Verified: Tomcat will bind to port ${TOMCAT_PORT}"
else
    echo "[AgriConnect] ERROR: Port patch failed! Dumping connector lines:"
    grep -i "Connector" "${SERVER_XML}" || true
    # Don't exit — let Tomcat start and surface the error itself
fi

# ── JVM tuning ────────────────────────────────────────────────────────────────
# Optimised for Render free tier (512 MB RAM).
export CATALINA_OPTS="${CATALINA_OPTS:-} \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=70.0 \
  -XX:InitialRAMPercentage=30.0 \
  -XX:+ExitOnOutOfMemoryError \
  -Djava.security.egd=file:/dev/./urandom \
  -Dfile.encoding=UTF-8 \
  -Dserver.port=${TOMCAT_PORT}"

echo "[AgriConnect] CATALINA_OPTS set."
echo "[AgriConnect] Starting Tomcat on port ${TOMCAT_PORT} ..."

exec "$@"
