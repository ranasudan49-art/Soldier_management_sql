-- D1: Run initial EXPLAIN plan
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';

-- Create optimization index on last_name column
CREATE INDEX idx_soldiers_last_name ON soldiers(last_name);

-- Run second EXPLAIN to verify performance improvement
-- Observation: The 'type' column changes from 'ALL' (full table scan) to 'ref' (index lookup).
-- The 'key' column changes from NULL to 'idx_soldiers_last_name', proving the database now uses the index.
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';

-- D2: Create a view named v_soldier_profile
CREATE VIEW v_soldier_profile AS
SELECT 
    s.soldier_id, 
    CONCAT(s.first_name, ' ', s.last_name) AS full_name, 
    r.rank_name, 
    u.unit_name, 
    u.location, 
    s.status
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id;

-- D3: Use the profile view to filter for unit U (2) ordered by full name
-- Rows returned: Variable matching unit 2 records
SELECT * FROM v_soldier_profile
WHERE unit_name = (SELECT unit_name FROM units WHERE unit_id = 2)
ORDER BY full_name ASC;