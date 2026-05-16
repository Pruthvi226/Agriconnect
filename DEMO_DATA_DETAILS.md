# AgriConnect Demo Data Details

The demo data is stored in `src/main/resources/seed-data.sql` and is loaded by Docker Compose after `schema.sql` when the MySQL volume is created for the first time.

## Demo Logins

| Role | Email | Password | What to Demo |
| --- | --- | --- | --- |
| Admin | admin@agriconnect.com | Admin@123 | User verification, MSP rates, MSP compliance, audit logs |
| Farmer | ramesh@example.com | Farmer@123 | Listings, accepted wheat order, FPO membership |
| Farmer | vikram@example.com | Farmer@123 | Below-MSP listings and pending bids |
| Farmer | meena@example.com | Farmer@123 | Urgent onion/tomato listings, order in transit, FPO leadership |
| Buyer | contact@agrifoods.com | Buyer@123 | Orders, delivered receipt, active bids |
| Buyer | sales@freshfarm.com | Buyer@123 | Counter-offer demo on tomato listing |
| Expert | ravi.v@kvk.edu | Expert@123 | Advisory history and publishing |
| Expert | anita.r@uni.edu | Expert@123 | Critical advisory publishing |

## Seeded Dataset

- 13 users across farmer, buyer, agri-expert, and admin roles.
- 8 crop records and crop-master metadata.
- 6 farmer profiles across Kangra, Surat, Pune, Moga, Hassan, and Nashik.
- 4 buyer profiles with preferred crops, preferred districts, and credit limits.
- 8 MSP rates and 8 market price rows for the MSP checker and marketplace.
- 14 produce listings:
  - Active marketplace listings.
  - Sold listings for receipt/order demos.
  - Bidding listings for pending and counter-offer flows.
  - Withdrawn listing for farmer reactivation demo.
  - Below-MSP listings for admin compliance.
- 9 bids:
  - Accepted, rejected, pending, and countered examples.
- 3 orders:
  - Confirmed wheat order.
  - In-transit onion order.
  - Delivered rice order with receipt.
- 9 notifications across bids, orders, advisory, wallet, and admin system alerts.
- 5 advisories, including one critical pest alert.
- 2 verified FPO groups, 4 memberships, and 3 open FPO collective listings.
- Wallet, price history, matchmaking, critical alert, and audit-log rows.

## Useful Demo Routes

- Marketplace: `/web/marketplace`
- MSP checker: `/web/msp-checker`
- Farmer listings: `/web/farmer/listings`
- Farmer bookings: `/web/farmer/bookings`
- Buyer bids: `/web/buyer/bids`
- Buyer orders: `/web/buyer/orders`
- Advisories: `/web/advisories`
- Notifications: `/web/notifications`
- Admin users: `/web/admin/users`
- Admin MSP rates: `/web/admin/msp`
- Admin MSP compliance: `/web/admin/msp-compliance`
- Admin audit logs: `/web/admin/audit`

## Fresh Docker Load

If the database volume already exists, MySQL will not rerun the seed files automatically. For a clean reload:

```powershell
docker compose down -v
docker compose up --build
```

Then open:

- App: `http://localhost:8081`
- Adminer: `http://localhost:8082`
