#!/bin/sh
set -eu

TOMCAT_PORT="${PORT:-8080}"
SERVER_XML="/usr/local/tomcat/conf/server.xml"

echo "[AgriConnect] Starting with PORT=${TOMCAT_PORT}"

if [ "${TOMCAT_PORT}" != "8080" ]; then
  sed -i "s/port=\"8080\"/port=\"${TOMCAT_PORT}\"/" "${SERVER_XML}"
  echo "[AgriConnect] Patched Tomcat HTTP connector to ${TOMCAT_PORT}"
fi

export CATALINA_OPTS="${CATALINA_OPTS:-} \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=70.0 \
  -XX:InitialRAMPercentage=30.0 \
  -XX:+ExitOnOutOfMemoryError \
  -Djava.security.egd=file:/dev/./urandom \
  -Dfile.encoding=UTF-8 \
  -Dserver.port=${TOMCAT_PORT}"

mkdir -p /usr/local/tomcat/uploads
cd /usr/local/tomcat

echo "[AgriConnect] Starting Tomcat on port ${TOMCAT_PORT}"
exec "$@"
