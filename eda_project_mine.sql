-- exploratory data analysis

select *
from staging2;

select MAX(total_laid_off), max(percentage_laid_off)
from staging2;


select *
from staging2
where percentage_laid_off =1
order by total_laid_off desc;



select company, SUM(total_laid_off)
from staging2
group by company
order by 2 desc;


select country, SUM(total_laid_off)
from staging2
group by country
order by 2 desc;


select year(`date`), SUM(total_laid_off)
from staging2
group by year(`date`)
order by 2 desc;



select stage, SUM(total_laid_off)
from staging2
group by stage
order by 2 desc;


select company, SUM(percentage_laid_off)
from staging2
group by company
order by 2 desc;


-- rolling total layoff

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from staging2
where substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 asc;


WITH ROLING_TOTAL AS
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from staging2
where substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 asc
)
SELECT `month`, total_off,  sum(total_off) over(order by `month`) as rolling_total
from ROLING_TOTAL;



