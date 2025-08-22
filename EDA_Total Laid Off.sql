-- MENCARI INDUSTRY JUMLAH PHK
SELECT industry, SUM(total_laid_off) AS SUM_PHK
FROM layoffs3
GROUP BY industry
ORDER BY SUM_PHK DESC;

-- MENCARI JUMLAH PHK BY COUNTRY
SELECT country, SUM(total_laid_off)
FROM layoffs3
GROUP BY country
ORDER BY 2 DESC;

-- MENCARI JUMLAH PHK BY YEAR
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs3
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(percentage_laid_off)
FROM layoffs3
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- MENCARU Jumlah PHK BY MONTH
SELECT SUBSTRING(`date`, 6, 2) AS `Month`, SUM(total_laid_off) AS `Jumlah_PHK`
FROM layoffs3
GROUP BY `Month`
ORDER BY 2 DESC
;

WITH month_cte AS
(
SELECT SUBSTRING(`date`, 6, 2) AS `Month`, SUM(total_laid_off) AS `Jumlah_PHK`
FROM layoffs3
GROUP BY `Month`
ORDER BY 2 DESC
)
SELECT *
FROM month_cte
WHERE `Month` IS NOT NULL
;

-- MENCARI JUMLAH PHK BY YEAR AND MONTH
SELECT SUBSTRING(`date`, 1, 7) AS `WAKTU`, SUM(total_laid_off) AS Jumlah_PHK
FROM layoffs3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `WAKTU`
ORDER BY 1 DESC
;

WITH total_PHK AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `WAKTU`, SUM(total_laid_off) AS Jumlah_PHK
FROM layoffs3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `WAKTU`
ORDER BY 1 ASC
)
SELECT `WAKTU`, SUM(Jumlah_PHK) OVER(ORDER BY `WAKTU`) AS total, Jumlah_PHK
FROM total_PHK
;

-- RANKING 5 COMPANY WITH JUMLAH PHK TERTINGGI PERTAHUN
SELECT company, YEAR(`date`) , SUM(total_laid_off) AS Jumlah_PHK
FROM layoffs3
GROUP BY company, YEAR(`date`)
;

WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS Years, SUM(total_laid_off) AS Jumlah_PHK
FROM layoffs3
GROUP BY company, YEAR(`date`)
),
RANK_COMPANY AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY Jumlah_PHK DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL 
AND Jumlah_PHK IS NOT NULL
)
SELECT *
FROM RANK_COMPANY
WHERE Ranking <=5
;

SELECT company, SUM(total_laid_off) AS JUMLAH_PHK
FROM layoffs3
GROUP BY company
ORDER BY JUMLAH_PHK DESC;