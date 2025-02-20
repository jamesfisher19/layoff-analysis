-- STANDARDIZE DATA

SELECT * 
FROM layoffs_staging2;

-- Standardize company
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 -- Seet all Crypto-related industries to just 'Crypto'
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize country
SELECT DISTINCT country, TRIM(TRAILING  '.'  FROM country) -- Trim the '.' from 'United States.'
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 -- Seet all Crypto-related industries to just 'Crypto'
SET country = TRIM(TRAILING  '.'  FROM country)
WHERE country LIKE 'United States%';

-- Standardize `date`
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Blank/NULL values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


UPDATE layoffs_staging3 -- ****NOTE: Had to create new staged table due to accidental duplication. now using layoffs_staging3
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging3 t1 -- Replace NULL industry values with their respective industries
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;