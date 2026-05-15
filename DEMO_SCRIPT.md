# AgriConnect Demo Script (2 Minutes)

## Opening (15 seconds)
"AgriConnect is a comprehensive agricultural digital platform that bridges farmers and buyers. Built with Java, Spring MVC, Hibernate ORM, and MySQL, it demonstrates enterprise-grade web application architecture with JSP frontend."

---

## Part 1: Authentication & Role-Based Access (20 seconds)
**Demonstrate**: Spring Security with role-based access control

1. **Show Login Page** (already loaded)
   - Navigate to: `http://localhost:8081/web/login`
   - Point out: Spring Security protecting all routes
   
2. **Login as Admin**
   - Email: `admin@agriconnect.com`
   - Password: `Admin@2024!`
   - Show: Redirect to admin dashboard (Spring Security role-based routing)

**Tech Stack Highlight**: 
- *Spring Security 6.2* handles authentication
- JWT tokens for API security
- BCrypt password encryption (demonstrated in seed data)

---

## Part 2: Admin Dashboard (25 seconds)
**Demonstrate**: Database connectivity and multi-role support

1. **Show Admin Dashboard** (`/web/dashboard/admin`)
   - Point out: User management section
   - Show: Verified vs. Pending users list
   - Explain: *Hibernate ORM* queries mapping User entities to database tables

2. **Show MSP Rates Table**
   - Minimum Support Price tracking
   - Explain: *MySQL* stored procedures calculate optimal pricing
   - Show: Real data from `msp_rates` table (Hibernate lazy loading)

**Tech Stack Highlight**:
- *Hibernate 6.4* with entity relationships
- *JSP* with Spring taglib for conditional rendering
- *MySQL 8.3* with JSON support for flexible schemas

---

## Part 3: Farmer Portal (30 seconds)
**Demonstrate**: Transaction flow and data persistence

1. **Logout and Login as Farmer**
   - Email: `ramesh@example.com`
   - Password: `Farmer@123`
   - Show: Role-based dashboard redirect (Spring MVC controller logic)

2. **Show Farmer Dashboard** (`/web/farmer`)
   - Display: Active produce listings
   - Show: Farmer score (85.0) - calculated by Hibernate stored procedures
   - Explain: *Hibernate ORM* manages complex relationships:
     - Farmer → FarmerProfile (1:1)
     - Farmer → ProduceListings (1:N)
     - Listing → Bids (1:N)

3. **View Listings**
   - Click: "My Listings"
   - Show: 
     - Wheat listing (SOLD status - shows completed transaction)
     - Rice listing (ACTIVE - pending bids)
   - Point out: *MySQL* location-based queries (lat/lng columns for geospatial search)

**Tech Stack Highlight**:
- *Spring MVC* controller routing farmers to role-specific views
- *JSP* templating with JSTL for dynamic UI rendering
- *Hibernate ORM* lazy-loading relationships
- *MySQL* DECIMAL types for precision pricing

---

## Part 4: Buyer Portal (25 seconds)
**Demonstrate**: Bidding system and transaction processing

1. **Logout and Login as Buyer**
   - Email: `contact@agrifoods.com`
   - Password: `Buyer@123`
   - Show: Different dashboard layout (Spring MVC content negotiation)

2. **Browse Marketplace** (`/web/marketplace`)
   - Show: 10 active produce listings with filters
   - Demonstrate: Matchmaking scores (92.5% - calculated via Hibernate stored procedures)
   - Explain: Score factors include:
     - Distance proximity
     - Quality match
     - Historical farmer rating

3. **View Bid History** 
   - Show: Previous bids placed
   - Click on completed order: "Order #1 - Wheat Sale"
   - Show: 
     - Farmer: Ramesh Kumar
     - Quantity: 5000 kg
     - Final price: ₹24.50/kg
     - Payment status: PAID
   - Explain: *MySQL* transactions ensure ACID compliance for financial records

**Tech Stack Highlight**:
- *Spring MVC* request mapping for marketplace endpoints
- *Hibernate ORM* many-to-many relationship between buyers and listings
- *MySQL* views and stored procedures for complex scoring logic
- *JSP* pagination for large result sets

---

## Part 5: Expert Advisory System (15 seconds)
**Demonstrate**: Real-time data updates and multi-role features

1. **Show Advisories** 
   - Navigate to: `/web/advisories`
   - Display: 3 active advisories from AgriExperts
     - Heavy Rainfall Alert (Wheat, HIGH severity)
     - Pest Warning (Maize, CRITICAL severity)
     - Optimal Sowing Window (Rice, INFO)
   - Show: Affected districts (Kangra, Hassan, Pune)
   - Explain: *Hibernate* managing advisory relationships with crops and experts

**Tech Stack Highlight**:
- *Hibernate ORM* polymorphic queries (different user types access same data)
- *MySQL JSON* columns storing affected_districts array
- *Spring taglib* conditional rendering by user role

---

## Closing (10 seconds)
**Summary of Technology Stack Demonstrated**:

✓ **Java 17** - Type-safe backend logic  
✓ **Spring MVC 6.1** - Request routing and controller-based architecture  
✓ **Spring Security 6.2** - Authentication, authorization, JWT tokens  
✓ **Hibernate ORM 6.4** - Entity mapping, lazy loading, stored procedure integration  
✓ **MySQL 8.3** - Relational data persistence, JSON support, geospatial queries  
✓ **JSP** - Server-side view rendering with JSTL  
✓ **J2EE / Jakarta EE** - Servlet containers, web standards  
✓ **Docker** - Containerized production deployment  

**Key Features Showcased**:
- Complex entity relationships (1:1, 1:N, M:N)
- Transaction management (bidding → order → payment)
- Role-based access control
- Geospatial search (location-based matching)
- Business logic in stored procedures
- Real-time data updates

---

## Quick Reference: Login Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@agriconnect.com | Admin@2024! |
| **Farmer** | ramesh@example.com | Farmer@123 |
| **Buyer** | contact@agrifoods.com | Buyer@123 |
| **AgriExpert** | ravi.v@kvk.edu | Expert@123 |

---

## Demo Data Summary

- **5 Farmers** with diverse locations (Kangra, Surat, Pune, Moga, Hassan)
- **3 Buyers** representing different business types (processor, retailer, exporter)
- **10 Active Produce Listings** (wheat, rice, cotton, maize, onion, soybean)
- **5 Bids** with various statuses (pending, accepted, rejected)
- **1 Completed Order** showing full transaction flow
- **3 Advisories** from AgriExperts with severity levels
- **MSP Rates** for 4 major crops

---

## Application URLs

| Component | URL |
|-----------|-----|
| **App Home** | http://localhost:8081/web/login |
| **Adminer (DB Admin)** | http://localhost:8082 |
| **MySQL** | localhost:3307 (User: agriconnect, Pass: agri123) |

