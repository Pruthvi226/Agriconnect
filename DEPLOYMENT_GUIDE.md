# AgriConnect Deployment Guide

## Status: ✅ All Errors Fixed & Build Successful

The application has been successfully built and is ready for deployment.

**Build Output:** `target/agriconnect.war` (ready to deploy)

---

## Deployment Options

### Option 1: Docker Deployment (Recommended)

#### Prerequisites:

- Docker installed on your system
- Docker Compose (optional, for local MySQL setup)

#### Steps:

1. **Build the Docker image:**

   ```bash
   cd /path/to/AgriConnect
   docker build -t agriconnect:latest .
   ```

2. **Run with Docker Compose (includes MySQL):**

   ```bash
   docker-compose up -d
   ```

   This starts both the MySQL database and the AgriConnect application.

3. **Or run Docker manually:**

   ```bash
   docker run -d \
     -p 8080:8080 \
     -e DB_URL="jdbc:mysql://host.docker.internal:3306/agriconnect?useSSL=true&serverTimezone=UTC" \
     -e DB_USER="agriconnect" \
     -e DB_PASS="your_password" \
     -e HIBERNATE_DDL_AUTO="update" \
     -e JWT_SECRET="your-secret-key" \
     -e AES_SECRET_KEY="your-aes-key" \
     --name agriconnect \
     agriconnect:latest
   ```

4. **Access the application:**
   - URL: `http://localhost:8080`
   - Health check: `http://localhost:8080/health`

---

### Option 2: Render.com Deployment (Cloud)

The `render.yaml` file is pre-configured for Render.com deployment.

#### Steps:

1. **Push your code to GitHub:**

   ```bash
   git add .
   git commit -m "Fixed all compilation errors"
   git push
   ```

2. **Deploy on Render.com:**
   - Visit https://render.com
   - Create a new Web Service
   - Connect your GitHub repository
   - Render will automatically detect `render.yaml` and configure the deployment
   - Set environment variables:
     - `DB_URL`: Your MySQL connection string
     - `DB_USER`: Database username
     - `DB_PASS`: Database password
     - `JWT_SECRET`: (auto-generated)
     - `AES_SECRET_KEY`: (auto-generated)

3. **Access the application:**
   - Render will assign a unique URL (e.g., `https://agriconnect.onrender.com`)
   - Application will automatically initialize the database on first run

---

### Option 3: Tomcat Deployment (Manual)

#### Prerequisites:

- Apache Tomcat 10.1 with Java 17+ installed

#### Steps:

1. **Deploy the WAR file:**

   ```bash
   cp target/agriconnect.war /path/to/tomcat/webapps/ROOT.war
   ```

2. **Start Tomcat:**

   ```bash
   /path/to/tomcat/bin/startup.sh
   ```

3. **Configure environment variables:**
   Set these in `setenv.sh` or `catalina.properties`:

   ```bash
   export DB_URL="jdbc:mysql://localhost:3306/agriconnect?useSSL=true&serverTimezone=UTC"
   export DB_USER="agriconnect"
   export DB_PASS="your_password"
   export HIBERNATE_DDL_AUTO="update"
   export JWT_SECRET="your-secret-key"
   export AES_SECRET_KEY="your-aes-key"
   export SPRING_PROFILES_ACTIVE="production"
   ```

4. **Access the application:**
   - URL: `http://localhost:8080`

---

## Database Setup

The application uses MySQL 8.3 and requires the following:

1. **Create database and user:**

   ```sql
   CREATE DATABASE IF NOT EXISTS agriconnect;
   CREATE USER 'agriconnect'@'%' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON agriconnect.* TO 'agriconnect'@'%';
   FLUSH PRIVILEGES;
   ```

2. **Initial schema:**
   - Automatically created on first run if `HIBERNATE_DDL_AUTO=update`
   - Or manually run `schema.sql`

3. **Seed data:**
   - Automatically loaded on first application startup from `seed-data.sql`
   - Includes admin user and test data

---

## Environment Variables (Required for Production)

| Variable                 | Example                                        | Notes                                        |
| ------------------------ | ---------------------------------------------- | -------------------------------------------- |
| `DB_URL`                 | `jdbc:mysql://db.example.com:3306/agriconnect` | MySQL JDBC URL                               |
| `DB_USER`                | `agriconnect`                                  | Database username                            |
| `DB_PASS`                | `secure-password`                              | Database password                            |
| `HIBERNATE_DDL_AUTO`     | `validate`                                     | Use 'update' for first run, 'validate' after |
| `JWT_SECRET`             | Generated                                      | Secure random key for JWT tokens             |
| `AES_SECRET_KEY`         | Generated                                      | Secure random key for encryption             |
| `SPRING_PROFILES_ACTIVE` | `production`                                   | Activates production configuration           |

---

## Health Checks

The application provides multiple health endpoints:

- **Liveness probe:** `GET /health` (fast, no database calls)
- **Readiness probe:** `GET /actuator/health` (includes database check)
- **Docker HEALTHCHECK:** Automatically configured in Dockerfile

---

## Port Configuration

- **Default:** 8080
- **Docker/Render:** Automatically configures port from `$PORT` environment variable
- **Custom:** Set `SERVER_PORT` environment variable

---

## Troubleshooting

### Docker Build Fails

- Ensure Maven is available in your PATH
- Check that `pom.xml` and `src/` are in the same directory

### Application Won't Start

- Check database connectivity: `DB_URL`, `DB_USER`, `DB_PASS`
- Verify environment variables are set correctly
- Check logs: `docker logs agriconnect` or Tomcat logs

### Health Check Fails

- Wait 2-3 minutes for Tomcat + Hibernate to initialize
- Verify database connection
- Check that Spring Boot has fully started

---

## What Was Fixed

✅ Removed unused import: `io.jsonwebtoken.SignatureAlgorithm`
✅ Removed unused import: `org.springframework.security.crypto.password.PasswordEncoder`
✅ Removed unused field: `AdvisoryAlertService`
✅ Removed unused imports in test files: `Collections`, `ArgumentCaptor`
✅ Added `@NonNull` annotation to `onApplicationEvent()` parameter
✅ Resolved null type safety warnings in `AdminDataInitializer`

---

## Next Steps

1. **Choose your deployment method** from the options above
2. **Set up your database** (MySQL 8.3)
3. **Configure environment variables**
4. **Deploy the application**
5. **Verify health checks** are passing
6. **Access your application** at the provided URL

For production deployments, consider using:

- Cloud managed services (Render, AWS, Azure, GCP)
- Kubernetes for scalability
- CI/CD pipeline for automated deployments
