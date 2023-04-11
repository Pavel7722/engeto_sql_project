/* 
 * 1)
 * Are wages in all industries increasing within years
 * or some are decreasing?
 */

-- avarage wages grouped by industries in years	
CREATE OR REPLACE VIEW v_pavel_zavodny_industry_wages AS
SELECT 
	industry,
	ROUND(AVG(avarage_wages)) AS avarage_wages,
	`year`
FROM  t_pavel_zavodny_project_sql_primary_final AS tpzpspf 
WHERE industry IS NOT NULL 
GROUP BY `year`,
		industry
ORDER BY industry,
		`year` DESC;	
 	
-- comparison of avarage year wages in industries
CREATE OR REPLACE VIEW v_pavel_zavodny_industry_wages_comparison AS
SELECT
	vpziw.industry,
	vpziw.avarage_wages AS avarage_wages,
	vpziw.`year`,
	vpziw2.`year` AS previous_year,
	vpziw2.avarage_wages AS previous_avarage_wages,
	CASE 
		WHEN(vpziw.avarage_wages - vpziw2.avarage_wages) < 0 THEN 'descending'
		ELSE 'ascending'
	END AS wage_comparison
FROM v_pavel_zavodny_industry_wages AS vpziw 
JOIN v_pavel_zavodny_industry_wages AS vpziw2 
	ON vpziw.industry = vpziw2.industry
	AND vpziw.`year` = vpziw2.`year` + 1;

-- descending wages
SELECT *
FROM v_pavel_zavodny_industry_wages_comparison AS vpziwc 
WHERE wage_comparison = 'descending';






