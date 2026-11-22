-- CareLoop Clinics — Task 2.1 database and table creation
-- Run this first in MySQL Workbench, before running your data-load INSERT script.

CREATE DATABASE IF NOT EXISTS noshowguard;
USE noshowguard;

-- Only use these DROP statements if you intend to rebuild the database from scratch.
-- They delete the existing tables and their data.
-- DROP TABLE IF EXISTS appointments;
-- DROP TABLE IF EXISTS clinics;

CREATE TABLE IF NOT EXISTS clinics (
    clinic_id VARCHAR(5) PRIMARY KEY,
    clinic_name VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    tier VARCHAR(10),
    latitude DECIMAL(8,4),
    longitude DECIMAL(8,4),
    temp_c DECIMAL(5,1)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id VARCHAR(8) PRIMARY KEY,
    patient_id VARCHAR(8) NOT NULL,
    clinic_id VARCHAR(5) NOT NULL,
    booked_on DATE,
    appt_date DATE,
    age INT,
    gender VARCHAR(1),
    distance_km DECIMAL(5,1),
    fee_inr INT,
    booking_channel VARCHAR(10),
    visit_type VARCHAR(12),
    reminder_sent VARCHAR(3),
    prior_no_shows INT,
    status VARCHAR(10),
    lead_days INT,
    no_show INT,
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
);

-- After creating the tables, run Task_2.1_Data_Load_and_Verification.sql.
-- Then run Task_2_1_and_2_2_Extra_Checks.sql for the duplicate-key test
-- and the all-eight-clinics query.
