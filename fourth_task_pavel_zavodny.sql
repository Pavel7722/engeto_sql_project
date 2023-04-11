/*
 * 4) Is there a year in which an interannual increment of grocery prices
 *  was significantly greater than an increment of wages
 * (greater than 10%)?
 */

-- avarage grocery prices in years
CREATE OR REPLACE VIEW v_pavel_zavodny_grocery_prices AS
SELECT 
	food_category,
	ROUND(AVG(prices), 2) AS avarage_grocery_prices,
	`year` 
FROM t_pavel_zavodny_project_sql_primary_final AS tpzpspf 
GROUP BY food_category,
	`year` DESC;

-- percentage interannual differences of avarage grocery prices in years
CREATE OR REPLACE VIEW v_pavel_zavodny_avg_grocery_price_perc_diff AS
WITH grocery_prices_in_years AS (
SELECT 
	vpzgp.food_category,
	vpzgp.avarage_grocery_prices,
	vpzgp.`year`,
	vpzgp2.`year` AS previous_year,
	vpzgp2.avarage_grocery_prices AS avarage_previous_grocery_prices,
	ROUND(((vpzgp.avarage_grocery_prices - vpzgp2.avarage_grocery_prices) / 
	vpzgp2.avarage_grocery_prices * 100) , 1) AS percentage_difference 
FROM v_pavel_zavodny_grocery_prices AS vpzgp
JOIN v_pavel_zavodny_grocery_prices AS vpzgp2 
	ON vpzgp.food_category = vpzgp2.food_category AND 
	vpzgp.`year` = vpzgp2.`year` + 1
)
SELECT 
	`year`,
	ROUND(AVG(`percentage_difference`) , 1) AS avg_grocery_price_perc_diffs 
FROM grocery_prices_in_years 	
GROUP BY `year` DESC;

-- percentage interannual differences of avarage wages in years 
CREATE OR REPLACE VIEW v_pavel_zavodny_avg_wages_perc_diffs AS
WITH wages_in_years AS(
SELECT 
	`year`,
	ROUND(AVG(avarage_wages)) AS avarage_wages
FROM t_pavel_zavodny_project_sql_primary_final AS tpzpspf 
GROUP BY `year`
ORDER BY `year` DESC
)
SELECT
	wiy.`year`,
	wiy.avarage_wages,
	wiy2.`year` AS previous_year, 
	wiy2.avarage_wages AS previous_avarage_wages,
	ROUND(((wiy.avarage_wages-wiy2.avarage_wages)/wiy2.avarage_wages * 100),1) 
	AS percentage_difference 
FROM wages_in_years AS wiy
JOIN wages_in_years AS wiy2
	ON wiy.`year` = wiy2.`year` + 1;

-- percentage differences of price and wage incremens in years 
CREATE OR REPLACE VIEW v_pavel_zavodny_prices_vs_wages AS
SELECT 
	vpzagppd.`year`,
	vpzagppd.avg_grocery_price_perc_diffs,
	vpzawpd.percentage_difference AS avg_wages_perc_diffs,
	(vpzagppd.avg_grocery_price_perc_diffs - vpzawpd.percentage_difference) 
	AS percentage_comparison
FROM v_pavel_zavodny_avg_grocery_price_perc_diff AS vpzagppd
JOIN v_pavel_zavodny_avg_wages_perc_diffs AS vpzawpd 
	ON vpzagppd.`year` = vpzawpd.`year`;