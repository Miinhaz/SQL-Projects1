select *
from layoffs;

-- remove duplicates

create table staging
like layoffs;

insert staging
select *
from layoffs;

select *
FROM  staging;

select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM  staging;



with duplicate_cte as (
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM  staging
)
select *
from duplicate_cte
where row_num > 1
;

select*
from staging
where company = 'casper';



with duplicate_cte as (
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM  staging
)
Delete
from duplicate_cte
where row_num > 1
;



CREATE TABLE `staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from staging2
where row_num > 1;

insert into staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM  staging;



DELETE
from staging2
where row_num > 1;

select *
from staging2
where row_num > 1;


select *
from staging2;


select *
from staging2 
where company = 'Airbnb';




----- standardizing



select company , trim(company)
from staging2;


update staging2
set company = trim(company);


select distinct industry
from staging2
order by 1;


select *
from staging2
where industry like 'Crypto%'
;

update staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct industry
from staging2
order by 1;

select distinct country , trim(trailing '.' from country)
from staging2
order by 1;


update staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;


select *
from staging2 
where company = 'Airbnb';


select `date`
from staging2;


select `date`,
str_to_date(`date`,'%m/%d/%Y') as new_date
from staging2;


update staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');


alter table staging2
modify column `date` DATE;


select *
FROM staging2;



select *
from staging2 
where company = 'Airbnb';



-- nulls and blank

select *
from staging2 
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;
 
 select *
from staging2 
where company = 'Airbnb';
 
select * 
from staging2
where industry IS NULL
OR industry = '';

update  staging2
set industry = NULL
 where industry = '';

select *
from staging2
where company = 'Airbnb';


select t1.industry, t2.industry
from staging2 t1
join staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2. location
where (t1.industry IS NULL or t1.industry= '')
AND t2.industry IS NOT NULL;


update staging2 t1
join staging2 t2
	ON t1.company = t2.company
set t1.industry = t2.industry
where t1.industry IS NULL 
AND t2.industry IS NOT NULL;

select *
from staging2
where company = 'Airbnb';


select *
from staging2;


-- getting rid of column and rows


select *
from staging2 
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
from staging2 
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;



SELECT *
FROM staging2;

alter table staging2
drop column row_num;


SELECT *
FROM staging2;

