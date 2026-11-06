-- Step 5 - Enhanced Total Risk Score (ETRS): my extension of the course method
-- Combines the risk factor with event frequency, speed and idling, then buckets drivers into 4 tiers.
-- Written without window functions so it runs on the older Hive in CDH 5.4.

-- 5a. One row per driver: risk factor + driving behaviour from the telematics events
CREATE TABLE driver_behavior AS
SELECT
    r.driverid,
    r.events,
    r.totmiles,
    r.riskfactor,
    AVG(g.velocity)   AS avg_velocity,
    SUM(g.idling_ind) AS total_idling
FROM riskfactor r
JOIN geolocation g ON r.driverid = g.driverid
GROUP BY r.driverid, r.events, r.totmiles, r.riskfactor;

-- 5b. Fleet-wide maximums, used to normalise each measure to 0-1
CREATE TABLE driver_behavior_max AS
SELECT
    MAX(events)       AS max_events,
    MAX(avg_velocity) AS max_velocity,
    MAX(total_idling) AS max_idling
FROM driver_behavior;

-- 5c. Component scores and the weighted ETRS
CREATE TABLE advanced_risk AS
SELECT
    d.driverid,
    d.events,
    d.totmiles,
    d.riskfactor,
    d.avg_velocity,
    d.total_idling,
    d.riskfactor   / 10.0           AS riskfactor_normalized,
    d.events       / m.max_events   AS unsafe_event_score,
    d.avg_velocity / m.max_velocity AS velocity_score,
    d.total_idling / m.max_idling   AS idling_score,
      0.5 * (d.riskfactor   / 10.0)
    + 0.3 * (d.events       / m.max_events)
    + 0.1 * (d.avg_velocity / m.max_velocity)
    + 0.1 * (d.total_idling / m.max_idling) AS etrs
FROM driver_behavior d
CROSS JOIN driver_behavior_max m;

-- 5d. Risk tiers
CREATE TABLE advanced_risk_category AS
SELECT
    *,
    CASE
        WHEN etrs >= 0.85 OR events >= 200 THEN 'Critical'
        WHEN etrs >= 0.65 THEN 'High'
        WHEN etrs >= 0.40 THEN 'Medium'
        ELSE 'Low'
    END AS risk_category
FROM advanced_risk;

-- 5e. Answer the business question: who needs attention first?
SELECT risk_category, COUNT(*) AS driver_count
FROM advanced_risk_category
GROUP BY risk_category
ORDER BY driver_count DESC;

SELECT *
FROM advanced_risk_category
WHERE risk_category IN ('Critical', 'High')
ORDER BY etrs DESC;
