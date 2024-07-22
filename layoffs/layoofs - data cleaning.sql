SET SQL_SAFE_UPDATES = 0;

--- data cleaning
select*
from layoffs;

### --removing the duplicates
### ---standardizing the data
### ---removing any columns 

create table layoff_staging
like layoffs;

select*
from layoff_staging;

insert layoff_staging
select*
from layoffs;

select*
from layoff_staging;

with cte_duplicates as
(
select*,
row_number() OVER(
partition by COMPANY,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoff_staging
)

select*
from cte_duplicates
where row_num > 1;

show create table layoff_staging;

CREATE TABLE `layoff_staging2` (
   `company` text,
   `location` text,
   `industry` text,
   `total_laid_off` int DEFAULT NULL,
   `percentage_laid_off` text,
   `date` text,
   `stage` text,
   `country` text,
   `funds_raised_millions` int DEFAULT NULL,
    `row_num` int
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
 
 select *
 from layoff_staging2;

insert into layoff_staging2
select*,
row_number() OVER(
partition by COMPANY,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoff_staging;

delete
FROM layoff_staging2
WHERE row_num > 1;


### --- STANDARDIZING THE DATA

SELECT Company, trim(Company)
FROM layoff_staging2;

update layoff_staging2
set company = trim(company);

select*
from layoff_staging2;

select distinct(industry)
from layoff_staging2;

select distinct(industry)
from layoff_staging2
where industry like 'Crypto%';

update layoff_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct(industry)
from layoff_staging2
where industry like 'Crypto%';

update layoff_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


update layoff_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoff_staging2
modify column  `date` date;

select*
from layoff_staging2;

### ---dealing null values

update layoff_staging2
set industry = null
where industry = '';

select *
from layoff_staging2
where industry is null ;

select t1.industry, t2.industry
from layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company
where t1.industry is null and t2.industry is not null;


update layoff_staging2 t1
join layoff_staging t2
	on t1.company = t2.company
set t1.industry = t2.industry 
where t1.industry is null and t2.industry is not null;

select*
from layoff_staging2
where industry is null;

delete
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

select*
from layoff_staging2;

alter table layoff_staging2
drop column row_num;

select*
from layoff_staging2;



