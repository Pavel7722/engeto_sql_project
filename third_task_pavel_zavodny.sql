/*
 * 3) Which category of grocery is increasing slowestly
 * (its lowest percentage interannual increment)?
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

-- percentage interannual differences of avarage grocery prices
CREATE OR REPLACE VIEW v_pavel_zavodny_grocery_prices_perc_diff AS
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
	vpzgp.`year` = vpzgp2.`year` + 1;

-- slowestly increasing prices in grocery categories
CREATE OR REPLACE VIEW v_pavel_zavodny_avarage_grocery_prices_perc_diff AS
SELECT 
	food_category,
	ROUND(AVG(percentage_difference), 2) AS avarage_percentage_difference 
FROM v_pavel_zavodny_grocery_prices_perc_diff AS vpzgppd
GROUP BY food_category
ORDER BY avarage_percentage_difference ASC
LIMIT 1;