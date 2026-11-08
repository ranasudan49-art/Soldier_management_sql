-- Part C: Retrieve the data (25 marks)
-- ============================================================================

-- C1: The last 10 soldiers added, newest first
-- Rows returned: 10
SELECT * FROM soldiers 
ORDER BY soldier_id DESC 
LIMIT 10;

-- C2: The same 10 soldiers, displayed from lowest ID to highest ID
-- Rows returned: 10
SELECT * FROM (
    SELECT * FROM soldiers 
    ORDER BY soldier_id DESC 
    LIMIT 10
) AS subquery 
ORDER BY soldier_id ASC;

-- C3: The soldiers whose ID is 10, 15 or 20, using IN
-- Rows returned: 3
SELECT * FROM soldiers 
WHERE soldier_id IN (10, 15, 20);

-- C4: The soldiers whose ID is 10 + P, 15 + P or 20 + P, using IN
-- Using P = 7 -> IDs: 17, 22, 27
-- Rows returned: 3
SELECT * FROM soldiers 
WHERE soldier_id IN (17, 22, 27);

-- C5: Active soldiers with an ID from 10 to 20, using BETWEEN
-- Rows returned: Variable depending on seed data (up to 11)
SELECT * FROM soldiers 
WHERE status = 'Active' 
  AND soldier_id BETWEEN 10 AND 20;

-- C6: Each soldier's ID and name with their rank name, highest rank level first, then by last name
-- Rows returned: 33
SELECT s.soldier_id, s.first_name, s.last_name, r.rank_name 
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
ORDER BY r.rank_level DESC, s.last_name ASC;

-- C7: Active soldiers in unit U (2), with first name, last name, rank name, unit name and location
-- Rows returned: Variable based on seed data
SELECT s.first_name, s.last_name, r.rank_name, u.unit_name, u.location
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id
WHERE s.status = 'Active' 
  AND s.unit_id = 2;

-- C8: Everyone on mission M (3), with mission name, soldier name, role and unit name
-- Rows returned: Variable (includes at least soldiers 31 and 32)
SELECT m.mission_name, CONCAT(s.first_name, ' ', s.last_name) AS soldier_name, sm.mission_role, u.unit_name
FROM soldier_missions sm
JOIN missions m ON sm.mission_id = m.mission_id
JOIN soldiers s ON sm.soldier_id = s.soldier_id
JOIN units u ON s.unit_id = u.unit_id
WHERE sm.mission_id = 3;

-- C9: Soldiers who have never been assigned to a mission
-- Rows returned: Variable (includes at least soldier 33)
SELECT s.* 
FROM soldiers s
LEFT JOIN soldier_missions sm ON s.soldier_id = sm.soldier_id
WHERE sm.soldier_id IS NULL;

-- C10: Each unit's name and its number of soldiers, largest unit first
-- Rows returned: 6
SELECT u.unit_name, COUNT(s.soldier_id) AS number_of_soldiers
FROM units u
LEFT JOIN soldiers s ON u.unit_id = s.unit_id
GROUP BY u.unit_id, u.unit_name
ORDER BY number_of_soldiers DESC;


-- ============================================================================
-- Part D: Create an index and a view (10 marks)
-- ============================================================================

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
--Use code with caution
-- C4: The soldiers whose ID is 10 + P, 15 + P or 20 + P, using IN
-- Using P = 7 -> IDs: 17, 22, 27
-- Rows returned: 3
SELECT * FROM soldiers 
WHERE soldier_id IN (17, 22, 27);

-- C5: Active soldiers with an ID from 10 to 20, using BETWEEN
-- Rows returned: Variable depending on seed data (up to 11)
SELECT * FROM soldiers 
WHERE status = 'Active' 
  AND soldier_id BETWEEN 10 AND 20;

-- C6: Each soldier's ID and name with their rank name, highest rank level first, then by last name
-- Rows returned: 33
SELECT s.soldier_id, s.first_name, s.last_name, r.rank_name 
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
ORDER BY r.rank_level DESC, s.last_name ASC;
-- C7: Active soldiers in unit U (2), with first name, last name, rank name, unit name and location
-- Rows returned: Variable based on seed data
SELECT s.first_name, s.last_name, r.rank_name, u.unit_name, u.location
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id
WHERE s.status = 'Active' 
  AND s.unit_id = 2;

-- C8: Everyone on mission M (3), with mission name, soldier name, role and unit name
-- Rows returned: Variable (includes at least soldiers 31 and 32)
SELECT m.mission_name, CONCAT(s.first_name, ' ', s.last_name) AS soldier_name, sm.mission_role, u.unit_name
FROM soldier_missions sm
JOIN missions m ON sm.mission_id = m.mission_id
JOIN soldiers s ON sm.soldier_id = s.soldier_id
JOIN units u ON s.unit_id = u.unit_id
WHERE sm.mission_id = 3;
-- C9: Soldiers who have never been assigned to a mission
-- Rows returned: Variable (includes at least soldier 33)
SELECT s.* 
FROM soldiers s
LEFT JOIN soldier_missions sm ON s.soldier_id = sm.soldier_id
WHERE sm.soldier_id IS NULL;

-- C10: Each unit's name and its number of soldiers, largest unit first
-- Rows returned: 6
SELECT u.unit_name, COUNT(s.soldier_id) AS number_of_soldiers
FROM units u
LEFT JOIN soldiers s ON u.unit_id = s.unit_id
GROUP BY u.unit_id, u.unit_name
ORDER BY number_of_soldiers DESC;
