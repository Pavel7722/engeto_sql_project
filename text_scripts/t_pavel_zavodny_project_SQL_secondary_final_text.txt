-- secondary table of data regarding states in years 
CREATE OR REPLACE TABLE t_pavel_zavodny_project_SQL_secondary_final
SELECT 
	country,
	`year`,
	GDP,
	gini,
	population 
FROM economies AS e
WHERE `year` BETWEEN 2006 AND 2018 AND 
	gini IS NOT NULL
ORDER BY country ASC,
		`year` DESC;

	
	