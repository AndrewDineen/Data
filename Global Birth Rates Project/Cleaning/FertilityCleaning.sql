SELECT
	*
FROM
	INDICATORS
LIMIT
	20
	--Cross field validation
SELECT
	"Indicator",
	"Age Group"
FROM
	INDICATORS
WHERE
	"Age Group" = '[Total]'
	AND "Indicator" NOT IN ('TFR', 'MAC')
SELECT
	"Indicator",
	"Age Group"
FROM
	INDICATORS
WHERE
	"Age Group" <> '[Total]'
	AND "Indicator" IN ('TFR', 'MAC')
	--Country / area codes should uniquely identify the country
SELECT
	*
FROM
	INDICATORS I1
	JOIN INDICATORS I2 ON I1."Country or Area Code" = I2."Country or Area Code"
	AND I1."Country or Area" <> I2."Country or Area"
SELECT
	*
FROM
	INDICATORS I1
	JOIN INDICATORS I2 ON I1."Country or Area" = I2."Country or Area"
	AND I1."Country or Area Code" <> I2."Country or Area Code"
	--Remove irrelevant data
BEGIN;

DELETE FROM INDICATORS
WHERE
	"Date" < 1980;

DELETE FROM INDICATORS
WHERE
	"Age Group" <> '[Total]';

ALTER TABLE INDICATORS
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

SELECT
	*
FROM
	INDICATORS
ORDER BY
	"Date";

ROLLBACK;

--Remove Duplicates
BEGIN;

CREATE TABLE INDICATORS_DUPES_REMOVED AS
SELECT
	*
FROM
	INDICATORS
GROUP BY
	"Country or Area",
	"Country or Area Code",
	"Indicator",
	"Date",
	"Value";

SELECT
	COUNT(*)
FROM
	INDICATORS_DUPES_REMOVED
ROLLBACK;

SELECT
	*
FROM
	INDICATORS_DUPES_REMOVED
ORDER BY
	"Date";

--Data range constraints
SELECT
	*
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	"Date" < 1980
	OR "Date" > 2019
	--Membership contraints
SELECT DISTINCT
	"Country or Area"
FROM
	INDICATORS_DUPES_REMOVED
SELECT DISTINCT
	"Indicator"
FROM
	INDICATORS_DUPES_REMOVED
	--Missing values
SELECT
	*
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	COALESCE("Country or Area", '') = '';

SELECT
	*
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	COALESCE("Country or Area Code", '') = '';

SELECT
	*
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	COALESCE("Indicator", '') = '';

--Outliers
SELECT
	MAX("Value"),
	MIN("Value")
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	"Indicator" = 'MAC'
SELECT
	MAX("Value"),
	MIN("Value")
FROM
	INDICATORS_DUPES_REMOVED
WHERE
	"Indicator" = 'TFR'