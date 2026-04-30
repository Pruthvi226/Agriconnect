# ─── Stage 1: Build ─────────────────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace

# Cache dependencies first (layer cache friendly)
COPY pom.xml .
RUN mvn dependency:go-offline -q

COPY src ./src
RUN mvn clean package -DskipTests -q

# ─── Stage 2: Runtime ────────────────────────────────────────────────────────
FROM tomcat:10.1-jdk17-temurin

# Install curl for Docker HEALTHCHECK
RUN apt-get update -qq && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy as ROOT so context path is /
COPY --from=build /workspace/target/agriconnect.war /usr/local/tomcat/webapps/ROOT.war

# Copy and set up the entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ── Environment defaults ───────────────────────────────────────────────────────
# PORT is overridden at runtime by Render (or docker run -e PORT=...).
# The entrypoint patches server.xml to use this value.
ENV PORT=8080
ENV SPRING_PROFILES_ACTIVE=production
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=70.0 -XX:InitialRAMPercentage=40.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8"

# Expose the default port (Render overrides via $PORT env var at runtime)
EXPOSE 8080

# ── Docker-native liveness probe ──────────────────────────────────────────────
# Checks the zero-dependency /health endpoint. If Tomcat is up, it returns 200.
# --interval: check every 30s | --timeout: fail if no response in 10s
# --start-period: give Tomcat 90s to start before first check
# --retries: mark unhealthy after 3 consecutive failures
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -fsS "http://localhost:${PORT:-8080}/health" || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
