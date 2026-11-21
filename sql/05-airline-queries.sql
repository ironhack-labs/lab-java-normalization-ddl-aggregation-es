-- =====================================================================
-- Exercise 3 - Queries on the airline database
-- Run after 03-airline-ddl.sql and 04-airline-data.sql
-- Expected results (verified on MySQL 8.4) are noted above each query.
-- =====================================================================

USE airline_db;

-- 1. Total number of flights
-- Expected: 5
SELECT COUNT(DISTINCT flight_number) AS total_flights
FROM flights;

-- 2. Average flight distance
-- Expected: 1775.8000
SELECT AVG(mileage) AS avg_flight_mileage
FROM flights;

-- 3. Average number of seats per aircraft
-- Expected: 300.0000
SELECT AVG(total_seats) AS avg_seats
FROM aircrafts;

-- 4. Average miles flown by customers, grouped by status
-- Expected: Gold 253174.5000 | None 4330.5000 | Silver 98576.5000
SELECT status, AVG(total_mileage) AS avg_total_mileage
FROM customers
GROUP BY status
ORDER BY status;

-- 5. Max miles flown by customers, grouped by status
-- Expected: Gold 300582 | None 6008 | Silver 136773
SELECT status, MAX(total_mileage) AS max_total_mileage
FROM customers
GROUP BY status
ORDER BY status;

-- 6. Number of aircrafts with "Boeing" in their name
-- Expected: 2
SELECT COUNT(*) AS boeing_aircrafts
FROM aircrafts
WHERE name LIKE '%Boeing%';

-- 7. Flights with distance between 300 and 2000 miles
-- Expected: DL222 (1765), DL37 (531)
SELECT *
FROM flights
WHERE mileage BETWEEN 300 AND 2000;

-- 8. Average flight distance booked, grouped by customer status
-- Expected: Gold 2494.5000 | None 1292.7500 | Silver 1438.3333
SELECT c.status, AVG(f.mileage) AS avg_booked_mileage
FROM bookings b
JOIN customers c ON b.customer_id = c.id
JOIN flights f   ON b.flight_number = f.flight_number
GROUP BY c.status
ORDER BY c.status;

-- 9. Most booked aircraft among Gold status members
-- Expected: Boeing 777 (3 bookings)
SELECT a.name, COUNT(*) AS total_bookings
FROM bookings b
JOIN customers c ON b.customer_id = c.id
JOIN flights f   ON b.flight_number = f.flight_number
JOIN aircrafts a ON f.aircraft_id = a.id
WHERE c.status = 'Gold'
GROUP BY a.name
ORDER BY total_bookings DESC
LIMIT 1;
