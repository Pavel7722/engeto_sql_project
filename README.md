# engeto_sql_project
Engeto data analysis of Czechia grocery prices and payrolls in years 


Průvodní listina


Popis projektu:
výzkum dostupnosti základních potravin široké veřejnosti v ČR na základě průměrných příjmů za určité časové období a vliv výše HDP.

Výzkumné otázky:
1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách      potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Použité datové sady

Primární tabulky:
czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.
czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

Číselníky sdílených informací o ČR:
czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.
czechia_district – Číselník okresů České republiky dle normy LAU.

Dodatečné tabulky:
countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.


Výstup projektu

Primární tabulka s názvem 't_pavel_zavodny_project_SQL_primary_final' byla vytvořena seskupením dat z tabulek 'czechia_price' a 'czechia_payroll'. Provázání dat bylo provedeno pomocí sloupců s hodnotami datumů na společné roky. Zároveň byly z tabulky 'czechia_price' vyřazeny záznamy ve sloupci s kódem krajů s hodnotami NULL, které vykazovaly průměry hodnot všech krajů za jednotlivé měsíce. Z tabulky 'czechia_payroll' byly vybrány pouze záznamy s hodnotou 'Průměrná hrubá mzda na zaměstnance'. Pro konkretizaci označení jmén komodit a průmyslových odvětví byly ještě připojeny tabulky 'czechia_price_category' a 'czechia_payroll_industry_branch'. Výsledná tabulka obsahuje data shromážděná ve sloupcích s kategoriemi potravin, jejich cenami, roky a druhy průmyslových odvětví s průměrnými mzdami. 

Sekundární tabulka s názvem 't_pavel_zavodny_project_SQL_secondary_final' byla vytvořena z tabulky 'economies'. Byly vybrány pouze záznamy v letech 2006 až 2018, tak aby se shodovaly s roky primárního přehledu pro ČR. Vyselektovány byly NULL hodnoty ve sloupci gini koeficientů, které jsou pro větší územní celky, nikoliv samostatné státy. Výsledná tabulka obsahuje data shromážděná ve sloupcích se jmény států, let, HDP, gini koeficientů a velikostí populace.

1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Z primární tabulky byl vytvořen pohled 'v_pavel_zavodny_industry_wages' pro definování průměrných mezd rozdělených na jednotlivé roky v průmyslových odvětvích a vyřazeny záznamy mezd bez definovaného odvětví. Za pomoci prvního pohledu byl vytvořen druhý pohled 'v_pavel_zavodny_industry_wages_comparison', který srovnává meziroční rozdíly mezd.  

Zjištění: V průběhu zkoumaných let docházelo v některých odvětvích i k poklesu mezd.

2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Z primární tabulky byl vytvořen pohled 'v_pavel_zavodny_prices' pro získání dat o průmerných cenách v letech 2006 a 2018 a druhý pohled 'v_pavel_zavodny_wages' pro získání dat o průmerných mzdách v letech. Třetím pohledem 'v_pavel_zavodny_bread_and_milk_vs_wages' byly získány data o průměrných cenách mléka a chlebu v letech 2006 a 2018 spolu s průměrnými mzdami ve stejných letch po spojení dvou předchozích pohledů.
 
Zjištění: V roce 2006 bylo možné zakoupit 1.283 kg chleba a 1.340 kg v roce 2018. V roce 2006 bylo možné zakoupit 1.432 litrů mléka a 1.639 litrů v roce 2018.

3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Z primární tabulky byl vytvořen pohled 'v_pavel_zavodny_grocery_prices' pro získání průměrných cen jednotlivých potravin v letech. Druhým pohledem 'v_pavel_zavodny_grocery_prices_perc_diff' byly získány procentuální meziroční rozdíly u jednotlivých potravin. Třetí pohled 'v_pavel_zavodny_avarage_grocery_prices_perc_diff' průměruje procentuální meziroční nárůst/pokles u jednotlivých kategorií za měřené roky a filtruje nejnižší hodnotu.

Zjištění: Nejpomalejší tempo zdražování v případě komodit je u krystalového cukru.

4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Z primární tabulky byl vytvořen pohled 'v_pavel_zavodny_grocery_prices' s průměrnými cenami jednotlivých potravin v letech. Druhým pohledem 'v_pavel_zavodny_avg_grocery_price_perc_diff' byly získány hodnoty průměrných procentuálních rozdílů cen všech potravin rozdělených na roky. Třetí pohled 'v_pavel_zavodny_avg_wages_perc_diffs' přináší porovnání meziročních procentuálních rozdílů mezd v letech. Čtvrtý pohled 'v_pavel_zavodny_prices_vs_wages' spojuje tabulky z druhého a třetího pohledu a ukazuje celkové srovnání průměrných procentuálních meziročních rozdílu v letech u cen potravin a mezd. 

Zjištění:  Neexistuje rok s meziročním nárůstem cen potravin větším než 10% ve srovnání s meziročním nárůstem mezd. Největší meziroční difference 7,5% byla v roce 2013.

5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách      potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Ze sekundární tabulky byl vytvořen pohled 'v_pavel_zavodny_cz_gdp_diffs' s procentuálními meziročními rozdíly u HDP ČR v letech. Druhý pohled 'v_pavel_zavodny_cz_gdp_vs_grocery_and_wages' srovnává meziroční procentuální rozdíly u HDP, cen potravin a mezd v letech.

Zjištění: Pokud HDP vzroste výrazněji v jednom roce, né vždy se to projeví na cenách potravin ve stejném nebo násdujícím roce výraznějším růstem.
