-- REMOVE ANY COLUMNS

SELECT * -- There are 361 columns with null layoff data, these are not helpful as they don't give us any info regarding the layoffs
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROm layoffs_staging3;

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;