-- Retrieve all records from key tables
SELECT * FROM locations;
SELECT * FROM make_details;
SELECT * FROM stolen_vehicles;

-- CHECKING & DELETING MISSING VALUES

-- Count missing values in locations table
SELECT COUNT(*) AS missing_values
FROM locations
WHERE region IS NULL;

-- Delete rows with missing model_year in stolen_vehicles table
DELETE FROM stolen_vehicles
WHERE model_year IS NULL;

-- CHECKING FOR DUPLICATES

-- Identify duplicate records based on key attributes
SELECT date_stolen, make_id, model_year, vehicle_type, location_id, COUNT(*) AS record_count
FROM stolen_vehicles
GROUP BY date_stolen, make_id, model_year, vehicle_type, location_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- A. UNDERSTANDING THEFT TRENDS OVER TIME

-- 1. Total number of vehicle thefts per year
SELECT MIN(date_stolen) AS first_theft, MAX(date_stolen) AS last_theft
FROM stolen_vehicles;

SELECT COUNT(*) AS thefts_2021
FROM stolen_vehicles
WHERE date_stolen LIKE '%2021%';

SELECT COUNT(*) AS thefts_2022
FROM stolen_vehicles
WHERE date_stolen LIKE '%2022%';

-- 2. Most common months for vehicle thefts
SELECT MONTH(date_stolen) AS theft_month, COUNT(*) AS theft_count
FROM stolen_vehicles
GROUP BY theft_month
ORDER BY theft_count DESC;

-- 3. Most common days of the week for vehicle thefts
SELECT DAYOFWEEK(date_stolen) AS theft_day, COUNT(*) AS theft_count
FROM stolen_vehicles
GROUP BY theft_day
ORDER BY theft_count DESC;

-- B. IDENTIFYING THE MOST STOLEN VEHICLES

-- 1. Most stolen vehicle makes and models
SELECT sv.model_year, md.make_name, COUNT(*) AS theft_count
FROM stolen_vehicles sv
LEFT JOIN make_details md ON sv.make_id = md.make_id
GROUP BY sv.model_year, md.make_name
ORDER BY theft_count DESC;

-- 2. Most stolen vehicle brands
SELECT md.make_name, COUNT(*) AS total_thefts
FROM stolen_vehicles sv
JOIN make_details md ON sv.make_id = md.make_id
GROUP BY md.make_name
ORDER BY total_thefts DESC
LIMIT 10;

-- 3. Most stolen vehicle colors
SELECT color, COUNT(*) AS theft_count
FROM stolen_vehicles
GROUP BY color
ORDER BY theft_count DESC;

-- 4. Are older or newer vehicles stolen more frequently?
SELECT model_year, COUNT(*) AS theft_count
FROM stolen_vehicles
GROUP BY model_year
ORDER BY theft_count DESC
LIMIT 10;

-- Categorizing vehicle thefts by age group
SELECT
    CASE
        WHEN model_year >= YEAR(CURDATE()) - 5 THEN 'New (0-5 years)'
        WHEN model_year >= YEAR(CURDATE()) - 10 THEN 'Moderate (6-10 years)'
        ELSE 'Old (10+ years)'
    END AS vehicle_age_group,
    COUNT(*) AS total_thefts
FROM stolen_vehicles
GROUP BY vehicle_age_group
ORDER BY total_thefts DESC;

-- Find the oldest and newest vehicles stolen
SELECT MIN(model_year) AS oldest_vehicle, MAX(model_year) AS newest_vehicle
FROM stolen_vehicles;

-- 5. Vehicle types stolen by season
SELECT vehicle_type, MONTH(date_stolen) AS theft_month, COUNT(*) AS theft_count
FROM stolen_vehicles
GROUP BY vehicle_type, theft_month
ORDER BY theft_count DESC;

-- 6. Most stolen vehicle type per date
SELECT vehicle_type, date_stolen, theft_count
FROM (
    SELECT vehicle_type, date_stolen, COUNT(*) AS theft_count,
           RANK() OVER (PARTITION BY date_stolen ORDER BY COUNT(*) DESC) AS rank_order
    FROM stolen_vehicles
    GROUP BY vehicle_type, date_stolen
) ranked
WHERE rank_order = 1
ORDER BY theft_count DESC;

-- C. IDENTIFYING HIGH-RISK LOCATIONS

-- 1. Regions with the highest vehicle theft rates
SELECT lo.region, COUNT(*) AS theft_count
FROM locations lo
LEFT JOIN stolen_vehicles sv ON lo.location_id = sv.location_id
GROUP BY lo.region
ORDER BY theft_count DESC;

-- 2. Is vehicle theft more common in densely populated areas?
SELECT lo.region, lo.density, COUNT(*) AS theft_count
FROM locations lo
LEFT JOIN stolen_vehicles sv ON lo.location_id = sv.location_id
GROUP BY lo.region, lo.density
ORDER BY theft_count DESC;

-- 3. Influence of population size on vehicle thefts
SELECT lo.region, lo.population, COUNT(*) AS theft_count
FROM locations lo
LEFT JOIN stolen_vehicles sv ON lo.location_id = sv.location_id
GROUP BY lo.region, lo.population
ORDER BY theft_count DESC;

-- 4. Vehicle theft by location type
SELECT lo.region, sv.vehicle_type, COUNT(*) AS total_thefts
FROM stolen_vehicles sv
JOIN locations lo ON sv.location_id = lo.location_id
GROUP BY lo.region, sv.vehicle_type
ORDER BY total_thefts DESC;

-- D. PATTERNS IN PEAK THEFT MONTHS (SUMMER)

-- 1. Most stolen vehicle types in peak theft months (Dec, Jan, Feb, Mar)
SELECT sv.vehicle_type, COUNT(*) AS total_thefts
FROM stolen_vehicles sv
WHERE MONTH(sv.date_stolen) IN (12, 1, 2, 3)
GROUP BY sv.vehicle_type
ORDER BY total_thefts DESC;

-- 2. Most stolen vehicle brands & models in peak months
SELECT md.make_name, sv.model_year, COUNT(*) AS total_thefts
FROM stolen_vehicles sv
JOIN make_details md ON sv.make_id = md.make_id
WHERE MONTH(sv.date_stolen) IN (12, 1, 2, 3)
GROUP BY md.make_name, sv.model_year
ORDER BY total_thefts DESC
LIMIT 10;

-- 3. High-theft locations in peak months
SELECT lo.region, COUNT(*) AS total_thefts
FROM stolen_vehicles sv
JOIN locations lo ON sv.location_id = lo.location_id
WHERE MONTH(sv.date_stolen) IN (12, 1, 2, 3)
GROUP BY lo.region
ORDER BY total_thefts DESC
LIMIT 10;

-- 4. Compare theft rates in peak vs. other months
SELECT 
    CASE 
        WHEN MONTH(sv.date_stolen) IN (12, 1, 2, 3) THEN 'Peak Months'
        ELSE 'Other Months'
    END AS month_group,
    COUNT(*) AS total_thefts
FROM stolen_vehicles sv
GROUP BY month_group;
