-- DATA CLEANING 
CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM layoffs_staging3;

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging3
WHERE row_num > 1;

select * from layoffs_staging3
where row_num >1;

select * from layoffs_staging3;

select distinct company, trim(company)
from layoffs_staging3;

update layoffs_staging3
set company = trim(company);

select distinct industry from layoffs_staging3
order by 1;

select * from layoffs_staging3
where industry like 'Crypto%';

update layoffs_staging3
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country 
from layoffs_staging3
order by 1;

select * 
from layoffs_staging3
where country like "United States%"
order by 1;

update layoffs_staging3
set country = trim(trailing '.' from country)
where country like 'United States%'

select distinct country from layoffs_staging3
where country like 'United States%'

select `date`,
str_to_date(`date`,'%m/%d/%Y') 
from layoffs_staging3


update layoffs_staging3
set `date` = str_to_date(`date`,'%m/%d/%Y') 

select * from layoffs_staging3

alter table layoffs_staging3
modify column `date` date

select * from layoffs_staging3

select company, industry from layoffs_staging3
group by company, industry

select * from layoffs_staging3 t1
join layoffs_staging3 t2
on t1.company = t2.company
where t1.industry is null
and t2.industry is not null

select company, industry from layoffs_staging3
where company = 'Airbnb'

update layoffs_staging3 t1
join layoffs_staging3 t2
on t1.company = t2.company
set t1. industry = t2.industry
where t1.industry is null
and t2.industry is not null

select * from layoffs_staging3
where industry is null

select * from layoffs_staging3
where company = "Bally's Interactive"

delete from layoffs_staging3
where company = "Bally's Interactive"

select * from layoffs_staging3
where total_laid_off is null and 
percentage_laid_off is null

delete from layoffs_staging3
where total_laid_off is null and 
percentage_laid_off is null

select * from layoffs_staging3

select * from layoffs_staging3
where total_laid_off is null and 
funds_raised_millions is null

delete from layoffs_staging3
where total_laid_off is null and 
funds_raised_millions is null

select * from layoffs_staging3
where percentage_laid_off is null and 
funds_raised_millions is null


delete from layoffs_staging3
where percentage_laid_off is null and 
funds_raised_millions is null

select * from layoffs_staging3

alter table layoffs_staging3
drop column row_num

SELECT COUNT(*) FROM layoffs_staging3;























