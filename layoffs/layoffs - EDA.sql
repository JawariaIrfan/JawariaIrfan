select*
from layoff_staging2;


select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off = 1
order by total_laid_off desc;


select *
from layoff_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoff_staging2
group by company
order by sum(total_laid_off) desc;

select min(`date`), max(`date`)
from layoff_staging2;

select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by sum(total_laid_off) desc;

select country, sum(total_laid_off)
from layoff_staging2
group by country
order by sum(total_laid_off) desc;

select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by sum(total_laid_off) desc;

select month(`date`), sum(total_laid_off) as `month`
from layoff_staging2
group by month(`date`);

select substring(`date`,1,7) as `year-month`, sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by substring(`date`,1,7) asc;

with rolling_total as
(
select substring(`date`,1,7) as `year-month`, sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by substring(`date`,1,7) asc
)

select `year-month`, total_off, sum(total_off) over(order by `year-month`) as rolling_total
from rolling_total;

select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
order by sum(total_laid_off) desc;


with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
), company_year_rank as (
select*,
dense_rank() over(partition by years order by total_laid_off DESC) as ranking
from company_year
where years is not null )
select*
from company_year_rank
where ranking <=5;
