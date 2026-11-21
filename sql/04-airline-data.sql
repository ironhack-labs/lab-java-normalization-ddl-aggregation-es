-- =====================================================================
-- Exercise 2 - Airline database: sample data (step 4)
-- Run after 03-airline-ddl.sql
-- =====================================================================

USE airline_db;

INSERT INTO aircrafts (id, name, total_seats) VALUES
    (1, 'Boeing 747',  400),
    (2, 'Airbus A330', 236),
    (3, 'Boeing 777',  264);

INSERT INTO flights (flight_number, aircraft_id, mileage) VALUES
    ('DL143', 1, 135),
    ('DL122', 2, 4370),
    ('DL53',  3, 2078),
    ('DL222', 3, 1765),
    ('DL37',  1, 531);

INSERT INTO customers (id, name, status, total_mileage) VALUES
    (1, 'Agustine Riviera', 'Silver', 115235),
    (2, 'Alaina Sepulvida', 'None',   6008),
    (3, 'Tom Jones',        'Gold',   205767),
    (4, 'Sam Rio',          'None',   2653),
    (5, 'Jessica James',    'Silver', 127656),
    (6, 'Ana Janco',        'Silver', 136773),
    (7, 'Jennifer Cortez',  'Gold',   300582),
    (8, 'Christian Janco',  'Silver', 14642);

-- One row per row of the original table, in the same order (17 bookings).
INSERT INTO bookings (customer_id, flight_number) VALUES
    (1, 'DL143'),
    (1, 'DL122'),
    (2, 'DL122'),
    (1, 'DL143'),
    (3, 'DL122'),
    (3, 'DL53'),
    (1, 'DL143'),
    (4, 'DL143'),
    (1, 'DL143'),
    (3, 'DL222'),
    (5, 'DL143'),
    (4, 'DL143'),
    (6, 'DL222'),
    (7, 'DL222'),
    (5, 'DL122'),
    (4, 'DL37'),
    (8, 'DL222');

-- Sanity check: rebuilds the original flat table from the normalized one.
SELECT c.name          AS customer_name,
       c.status        AS customer_status,
       f.flight_number,
       a.name          AS aircraft,
       a.total_seats   AS total_aircraft_seats,
       f.mileage       AS flight_mileage,
       c.total_mileage AS total_customer_mileage
FROM bookings b
JOIN customers c ON b.customer_id = c.id
JOIN flights f   ON b.flight_number = f.flight_number
JOIN aircrafts a ON f.aircraft_id = a.id
ORDER BY b.id;
