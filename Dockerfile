FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace

COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /workspace/target/agriconnect.war /usr/local/tomcat/webapps/ROOT.war
COPY docker-entrypoint.sh /usr/local/bin/agriconnect-entrypoint.sh
RUN chmod +x /usr/local/bin/agriconnect-entrypoint.sh

ENV PORT=8080

EXPOSE 8080

ENTRYPOINT ["agriconnect-entrypoint.sh"]
CMD ["catalina.sh", "run"]
