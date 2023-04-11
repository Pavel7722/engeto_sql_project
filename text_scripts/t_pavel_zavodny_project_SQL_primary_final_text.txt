-- primary table with czechia payrolls and grocery prices in years  
CREATE OR REPLACE TABLE t_pavel_zavodny_project_SQL_primary_final AS
SELECT 
	cpc.name AS 'food_category',
	cp.value AS 'prices',
	YEAR(cp.date_from) AS 'year',
	cpib.name AS 'industry',
	cpay.value AS 'avarage_wages'
FROM czechia_price AS cp 
JOIN czechia_payroll AS cpay 
	ON YEAR(cp.date_from) = cpay.payroll_year AND 
	cpay.value_type_code = '5958' AND 
	cp.region_code IS NULL
JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cpay.industry_branch_code  = cpib.code;










