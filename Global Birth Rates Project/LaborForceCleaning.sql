SELECT
	*
FROM
	LFP_DIRTY
LIMIT
	10
SELECT DISTINCT
	OBS_STATUS
FROM
	LFP_DIRTY
SELECT DISTINCT
	SEX
FROM
	LFP_DIRTY
SELECT DISTINCT
	NOTE_I
FROM
	LFP_DIRTY
	--Drop irrelevant columns
BEGIN;

--Amount of data classified for use with caution or as potentially unreliable is within acceptable range
ALTER TABLE LFP_DIRTY
DROP COLUMN OBS_STATUS
DROP COLUMN NOTE_CLAS,
DROP COLUMN NOTE_I,
DROP COLUMN NOTE_S;

SELECT
	*
FROM
	LFP_DIRTY
WHERE
	OBS_STATUS = ''
LIMIT
	20
COMMIT;

--Type Constraints
SELECT DISTINCT
	TIME
FROM
	LFP_DIRTY
	--Range Constraints
DELETE FROM LFP_DIRTY
WHERE
	CAST("time" AS INTEGER) NOT BETWEEN 2000 AND 2019;

SELECT
	MAX(CAST("time" AS INTEGER)),
	MIN(CAST("time" AS INTEGER))
FROM
	LFP_DIRTY
	--Uniqueness Constraints
SELECT
	*,
	COUNT(*)
FROM
	LFP_DIRTY
GROUP BY
	REF_AREA,
	"source",
	"indicator",
	SEX,
	CLASSIF1,
	CLASSIF2,
	TIME,
	OBS_VALUE
HAVING
	COUNT(*) > 1
	--Membership Constraints (Categorical)
DELETE FROM LFP_DIRTY
WHERE
	SEX <> 'Sex: Female';

--Ensure countries match between datasets, delete countries that aren't in both datasets
SELECT
	*
FROM
	(
		SELECT DISTINCT
			LFP.REF_AREA,
			TFR."Country or Area"
		FROM
			LFP_DIRTY LFP
			FULL OUTER JOIN TFR_CLEANED TFR ON LFP.REF_AREA = TFR."Country or Area"
		ORDER BY
			LFP.REF_AREA,
			TFR."Country or Area"
	)
WHERE
	REF_AREA IS NULL
	OR "Country or Area" IS NULL
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Congo, Democratic Republic of the'
WHERE
	"Country or Area" = 'Dem. Rep. of the Congo'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Hong Kong, China'
WHERE
	"Country or Area" = 'China, Hong Kong SAR'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Lao People''s Democratic Republic'
WHERE
	"Country or Area" = 'Lao People''s Dem. Republic'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Macao, China'
WHERE
	"Country or Area" = 'China, Macao SAR'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Micronesia (Federated States of)'
WHERE
	"Country or Area" = 'Micronesia (Fed. States of)'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'United Kingdom of Great Britain and Northern Ireland'
WHERE
	"Country or Area" = 'United Kingdom'
UPDATE TFR_CLEANED
SET
	"Country or Area" = 'Türkiye'
WHERE
	"Country or Area" = 'Turkey'
BEGIN;

DELETE FROM TFR_CLEANED
WHERE
	"Country or Area" NOT IN (
		SELECT
			REF_AREA
		FROM
			LFP_DIRTY
	);

DELETE FROM LFP_DIRTY
WHERE
	REF_AREA NOT IN (
		SELECT
			"Country or Area"
		FROM
			TFR_CLEANED
	);

COMMIT
SELECT DISTINCT
	CLASSIF1
FROM
	LFP_DIRTY
SELECT DISTINCT
	CLASSIF2
FROM
	LFP_DIRTY
	--Missing Data (MCAR, MAR, MNAR)
SELECT
	*
FROM
	LFP_DIRTY
WHERE
	OBS_VALUE IN ('', '0')
	--Are any countries missing more than 40% of data
SELECT
	REF_AREA
FROM
	(
		SELECT
			REF_AREA,
			(
				SUM(
					CASE
						WHEN OBS_VALUE IN ('', '0') THEN 1
						ELSE 0
					END
				) / COUNT(*)::NUMERIC * 100
			) AS PERCENT_MISSING
		FROM
			LFP_DIRTY
		GROUP BY
			REF_AREA
	)
WHERE
	PERCENT_MISSING >= 39
	--Make sure we atleast have total participation for most years consecutively
SELECT DISTINCT
	REF_AREA,
	"time"
FROM
	LFP_DIRTY
WHERE
	(REF_AREA, "time") NOT IN (
		SELECT
			REF_AREA,
			"time"
		FROM
			LFP_DIRTY
		WHERE
			CLASSIF1 = 'Age (10-year bands): Total'
			AND CLASSIF2 = 'Education (Aggregate levels): Total'
		GROUP BY
			REF_AREA,
			"time"
	)
ORDER BY
	REF_AREA,
	"time"
	--Address outliers (if necessary)
SELECT
	REF_AREA,
	OBS_VALUE
FROM
	LFP_DIRTY
WHERE
	OBS_VALUE <> ''
ORDER BY
	CAST(COALESCE(OBS_VALUE, '0') AS NUMERIC) DESC