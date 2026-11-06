-- Step 2 - raw tables in Hive, loaded from HDFS
-- Note: LOAD DATA INPATH *moves* the HDFS file into the Hive warehouse and *appends* to the table.

-- 2a. Telematics events: one row per event (8,000 rows)
CREATE TABLE geolocation (
    truckid    STRING,
    driverid   STRING,
    event      STRING,     -- 'normal', 'overspeed', 'lane departure', ...
    latitude   DOUBLE,
    longitude  DOUBLE,
    city       STRING,
    state      STRING,
    velocity   BIGINT,
    event_ind  BIGINT,
    idling_ind BIGINT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

LOAD DATA INPATH '/user/cloudera/riskfactor/geolocation.csv' INTO TABLE geolocation;
SELECT * FROM geolocation LIMIT 10;

-- 2b. Trucks: one row per truck, 54 months of miles and gas as columns (Jan 2009 - Jun 2013)
CREATE TABLE trucks (
    driverid STRING,
    truckid  STRING,
    model    STRING,
    jun13_miles BIGINT, jun13_gas BIGINT,
    may13_miles BIGINT, may13_gas BIGINT,
    apr13_miles BIGINT, apr13_gas BIGINT,
    mar13_miles BIGINT, mar13_gas BIGINT,
    feb13_miles BIGINT, feb13_gas BIGINT,
    jan13_miles BIGINT, jan13_gas BIGINT,
    dec12_miles BIGINT, dec12_gas BIGINT,
    nov12_miles BIGINT, nov12_gas BIGINT,
    oct12_miles BIGINT, oct12_gas BIGINT,
    sep12_miles BIGINT, sep12_gas BIGINT,
    aug12_miles BIGINT, aug12_gas BIGINT,
    jul12_miles BIGINT, jul12_gas BIGINT,
    jun12_miles BIGINT, jun12_gas BIGINT,
    may12_miles BIGINT, may12_gas BIGINT,
    apr12_miles BIGINT, apr12_gas BIGINT,
    mar12_miles BIGINT, mar12_gas BIGINT,
    feb12_miles BIGINT, feb12_gas BIGINT,
    jan12_miles BIGINT, jan12_gas BIGINT,
    dec11_miles BIGINT, dec11_gas BIGINT,
    nov11_miles BIGINT, nov11_gas BIGINT,
    oct11_miles BIGINT, oct11_gas BIGINT,
    sep11_miles BIGINT, sep11_gas BIGINT,
    aug11_miles BIGINT, aug11_gas BIGINT,
    jul11_miles BIGINT, jul11_gas BIGINT,
    jun11_miles BIGINT, jun11_gas BIGINT,
    may11_miles BIGINT, may11_gas BIGINT,
    apr11_miles BIGINT, apr11_gas BIGINT,
    mar11_miles BIGINT, mar11_gas BIGINT,
    feb11_miles BIGINT, feb11_gas BIGINT,
    jan11_miles BIGINT, jan11_gas BIGINT,
    dec10_miles BIGINT, dec10_gas BIGINT,
    nov10_miles BIGINT, nov10_gas BIGINT,
    oct10_miles BIGINT, oct10_gas BIGINT,
    sep10_miles BIGINT, sep10_gas BIGINT,
    aug10_miles BIGINT, aug10_gas BIGINT,
    jul10_miles BIGINT, jul10_gas BIGINT,
    jun10_miles BIGINT, jun10_gas BIGINT,
    may10_miles BIGINT, may10_gas BIGINT,
    apr10_miles BIGINT, apr10_gas BIGINT,
    mar10_miles BIGINT, mar10_gas BIGINT,
    feb10_miles BIGINT, feb10_gas BIGINT,
    jan10_miles BIGINT, jan10_gas BIGINT,
    dec09_miles BIGINT, dec09_gas BIGINT,
    nov09_miles BIGINT, nov09_gas BIGINT,
    oct09_miles BIGINT, oct09_gas BIGINT,
    sep09_miles BIGINT, sep09_gas BIGINT,
    aug09_miles BIGINT, aug09_gas BIGINT,
    jul09_miles BIGINT, jul09_gas BIGINT,
    jun09_miles BIGINT, jun09_gas BIGINT,
    may09_miles BIGINT, may09_gas BIGINT,
    apr09_miles BIGINT, apr09_gas BIGINT,
    mar09_miles BIGINT, mar09_gas BIGINT,
    feb09_miles BIGINT, feb09_gas BIGINT,
    jan09_miles BIGINT, jan09_gas BIGINT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

LOAD DATA INPATH '/user/cloudera/riskfactor/trucks.csv' INTO TABLE trucks;

-- 2c. Mileage and gas summary
CREATE TABLE trucks_mg (
    driverid STRING,
    truckid  STRING,
    model    STRING,
    tdate    STRING,
    miles    BIGINT,
    gas      BIGINT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- FIX: the original run loaded this file INTO TABLE geolocation by mistake,
-- which added 100 non-telematics rows to the events table. See README > Data-quality fix.
LOAD DATA INPATH '/user/cloudera/riskfactor/trucks_mg.csv' INTO TABLE trucks_mg;

-- Sanity check: should be exactly 8000
SELECT COUNT(*) FROM geolocation;
