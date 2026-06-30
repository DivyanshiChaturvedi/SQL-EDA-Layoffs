-- ============================================================
-- LAYOFFS DATASET - EXPLORATORY DATA ANALYSIS
-- Author: Divyanshi Chaturvedi
-- Tool: MySQL 8.0
-- Built on cleaned dataset from SQL-Data-Cleaning-Layoffs project
-- ============================================================

SELECT * FROM layoff_duplicate2;

-- ============================================================
-- Q1: What date range does this dataset cover?
-- ============================================================
SELECT MAX(`date`), MIN(`date`)
FROM layoff_duplicate2;

-- ============================================================
-- Q2: How many people were laid off each year?
-- ============================================================
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_duplicate2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- ============================================================
-- Q3: What is the month-over-month layoff trend?
-- ============================================================
-- Note: includes year in the month string so Jan 2020 and Jan 2021 don't merge
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoff_duplicate2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;

-- ============================================================
-- Q4: What is the rolling (cumulative) total of layoffs over time?
-- ============================================================
WITH rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off
    FROM layoff_duplicate2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month`
    ORDER BY 1 ASC
)
SELECT `month`, total_off,
    SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_total;

-- ============================================================
-- Q5: How much did each company lay off, per year?
-- ============================================================
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_duplicate2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

-- ============================================================
-- Q6: Top 5 companies by layoffs, per year (ranked)
-- ============================================================
WITH company_years (company, years, laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoff_duplicate2
    GROUP BY company, YEAR(`date`)
),
companyyear_rank AS (
    SELECT *,
        DENSE_RANK() OVER(PARTITION BY years ORDER BY laid_off DESC) AS ranking
    FROM company_years
    WHERE years IS NOT NULL
)
SELECT *
FROM companyyear_rank
WHERE ranking <= 5;
