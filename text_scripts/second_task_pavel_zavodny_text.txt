/* 
 * 2) How many liters of milk and kilograms of bread is possible to buy
 *  for prices and wages regarding available data
 *  in the first and last comparable years?
 */

-- prices of bread and milk in 2006 and 2018
CREATE OR REPLACE VIEW v_pavel_zavodny_prices AS
SELECT 
	food_category, 
	ROUND(AVG(prices) , 2) AS avarage_price,
	`year`
FROM t_pavel_zavodny_project_sql_primary_final AS tpzpspf 
WHERE food_category IN ('Mléko polotučné pasterované' , 
	'Chléb konzumní kmínový') AND 
	`year` IN ('2006' , '2018')
GROUP BY `year`,
	food_category
ORDER BY food_category,
	`year` DESC;

-- avarage wages in years
CREATE OR REPLACE VIEW v_pavel_zavodny_wages AS
SELECT 
	`year`,
	ROUND(AVG(avarage_wages)) AS avarage_wages
FROM t_pavel_zavodny_project_sql_primary_final AS tpzpspf 
GROUP BY `year`
ORDER BY `year` DESC;

-- amount calculation of grocery bought in 2006 and 2018
SELECT 
	vpzp.food_category,
	vpzp.avarage_price,
	vpzp.`year`,
	vpzw.avarage_wages,
	ROUND((vpzw.avarage_wages / vpzp.avarage_price)) AS quantity
FROM v_pavel_zavodny_prices AS vpzp 
JOIN v_pavel_zavodny_wages AS vpzw 
	ON vpzp.`year` = vpzw.`year`; 