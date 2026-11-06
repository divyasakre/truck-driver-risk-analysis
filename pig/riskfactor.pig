-- Risk factor = unsafe events per million miles, per driver
-- Run with:  pig -useHCatalog riskfactor.pig
-- Reads Hive tables through HCatalog and writes the result back into the Hive table 'riskfactor'.

a = LOAD 'geolocation' USING org.apache.hive.hcatalog.pig.HCatLoader();
b = FILTER a BY event != 'normal';                                    -- keep unsafe events only
c = FOREACH b GENERATE driverid, event, (int) '1' AS occurance;
d = GROUP c BY driverid;
e = FOREACH d GENERATE group AS driverid, SUM(c.occurance) AS t_occ;   -- unsafe events per driver

g = LOAD 'drivermileage' USING org.apache.hive.hcatalog.pig.HCatLoader();
h = JOIN e BY driverid, g BY driverid;

final_data = FOREACH h GENERATE
    $0 AS driverid,
    $1 AS events,
    $3 AS totmiles,
    (float) $1 / $3 * 1000000 AS riskfactor;

STORE final_data INTO 'riskfactor' USING org.apache.hive.hcatalog.pig.HCatStorer();
