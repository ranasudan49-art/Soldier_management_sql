-- Part A: Create the tables (
-- ============================================================================

-- Create ranks table with constraints
-- Enforces: PK, required & unique name, level constraint (1 to 6)
CREATE TABLE ranks (
    rank_id INT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL UNIQUE,
    rank_level INT NOT NULL CHECK (rank_level BETWEEN 1 AND 6)
);

-- Create units table
-- Enforces: PK, required & unique name, required location
CREATE TABLE units (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

-- Create missions table
-- Enforces: PK, required & unique name, end date logic constraint
CREATE TABLE missions (
    mission_id INT PRIMARY KEY,
    mission_name VARCHAR(100) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT chk_mission_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Create soldiers table
-- Enforces: Auto-increment PK, unique service number, status choices, date logic, and FKs
CREATE TABLE soldiers (
    soldier_id INT AUTO_INCREMENT PRIMARY KEY,
    service_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    enlistment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'On Leave', 'Retired')),
    rank_id INT NOT NULL,
    unit_id INT NOT NULL,
    CONSTRAINT fk_soldier_rank FOREIGN KEY (rank_id) REFERENCES ranks(rank_id),
    CONSTRAINT fk_soldier_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_enlistment_date CHECK (enlistment_date > date_of_birth)
);

-- Create soldier_missions bridge table
-- Enforces: Unique assignments per mission via composite PK, required roles, and FKs
CREATE TABLE soldier_missions (
    soldier_id INT NOT NULL,
    mission_id INT NOT NULL,
    mission_role VARCHAR(100) NOT NULL,
    PRIMARY KEY (soldier_id, mission_id),
    CONSTRAINT fk_sm_soldier FOREIGN KEY (soldier_id) REFERENCES soldiers(soldier_id),
    CONSTRAINT fk_sm_mission FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);


-- ============================================================================
-- ============================================================================

-- B1: Insert seed data for ranks
INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
(1, 'Private', 1),
(2, 'Corporal', 2),
(3, 'Sergeant', 3),
(4, 'Lieutenant', 4),
(5, 'Captain', 5),
(6, 'Major', 6);

-- B1: Insert seed data for units
INSERT INTO units (unit_id, unit_name, location) VALUES
(1, 'Alpha Company', 'North Camp'),
(2, 'Bravo Company', 'South Camp'),
(3, 'Charlie Company', 'East Camp'),
(4, 'Delta Company', 'West Camp'),
(5, 'Signals Unit', 'Central Camp'),
(6, 'Medical Unit', 'Central Camp');

-- B1: Insert seed data for missions
INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
(1, 'Exercise Falcon', '2025-02-03', '2025-02-28'),
(2, 'Flood Relief', '2025-04-14', '2025-05-30'),
(3, 'Border Patrol', '2025-07-01', NULL),
(4, 'Peace Support', '2025-09-15', NULL),
(5, 'Field Medical Camp', '2026-01-12', '2026-01-23');

-- B3: Insert three specific soldiers (IDs 31, 32, 33) using example values
-- For student number 2401237: P=7, U=2, M=3
-- Soldier 31: rank_id = 1, unit_id = U (2)
-- Soldier 32: rank_id = (7%6)+1 = 2, unit_id = U (2)
-- Soldier 33: rank_id = 2, unit_id = (2%6)+1 = 3
INSERT INTO soldiers (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id) VALUES
(31, 'ST-2401237', 'John', 'Doe', '2000-05-15', '2021-01-10', 'Active', 1, 2),
(32, 'ST-2401237-2', 'Jane', 'Smith', '1998-08-22', '2020-03-15', 'Active', 2, 2),
(33, 'ST-2401237-3', 'Alex', 'Jones', '1999-11-05', '2022-06-01', 'Active', 2, 3);

-- B3: Assign soldiers 31 and 32 to mission M (3)
INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
(31, 3, 'Rifleman'),
(32, 3, 'Team Leader');




