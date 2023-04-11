/*
 * 5) Does a level of GDP have any impact to changes 
 * in wages and grocery prices?
 * Particularly if GDP increases significantly in one year 
 * will there be a noticeable incremet of grocery prices or wages 
 * regarding the same or following year?  
 */

-- czech percentage interannual differences in years
CREATE OR REPLACE VIEW v_pavel_zavodny_cz_gdp_diffs AS
WITH gdp_in_years AS(
SELECT 
	`year`,
	GDP
FROM t_pavel_zavodny_project_sql_secondary_final AS tpzpssf
WHERE country = 'Czech Republic'
)
SELECT
	giy.`year`,
	giy.GDP,
	giy2.`year` AS previous_year,
	giy2.GDP AS previous_GDP,
	ROUND(((giy.GDP - giy2.GDP) / giy2.GDP * 100), 1) AS percentage_diff
FROM gdp_in_years AS giy
JOIN gdp_in_years AS giy2
	ON giy.`year` = giy2.`year` + 1;

-- percentage difference comparison of czech gdp vs grocery vs wages 
CREATE OR REPLACE VIEW v_pavel_zavodny_cz_gdp_vs_grocery_and_wages AS
SELECT
	'Czech Republic' AS `country`,
	vpzcgd.`year`,
	vpzcgd.percentage_diff AS gdp_percentage_diffs,
	vpzpvw.avg_grocery_price_perc_diffs,
	vpzpvw.avg_wages_perc_diffs 
FROM v_pavel_zavodny_cz_gdp_diffs AS vpzcgd
JOIN v_pavel_zavodny_prices_vs_wages AS vpzpvw
	ON vpzcgd.`year` = vpzpvw.`year`;