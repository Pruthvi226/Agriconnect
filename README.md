# AgriConnect 🌾

AgriConnect is a comprehensive digital platform designed to bridge the gap between farmers and buyers in the agricultural supply chain. By leveraging modern technology, AgriConnect facilitates transparent price discovery, efficient matchmaking, and secure bidding processes.

## 🚀 Key Features

- **Matchmaking Engine**: An intelligent algorithm that scores potential matches between farmers and buyers based on crop type, location, and historical scores.
- **MSP Validation**: Built-in tracking of Government Minimum Support Price (MSP) to ensure farmers receive fair value for their produce.
- **Smart Bidding System**: Secure and transparent bidding process for active produce listings.
- **Role-Based Dashboards**:
  - **Farmer**: Manage listings, view bids, and track orders.
  - **Buyer**: Search for produce, place bids, and view match scores.
  - **Administrator**: Monitor platform health, verify users, and manage MSP rates.
  - **AgriExpert**: Provide advisories and alerts to farmers.
- **Dynamic Scoring**: Automated farmer scoring based on delivery performance and quality.
- **Geospatial Search**: Find nearby produce listings using latitude/longitude proximity.

## 🛠 Tech Stack

- **Backend**: Java 17, Spring Framework 6.1, Spring Security 6.2
- **Persistence**: Hibernate 6.4, MySQL 8.3
- **Frontend**: JSP, Jakarta EE 10, Bootstrap 5.3
- **DevOps**: Docker, Docker Compose, Railway (Deployment Support)
- **API**: RESTful endpoints with JWT Authentication
- **Database**: Advanced MySQL features including Stored Procedures, Triggers, and Full-Text Search.

## 📂 Project Structure

```text
AgriConnect/
├── src/main/java          # Core application logic (Spring, Hibernate)
├── src/main/webapp        # Web resources (JSP, configurations)
├── src/test               # Integration and Unit tests
├── schema.sql             # Complete database schema and seed data
├── Dockerfile             # Container configuration
├── docker-compose.yml     # Local orchestration
└── deploy/                # Deployment and setup scripts
```

## 🚦 Getting Started

### Prerequisites
- JDK 17
- Maven 3.8+
- MySQL 8.x

### Local Development
1. Clone the repository.
2. Configure your database credentials in `src/main/resources/hibernate.cfg.xml`.
3. Run the schema script:
   ```bash
   mysql -u root -p < schema.sql
   ```
4. Build and run the application:
   ```bash
   mvn clean install
   mvn cargo:run # or deploy to Tomcat
   ```

### Docker Setup
To run the entire stack (App + DB) using Docker:
```bash
docker-compose up --build
```

## 🔒 Security
- JWT-based authentication for REST APIs.
- Rate limiting implemented via `RateLimitFilter` to prevent DDoS and abuse.
- Encrypted sensitive data (e.g., Aadhaar, Bank Accounts).

