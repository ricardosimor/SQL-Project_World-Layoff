CREATE TABLE layoffs2
LIKE layoffs;

SELECT *
FROM layoffs2;

INSERT layoffs2
SELECT *
FROM layoffs;

-- REMOVE DUPLICATE DATA
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2;

WITH dup_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2
)
SELECT *
FROM dup_cte
WHERE row_num > 1; 

SELECT *
FROM layoffs2
WHERE company = 'Yahoo';

CREATE TABLE `layoffs3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs3;

INSERT INTO layoffs3
SELECT *, 
ROW_NUMBER () OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs2;

DELETE
FROM layoffs3
WHERE row_num > 1;
 
SELECT *
FROM layoffs3
WHERE row_num > 1;

-- STANDARDIZED DATA
SELECT company, TRIM(company)
FROM layoffs3;

UPDATE layoffs3
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs3
ORDER BY 1;

SELECT *
FROM layoffs3
WHERE industry LIKE "Crypto%";

UPDATE layoffs3
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

SELECT DISTINCT country
FROM layoffs3
ORDER BY 1;

SELECT *
FROM layoffs3
WHERE country LIKE "United States.";

UPDATE layoffs3
SET country = "United States"
WHERE country LIKE "United States.";


-- CHANGE DATA TYPE date FROM TEXT to DATETIME
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') 
FROM layoffs3;
 
UPDATE layoffs3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE layoffs3
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs3
WHERE industry IS NULL OR industry = '';
UPDATE layoffs3
SET industry = NULL
WHERE industry = '';

SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs3 t1
JOIN layoffs3 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
UPDATE layoffs3 t1
JOIN layoffs3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs3
DROP `row_num`;

SELECT *
FROM layoffs3;