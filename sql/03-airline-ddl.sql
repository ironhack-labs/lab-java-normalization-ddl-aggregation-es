-- =====================================================================
-- Exercise 2 - Airline database: normalized schema (3NF)
-- Target: MySQL 8.0.16+ (CHECK constraints are enforced from that version)
--
-- Functional dependencies in the raw table:
--   customer_name -> customer_status, total_customer_mileage
--   flight_number -> aircraft, flight_mileage
--   aircraft      -> total_aircraft_seats
--
-- aircraft -> seats is a transitive dependency through flight_number,
-- so aircraft gets its own table (3NF). The remaining rows are the
-- many-to-many relation "customer booked flight".
--
-- The raw data repeats identical rows (e.g. Agustine Riviera / DL143
-- four times), so a customer can book the same flight more than once.
-- bookings therefore uses a surrogate id instead of a composite
-- (customer_id, flight_number) key, which would drop those rows.
--
-- Total customer mileage is NOT derivable from the bookings (Agustine's
-- bookings add up to 4,910 miles, not 115,235), so it is a stored
-- attribute of the customer rather than a computed value.
--
-- Column names match the queries given in Exercise 3.
-- =====================================================================

DROP DATABASE IF EXISTS airline_db;
CREATE DATABASE airline_db;
USE airline_db;

CREATE TABLE aircrafts (
    id          INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    total_seats INT         NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_aircrafts_name UNIQUE (name),
    CONSTRAINT chk_aircrafts_total_seats CHECK (total_seats > 0)
);

CREATE TABLE flights (
    flight_number VARCHAR(10) NOT NULL,
    aircraft_id   INT         NOT NULL,
    mileage       INT         NOT NULL,
    PRIMARY KEY (flight_number),
    CONSTRAINT fk_flights_aircraft FOREIGN KEY (aircraft_id) REFERENCES aircrafts (id),
    CONSTRAINT chk_flights_mileage CHECK (mileage > 0),
    INDEX idx_flights_aircraft_id (aircraft_id),
    -- Supports range filters such as "mileage BETWEEN 300 AND 2000".
    INDEX idx_flights_mileage (mileage)
);

CREATE TABLE customers (
    id            INT          NOT NULL AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    status        VARCHAR(10)  NOT NULL DEFAULT 'None',
    total_mileage INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT chk_customers_status CHECK (status IN ('None', 'Silver', 'Gold')),
    CONSTRAINT chk_customers_total_mileage CHECK (total_mileage >= 0),
    -- Supports the GROUP BY status / WHERE status = 'Gold' queries.
    INDEX idx_customers_status (status)
);

CREATE TABLE bookings (
    id            INT         NOT NULL AUTO_INCREMENT,
    customer_id   INT         NOT NULL,
    flight_number VARCHAR(10) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_bookings_customer FOREIGN KEY (customer_id) REFERENCES customers (id),
    CONSTRAINT fk_bookings_flight FOREIGN KEY (flight_number) REFERENCES flights (flight_number),
    INDEX idx_bookings_customer_id (customer_id),
    INDEX idx_bookings_flight_number (flight_number)
);
