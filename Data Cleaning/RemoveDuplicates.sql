-- REMOVE DUPLICATES

-- Create staging table to prevent modifying original data 
CREATE TABLE layoffs_staging
LIKE layoffs;
INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- CTE to create row_nums to identify duplicates
WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Second staging table to delete duplicate rows (can't delete from CTEs)
CREATE TABLE `layoffs_staging2` (
  `company` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` decimal(5,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `stage` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `funds_raised_millions` decimal(10,2) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Delete the row_num 2 rows (these are the duplicate rows)
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

