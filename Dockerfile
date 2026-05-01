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

# Install curl for health probe (no xmlstarlet needed — sed is sufficient)
RUN apt-get update -qq && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Remove default webapps to keep image lean
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy as ROOT so context path is /
COPY --from=build /workspace/target/agriconnect.war /usr/local/tomcat/webapps/ROOT.war

# Copy and set up the entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ── Environment defaults ───────────────────────────────────────────────────────
# PORT is overridden at runtime by Render (or docker run -e PORT=...).
# Do NOT hard-code this to 8080 — the entrypoint patches server.xml to $PORT.
ENV PORT=8080
ENV SPRING_PROFILES_ACTIVE=production

# Expose the default port (documentation only; Render overrides via $PORT)
EXPOSE 8080

# ── Docker-native liveness probe ──────────────────────────────────────────────
# IMPORTANT: Use shell form (not exec form) so that $PORT is evaluated at
# container runtime, not at image build time. This means the HEALTHCHECK
# always probes whichever port Tomcat is actually listening on.
# --start-period: 120s gives Spring + Hibernate time to fully initialize.
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -fsS "http://localhost:${PORT}/health" || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
