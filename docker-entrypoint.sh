#!/bin/sh
set -eu

# Render injects $PORT; default to 8080 for other environments
TOMCAT_PORT="${PORT:-8080}"

# Patch Tomcat's server.xml to listen on the correct port
sed -i "s/port=\"8080\" protocol=\"HTTP\/1.1\"/port=\"${TOMCAT_PORT}\" protocol=\"HTTP\/1.1\"/" \
    /usr/local/tomcat/conf/server.xml

echo "[AgriConnect] Starting Tomcat on port ${TOMCAT_PORT} ..."
exec "$@"
