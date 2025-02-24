SELECT * FROM frt_clean_new limit 10
SELECT * FROM cpi_clean limit 10
SELECT * FROM lfp_clean limit 10
SELECT distinct classif1 from lfp_clean
SELECT distinct classif2 from lfp_clean



--Top countries by TFR, MAC
--What are the top 10 countries for each stat?
SELECT top_10_tfr.*, top_10_mac.*  FROM 
(SELECT country, ROUND(AVG(frt_value), 2) as Average_Fertility 
FROM frt_clean_new fr 
WHERE fr."Indicator" = 'TFR' 
group by country 
order by Average_Fertility 
DESC limit 10) top_10_tfr 
FULL OUTER JOIN (
SELECT country, ROUND(AVG(frt_value), 2) as Average_MAC 
FROM frt_clean_new fr 
WHERE fr."Indicator" = 'MAC'
group by country 
order by Average_MAC DESC limit 10
) top_10_mac ON top_10_tfr.country = top_10_mac.country

--Correlation between TFR and MAC
--0.3
-- P-Value: < 0.00001 < (Alpha = 0.01): Significant
SELECT CORR(tfr.Fertility, mac.MAC) AS Corr_TFR_MAC, Count(*) as sample_size FROM (
	SELECT country, obs_year, frt_value as Fertility FROM frt_clean_new WHERE "Indicator" = 'TFR'
)tfr
JOIN (
	SELECT country, obs_year, frt_value as MAC FROM frt_clean_new WHERE "Indicator" = 'MAC'  
)mac on tfr.country = mac.country and tfr.obs_year = mac.obs_year

--Correlation between CPI and TFR
--0.17
--P-Value: < 0.00001 < (Alpha = 0.01): Significant
SELECT CORR(tfr.Fertility, cpi.CPI) AS Corr_TFR_Cpi, Count(*) as sample_size FROM (
	SELECT country, obs_year, frt_value as Fertility FROM frt_clean_new WHERE "Indicator" = 'TFR'
)tfr
JOIN (
	SELECT country, obs_year, cpi_value as CPI FROM cpi_clean  
)cpi on tfr.country = cpi.country and tfr.obs_year = CAST(cpi.obs_year as integer)

--This will compare CPI and TFR for the same year. 
--However, CPI numbers are published a officially at a later time (for example, 1 year later)
--This also doesn't tell us how averages over the last 5 years. Let's compute something similar to a moving average.
--Correlations accross different countries are a mixed bag ranging from -0.98 to 0.92
With moving_avg_5_year AS (
SELECT frt.country, frt.obs_year, frt.frt_value, cpi_5_avg FROM frt_clean_new frt 
JOIN (
SELECT country, obs_year, cpi_value, 
AVG(cpi_value) OVER (partition by country Order by obs_year rows Between 4 Preceding and current row) as cpi_5_avg
from cpi_clean
) cpi on frt.country = cpi.country and frt.obs_year = CAST(cpi.obs_year as integer)
)
SELECT country, CORR(frt_value, cpi_5_avg) as corr_frt_cpi_avg 
from moving_avg_5_year 
group by country order by corr_frt_cpi_avg

--Correlation between LFP and TFR
--(-)0.0084
--P-Value: 0.7627 > (Alpha = 0.01): Not-Significant
SELECT CORR(tfr.Fertility, CAST(lfp.lfp as numeric)) AS Corr_TFR_LFP, Count(*) as sample_size FROM (
	SELECT country, obs_year, frt_value as Fertility FROM frt_clean_new WHERE "Indicator" = 'TFR'
)tfr
JOIN (
	SELECT country, obs_year, lfp_value as lfp FROM lfp_clean where classif1 = 'Age (10-year bands): Total' 
	and classif2 = 'Education (Aggregate levels): Total' and lfp_value <> ''
)lfp on tfr.country = lfp.country and tfr.obs_year = CAST(lfp.obs_year as integer)

--Same but include all education levels
--(-)0.030
--P-Value: 0.2473 > (Alpha = 0.01): Not-Significant
SELECT CORR(tfr.Fertility, lfp.lfp) AS Corr_TFR_LFP, Count(*) as sample_size FROM (
	SELECT country, obs_year, frt_value as Fertility FROM frt_clean_new WHERE "Indicator" = 'TFR'
)tfr
JOIN (
	SELECT country, obs_year, AVG(Cast(lfp_value as numeric)) as lfp FROM lfp_clean where lfp_value <> '' group by country, obs_year
)lfp on tfr.country = lfp.country and tfr.obs_year = CAST(lfp.obs_year as integer)

--Trends from last 0-5 years, 5-10 years, and 10-19 years of data
--Mean
--TFR
WITH tfr as (
	SELECT frt_value, obs_year FROM frt_clean_new WHERE "Indicator" = 'TFR'
)
SELECT AVG(frt_value) from tfr where 2019-obs_year BETWEEN 0 AND 5
UNION ALL
SELECT AVG(frt_value) from tfr where 2019-obs_year BETWEEN 5 AND 10
UNION ALL
SELECT AVG(frt_value) from tfr where 2019-obs_year BETWEEN 10 AND 19

--MAC
WITH mac as (
	SELECT frt_value, obs_year FROM frt_clean_new WHERE "Indicator" = 'MAC'
)
SELECT AVG(frt_value) from mac where 2019-obs_year BETWEEN 0 AND 5
UNION ALL
SELECT AVG(frt_value) from mac where 2019-obs_year BETWEEN 5 AND 10
UNION ALL
SELECT AVG(frt_value) from mac where 2019-obs_year BETWEEN 10 AND 19

--Median
--TFR
WITH tfr as (
	SELECT frt_value, obs_year FROM frt_clean_new WHERE "Indicator" = 'TFR'
)
SELECT percentile_cont(0.5) within group (order by frt_value) from tfr where 2019-obs_year BETWEEN 0 AND 5
UNION ALL
SELECT percentile_cont(0.5) within group (order by frt_value) from tfr where 2019-obs_year BETWEEN 5 AND 10
UNION ALL
SELECT percentile_cont(0.5) within group (order by frt_value) from tfr where 2019-obs_year BETWEEN 10 AND 19

--MAC
WITH mac as (
	SELECT frt_value, obs_year FROM frt_clean_new WHERE "Indicator" = 'MAC'
)
SELECT percentile_cont(0.5) within group (order by frt_value) from mac where 2019-obs_year BETWEEN 0 AND 5
UNION ALL
SELECT percentile_cont(0.5) within group (order by frt_value) from mac where 2019-obs_year BETWEEN 5 AND 10
UNION ALL
SELECT percentile_cont(0.5) within group (order by frt_value) from mac where 2019-obs_year BETWEEN 10 AND 19