-- 1: Basic Trends 
-- The Giants: Which 5 companies had the single largest layoff events in the entire dataset?
SELECT company, 
total_laid_off, 
percentage_laid_off,`date`
FROM layoffs_staging3
ORDER BY total_laid_off DESC 
LIMIT 5;

-- Total Damage: What is the total number of people laid off across all companies and countries combined?
SELECT sum(total_laid_off) AS grand_total_layoff
FROM layoffs_staging3;

-- The Industries: Which industry (e.g., Tech, Retail, Finance) has been hit the hardest by layoffs?
SELECT industry, SUM(total_laid_off) AS layoff 
FROM layoffs_staging3 
GROUP BY industry
ORDER BY layoff DESC;

-- Show the yearly trend of layoffs by calculating the total number of people laid off per year.
SELECT YEAR(`date`) AS layoff_year, 
SUM(total_laid_off) AS layoff
FROM  layoffs_staging3
WHERE `date` IS NOT NULL
GROUP BY layoff_year
ORDER BY layoff DESC;

-- Show the monthly rolling total of layoffs across all years.
WITH rolling_cte AS (
SELECT SUBSTRING(`date`,1,7) AS `month` , 
SUM(total_laid_off) AS layoffs
FROM layoffs_staging3
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC)
SELECT `month`, layoffs,
SUM(layoffs) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_cte;

-- The Locations: Which cities or "Locations" recorded the highest number of layoffs?
SELECT location, 
SUM(total_laid_off) AS layoffs
FROM layoffs_staging3
GROUP BY location
ORDER BY 2 DESC;


-- 2: Time & Progress 
-- Yearly Breakdown: How many people were laid off each year? (2020 vs 2021 vs 2022 vs 2023).
WITH yearly_layoffs AS (
SELECT YEAR(`date`) AS 	`year`, 
SUM(total_laid_off) AS layoffs
FROM layoffs_staging3
GROUP BY `year`)
SELECT `year`, layoffs
FROM yearly_layoffs
WHERE `year` IS NOT NULL
ORDER BY 1 ASC;


-- The Peak Month: In which specific month and year did the global layoffs reach their absolute peak?
SELECT SUBSTRING(`date`,1,7) AS `month`, 
SUM(total_laid_off) AS layoffs
FROM layoffs_staging3
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY layoffs DESC
LIMIT 1;

-- Rolling Total: Can you show the "Rolling Total" of layoffs month-by-month to see the trend growing over time?
WITH rolling_cte AS (
SELECT SUBSTRING(`date`,1,7) AS `month` , 
SUM(total_laid_off) AS layoffs
FROM layoffs_staging3
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC)
SELECT `month`, 
layoffs,
SUM(layoffs) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_cte;


--  3: Deep Insights 
-- The Shutdowns: Which companies went completely out of business (percentage_laid_off = 1) and 
-- how much total funding did they burn through before closing?
SELECT company, 
location, 
industry, 
funds_raised_millions
FROM  layoffs_staging3
WHERE percentage_laid_off = 1 
AND percentage_laid_off IS NOT NULL
ORDER BY 4 DESC;

-- Funding vs. Layoffs: Is there a correlation between the amount of funds raised and the number of layoffs?
-- (Do "richer" companies lay off more people?)
SELECT company, industry, 
total_laid_off, 
funds_raised_millions
FROM layoffs_staging3 
WHERE total_laid_off IS NOT NULL 
AND funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC;

-- The Stages: Which company "Stage" (e.g., Post-IPO, Series B, Seed) is the most vulnerable to layoffs?
SELECT  stage, 
sum(total_laid_off) AS layoffs
FROM layoffs_staging3
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY layoffs DESC;

SELECT stage, 
       SUM(total_laid_off) AS total_layoffs, 
       COUNT(company) AS num_of_companies,
       ROUND(AVG(total_laid_off)) AS avg_layoffs
FROM layoffs_staging3
WHERE stage IS NOT NULL AND stage <> 'Unknown'
GROUP BY stage
ORDER BY total_layoffs DESC;



select count(*)
from layoffs_staging3
