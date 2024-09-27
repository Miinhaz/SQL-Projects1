
# SQL Data Cleaning & Exploratory Data Analysis (EDA)

This project focuses on applying SQL for data cleaning and exploratory data analysis (EDA) on a dataset related to company layoffs. The process involves cleaning the data to ensure accuracy and consistency, followed by analyzing the dataset to uncover trends and generate meaningful insights.

## Project Overview

The goal of this project is twofold:
1. **Data Cleaning**: Ensure the dataset is free from duplicates, null values, and inconsistencies.
2. **Exploratory Data Analysis**: Explore trends, patterns, and relationships within the data to draw actionable insights.

---

## Data Cleaning Process

### 1. **Removing Duplicates**  
   Utilized the `ROW_NUMBER()` function along with `PARTITION BY` to detect and remove duplicate records across multiple columns.
   ```sql
   WITH duplicate_cte AS (
       SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
       ) AS row_num
       FROM staging
   )
   DELETE FROM duplicate_cte WHERE row_num > 1;
   ```

### 2. **Standardizing Data**  
   - **Company Names**: Trimmed whitespace for cleaner data.
     ```sql
     UPDATE staging2 SET company = TRIM(company);
     ```
   - **Industry and Country**: Standardized industry names and removed trailing periods from country names.
     ```sql
     UPDATE staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
     UPDATE staging2 SET country = TRIM(TRAILING '.' FROM country) WHERE country LIKE 'United States%';
     ```

### 3. **Converting Date Formats**  
   Converted the date from text format to a uniform `DATE` format using `STR_TO_DATE()`.
   ```sql
   UPDATE staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
   ALTER TABLE staging2 MODIFY COLUMN date DATE;
   ```

### 4. **Handling Null and Blank Values**  
   Addressed null and blank values in key columns, especially for `industry` and `total_laid_off`.
   ```sql
   UPDATE staging2 SET industry = NULL WHERE industry = '';
   DELETE FROM staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
   ```

---

## Exploratory Data Analysis (EDA)

### 1. **Top Layoffs by Company and Country**  
   Grouped data by company and country to find the highest layoffs and their impact.
   ```sql
   SELECT company, SUM(total_laid_off) FROM staging2 GROUP BY company ORDER BY 2 DESC;
   SELECT country, SUM(total_laid_off) FROM staging2 GROUP BY country ORDER BY 2 DESC;
   ```

### 2. **Yearly Trends in Layoffs**  
   Analyzed layoffs by year to detect the highest layoff periods.
   ```sql
   SELECT YEAR(date), SUM(total_laid_off) FROM staging2 GROUP BY YEAR(date) ORDER BY 2 DESC;
   ```

### 3. **Layoffs by Company Stage**  
   Explored how different stages of company funding relate to layoffs.
   ```sql
   SELECT stage, SUM(total_laid_off) FROM staging2 GROUP BY stage ORDER BY 2 DESC;
   ```

### 4. **Rolling Total of Layoffs Over Time**  
   Calculated a rolling total of layoffs by month to detect increasing or decreasing trends.
   ```sql
   WITH ROLLING_TOTAL AS (
       SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_off
       FROM staging2 WHERE SUBSTRING(date, 1, 7) IS NOT NULL
       GROUP BY month
   )
   SELECT month, total_off, SUM(total_off) OVER (ORDER BY month) AS rolling_total FROM ROLLING_TOTAL;
   ```

---

## Insights Gained

1. **Layoff Trends by Industry & Company**:  
   - Identified the companies and industries most impacted by layoffs.
   - Certain companies had exceptionally high layoff numbers, with specific industries such as tech and crypto standing out.

2. **Country Impact Analysis**:  
   - The United States and other economically large countries led in the number of layoffs.
   
3. **Yearly Layoff Analysis**:  
   - There were significant layoffs during economic downturns, revealing clear temporal trends.

4. **Funding Stage Analysis**:  
   - Companies in specific funding stages experienced higher percentages of layoffs, showing a correlation between funding and employee reductions.

5. **Rolling Total**:  
   - The rolling total analysis uncovered periods of accelerating layoffs, which might align with global economic events.

---

## Key SQL Techniques Used
- **Window Functions**: `ROW_NUMBER()` for identifying duplicates.
- **String Functions**: `TRIM()`, `STR_TO_DATE()` for cleaning and formatting data.
- **Date Functions**: `YEAR()`, `SUBSTRING()` for analyzing time-based trends.
- **Aggregate Functions**: `SUM()`, `GROUP BY` for summarizing the data.
- **CTE**: Used for creating rolling totals and cleaner query structures.

