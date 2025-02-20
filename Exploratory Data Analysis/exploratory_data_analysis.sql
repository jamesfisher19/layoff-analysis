-- Max Layoffs & Percentage
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;


-- 100% Layoff Records (Top 5 by Funding)
SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
LIMIT 5;


-- Sum of Layoffs by Industry (Top 5)
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5;


-- Sum of Layoffs by Industry (Lowest 5)
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 ASC
LIMIT 5;


-- Sum of Layoffs by Country (Top 5)
SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;


-- Yearly Layoff Totals
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- Layoffs by Company Stage (Top 5)
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC
LIMIT 5;


-- Monthly Rolling Total
WITH Rolling_Total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `MONTH`, 
        SUM(total_laid_off) AS total_laidoff
    FROM layoffs_staging3
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
)
SELECT 
    `MONTH`, 
    total_laidoff,
    SUM(total_laidoff) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- Top 5 Companies by Year
WITH company_year_CTE (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging3
    GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM company_year_CTE
    WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;