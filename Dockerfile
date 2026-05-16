# Stage 1: build the WAR
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace

COPY pom.xml ./
RUN mvn -q dependency:go-offline

COPY schema.sql ./
COPY src ./src
RUN mvn -q clean package -DskipTests

# Stage 2: run on Tomcat
FROM tomcat:10.1-jdk17-temurin

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /tmp/agriconnect-build/agriconnect.war /usr/local/tomcat/webapps/ROOT.war

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PORT=8080
ENV SPRING_PROFILES_ACTIVE=production

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -fsS "http://localhost:${PORT}/health" || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
