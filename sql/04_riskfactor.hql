-- Step 4 - risk factor table (populated by pig/riskfactor.pig) and high-risk list

-- 4a. Empty target table; the Pig script writes into it through HCatalog
CREATE TABLE riskfactor (
    driverid   STRING,
    events     BIGINT,
    totmiles   BIGINT,
    riskfactor FLOAT
);

-- 4b. Run from the shell:   pig -useHCatalog pig/riskfactor.pig

-- 4c. Validate
SELECT * FROM riskfactor LIMIT 10;

-- 4d. Drivers at or above the course threshold of 7 unsafe events per million miles
CREATE TABLE high_risk_drivers AS
SELECT *
FROM riskfactor
WHERE riskfactor >= 7.0
ORDER BY riskfactor DESC;
