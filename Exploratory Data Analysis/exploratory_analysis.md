### Query
```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;
```
### Output

| **MAX(total_laid_off)** | **MAX(percentage_laid_off)** |
| ----------------------- | ---------------------------- |
| **12000**               | 1.00                         |
### Observations
*The highest number of people laid off was 12,000. The highest percentage laid off was 100% implying that some companies completely went under*

---
### Query
```sql
SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
LIMIT 5;
```
### Output

| **company**             | **location**  | **industry**   | **total_laid_off** | **percentage_laid_off** | **date**   | **stage**      | **country**    | **funds_raised_millions** |
| ----------------------- | ------------- | -------------- | ------------------ | ----------------------- | ---------- | -------------- | -------------- | ------------------------- |
| **Britishvolt**         | London        | Transportation | 206                | 1.00                    | 2023-01-17 | Unknown        | United Kingdom | 2400.00                   |
| **Quibi**               | Los Angeles   | Media          | NULL               | 1.00                    | 2020-10-21 | Private Equity | United States  | 1800.00                   |
| **Deliveroo Australia** | Melbourne     | Food           | 120                | 1.00                    | 2022-11-15 | Post-IPO       | Australia      | 1700.00                   |
| **Katerra**             | SF Bay Area   | Construction   | 2434               | 1.00                    | 2021-06-01 | Unknown        | United States  | 1600.00                   |
| **BlockFi**             | New York City | Crypto         | NULL               | 1.00                    | 2022-11-28 | Series E       | United States  | 1000.00                   |

### Observations
*Britishvolt, Quibi, Deliveroo Australia, Katerra, and BlockFi were among the companies that went completely under as seen by their layoff percentage being 100%. These are also the top 5 companies that recieved the most funding, yet still failed.*

---
### Query
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5;
```
### Output

| **industry**       | **SUM(total_laid_off)** |
| ------------------ | ----------------------- |
| **Consumer**       | 45182                   |
| **Retail**         | 43613                   |
| **Other**          | 36289                   |
| **Transportation** | 33748                   |
| **Finance**        | 28344                   |
### Observations
*Consumer, retail, Other, Transportation, and Finance were among the highest industries that experienced layoffs globally from 2020-2023.*

---
### Query
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 ASC
LIMIT 5;
```
### Output

| **industry**      | **SUM(total_laid_off)** |
| ----------------- | ----------------------- |
| **NULL**          | NULL                    |
| **Manufacturing** | 20                      |
| **Fin-Tech**      | 215                     |
| **Aerospace**     | 661                     |
| **Energy**        | 802                     |
### Observations
*Manufacturing, Fin-Tech, Aerospace, and Energy were the industries that were hit the least by layoffs from 2020-2023.*

---
### Query
```sql
SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;
```
### Output

| **country**       | **SUM(total_laid_off)** |
| ----------------- | ----------------------- |
| **United States** | 256559                  |
| **India**         | 35993                   |
| **Netherlands**   | 17220                   |
| **Sweden**        | 11264                   |
| **Brazil**        | 10391                   |
### Observations
*The United States was the country that had the most layoffs during 2020-2023. *

---
### Query
```sql
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
```
### Output

| **YEAR(`date`)** | **SUM(total_laid_off)** |
| ---------------- | ----------------------- |
| **2023**         | 125677                  |
| **2022**         | 160661                  |
| **2021**         | 15823                   |
| **2020**         | 80998                   |
| **NULL**         | 500                     |
### Observations
*2020 had a huge layoff spike, likely due to the pandemic. Layoffs decreased during 2021, but went back up in 2022-2023. This dataset stops on March 6th, 2023, so the 125677 represents massive layoff count for just the first 3 months compared to the entire year of 2022.*

---
### Query
```sql
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC
LIMIT 5;
```
### Output

| **stage**          | **SUM(total_laid_off)** |
| ------------------ | ----------------------- |
| **Post-IPO**       | 204132                  |
| **Unknown**        | 40716                   |
| **Acquired**       | 27576                   |
| **Series C**       | 20017                   |
| **Series D**       | 19225                   |
### Observations
*The companies with the largest layoffs were the largest companies (i.e. Google, Meta, Amazon) who were Post-IPO.*

---
### Query
```sql
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
```
### Output

| **MONTH**   | **total_laidoff** | **rolling_total** |
| ----------- | ----------------- | ----------------- |
| **2020-03** | 9628              | 9628              |
| **2020-04** | 26710             | 36338             |
| **2020-05** | 25804             | 62142             |
| **2020-06** | 7627              | 69769             |
| **2020-07** | 7112              | 76881             |
| **2020-08** | 1969              | 78850             |
| **2020-09** | 609               | 79459             |
| **2020-10** | 450               | 79909             |
| **2020-11** | 237               | 80146             |
| **2020-12** | 852               | 80998             |
| **2021-01** | 6813              | 87811             |
| **2021-02** | 868               | 88679             |
| **2021-03** | 47                | 88726             |
| **2021-04** | 261               | 88987             |
| **2021-06** | 2434              | 91421             |
| **2021-07** | 80                | 91501             |
| **2021-08** | 1867              | 93368             |
| **2021-09** | 161               | 93529             |
| **2021-10** | 22                | 93551             |
| **2021-11** | 2070              | 95621             |
| **2021-12** | 1200              | 96821             |
| **2022-01** | 510               | 97331             |
| **2022-02** | 3685              | 101016            |
| **2022-03** | 5714              | 106730            |
| **2022-04** | 4128              | 110858            |
| **2022-05** | 12885             | 123743            |
| **2022-06** | 17394             | 141137            |
| **2022-07** | 16223             | 157360            |
| **2022-08** | 13055             | 170415            |
| **2022-09** | 5881              | 176296            |
| **2022-10** | 17406             | 193702            |
| **2022-11** | 53451             | 247153            |
| **2022-12** | 10329             | 257482            |
| **2023-01** | 84714             | 342196            |
| **2023-02** | 36493             | 378689            |
| **2023-03** | 4470              | 383159            |
### Observations
*Here we can see the rolling total layoffs overtime, as well as the total layoffs at each month between March 2020 - March 2023. The last 3 rows for 2023 show how the layoffs spiked drastically in just 3 months, as January saw 84714 in just one month.*

---
### Query
```sql
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
```
### Output

| **company**                           | **years** | **total_laid_off** | **ranking** |
| ------------------------------------- | --------- | ------------------ | ----------- |
| **Uber**                              | 2020      | 7525               | 1           |
| [**Booking.com**](http://Booking.com) | 2020      | 4375               | 2           |
| **Groupon**                           | 2020      | 2800               | 3           |
| **Swiggy**                            | 2020      | 2250               | 4           |
| **Airbnb**                            | 2020      | 1900               | 5           |
| **Bytedance**                         | 2021      | 3600               | 1           |
| **Katerra**                           | 2021      | 2434               | 2           |
| **Zillow**                            | 2021      | 2000               | 3           |
| **Instacart**                         | 2021      | 1877               | 4           |
| **WhiteHat Jr**                       | 2021      | 1800               | 5           |
| **Meta**                              | 2022      | 11000              | 1           |
| **Amazon**                            | 2022      | 10150              | 2           |
| **Cisco**                             | 2022      | 4100               | 3           |
| **Peloton**                           | 2022      | 4084               | 4           |
| **Carvana**                           | 2022      | 4000               | 5           |
| **Philips**                           | 2022      | 4000               | 5           |
| **Google**                            | 2023      | 12000              | 1           |
| **Microsoft**                         | 2023      | 10000              | 2           |
| **Ericsson**                          | 2023      | 8500               | 3           |
| **Amazon**                            | 2023      | 8000               | 4           |
| **Salesforce**                        | 2023      | 8000               | 4           |
| **Dell**                              | 2023      | 6650               | 5           |
### Observations
*These are the companies with the most layoffs by year:
2020 - Uber, Booking.com, Groupon, Swiggy, Airbnb
2021 - Bytedance, Katerra, Zillow, Instacart, WhiteHat Jr
2022 - Meta, Amazon, Cisco, Peloton, Carvana, Philips
2023 - Google, Microsoft, Ericsson, Amazon, Salesforce, Dell*

---
