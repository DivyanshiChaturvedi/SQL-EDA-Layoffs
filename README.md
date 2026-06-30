# Layoffs Dataset — Exploratory Data Analysis (SQL)

## Overview
Exploratory Data Analysis on the cleaned global tech layoffs dataset using advanced SQL — window functions, CTEs, rolling totals, and ranking logic to uncover trends in tech layoffs from 2020–2023.

This project builds on the cleaned dataset from [SQL-Data-Cleaning-Layoffs](https://github.com/DivyanshiChaturvedi/SQL-Data-Cleaning-Layoffs).

---

## Business Questions Answered

1. What is the date range covered by this dataset?
2. How many people were laid off each year?
3. What is the month-over-month layoff trend?
4. What is the cumulative (rolling) total of layoffs over time?
5. Which companies had the highest layoffs each year?
6. What are the top 5 companies by layoffs, per year?

---

## Key Findings
- Identified the full timeline of the dataset using MIN/MAX date functions
- Calculated year-over-year total layoffs to spot macro trends
- Built a month-by-month rolling total to visualize cumulative impact over time
- Ranked companies within each year using DENSE_RANK() to surface the top 5 biggest layoffs annually — avoiding skipped ranks for tied values

---

## Key SQL Concepts Used
- **Window Functions** — SUM() OVER(), DENSE_RANK() OVER(PARTITION BY...)
- **CTEs (Common Table Expressions)** — including multi-step chained CTEs
- **Rolling/Cumulative Totals** — running sum ordered by month
- **SUBSTRING()** — extracting year-month from date for grouping
- **Nested Aggregation** — grouping by company and year simultaneously
- **Filtering Ranked Results** — using CTE output to filter top-N per group

---

## Sample Query — Top 5 Companies by Layoffs Per Year
```sql
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
SELECT * FROM companyyear_rank WHERE ranking <= 5;
```

---

## Tools Used
- MySQL 8.0
- MySQL Workbench

---

## Files
- `eda_layoffs.sql` — Full exploratory analysis script

## Related Project
- [SQL-Data-Cleaning-Layoffs](https://github.com/DivyanshiChaturvedi/SQL-Data-Cleaning-Layoffs) — Data cleaning performed before this analysis
