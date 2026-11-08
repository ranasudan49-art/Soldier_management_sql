-- ============================================================================
-- Change Order Phase (10 marks)
-- ============================================================================

-- Task 1: Add a new column to track deployment eligibility or budget allocations.
-- Comment: Adding a column to track special clearance permissions for high-risk missions.
ALTER TABLE soldiers 
ADD COLUMN security_clearance_level INT DEFAULT 1;

-- Task 2: Update existing records based on your personal variable P.
-- Comment: Elevate clearance clearance level to match P (7) for highly ranked soldiers.
-- Rows affected: Variable based on seed data
UPDATE soldiers 
SET security_clearance_level = 7 
WHERE rank_id >= 4;

-- Task 3: Establish a historical archive logging operation changes.
-- Comment: Create an audit table tracking when missions change status or descriptions.
CREATE TABLE mission_logs (
    log_id SERIAL PRIMARY KEY,
    mission_id INT NOT NULL,
    status_change_notes VARCHAR(255) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_logs_mission FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);

-- Task 4: Execute a complex delete or modification based on your personal variables.
-- Comment: Clean up or transition completed missions occurring prior to current systems.
-- Rows affected: Variable based on seed data
UPDATE missions 
SET end_date = '2026-11-06' 
WHERE mission_id = 3 AND end_date IS NULL; 



