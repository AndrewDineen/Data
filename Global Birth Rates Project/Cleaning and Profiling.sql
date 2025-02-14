Select * FROM indicators


--Cross field validation
SELECT "Indicator", "Age Group" from indicators where "Age Group" = '[Total]' AND "Indicator" NOT IN('TFR', 'MAC')
SELECT "Indicator", "Age Group" from indicators where "Age Group" <> '[Total]' AND "Indicator" IN('TFR', 'MAC')
--Country / area codes should uniquely identify the country
SELECT * FROM indicators i1 JOIN indicators i2 on i1."Country or Area Code" = i2."Country or Area Code" and i1."Country or Area" <> i2."Country or Area"

--Remove irrelevant data
BEGIN;
Delete from indicators where "Date" < 1980;
Delete FROM indicators WHERE "Age Group" <> '[Total]';
ALTER TABLE indicators
DROP COLUMN "Age Group",
DROP COLUMN "Series",
DROP COLUMN "DataType",
DROP COLUMN "Data Source Type",
DROP COLUMN "Survey Programme",
DROP COLUMN "Data Source Inventory ID",
DROP COLUMN "Data Source Name",
DROP COLUMN "Short Data Source Name",
DROP COLUMN "Reference",
DROP COLUMN "Data Source Start Year",
DROP COLUMN "Data Source End Year",
DROP COLUMN "Reference Year";
SELECT * FROM indicators ORDER BY "Date";
ROLLBACK;


--Remove Duplicates
BEGIN;
CREATE TABLE indicators_dupes_removed AS
SELECT *
FROM indicators GROUP BY "Country or Area", "Country or Area Code", "Indicator", "Date", "Value";
SELECT count(*) from indicators_dupes_removed
ROLLBACK;

SELECT * FROM indicators_dupes_removed ORDER BY "Date";

--Data range constraints
SELECT * FROM indicators_dupes_removed WHERE "Date" < 1980 OR "Date" > 2019

--Membership contraints
SELECT distinct "Country or Area" from indicators_dupes_removed
SELECT distinct "Indicator" from indicators_dupes_removed

--Missing values
SELECT * FROM indicators_dupes_removed WHERE COALESCE("Country or Area", '') = '';
SELECT * FROM indicators_dupes_removed WHERE COALESCE("Country or Area Code", '') = '';
SELECT * FROM indicators_dupes_removed WHERE COALESCE("Indicator", '') = '';

--Outliers
SELECT MAX("Value"), MIN("Value") FROM indicators_dupes_removed WHERE "Indicator" = 'MAC'
SELECT MAX("Value"), MIN("Value") FROM indicators_dupes_removed WHERE "Indicator" = 'TFR'



