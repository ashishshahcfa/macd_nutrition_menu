
-- Entire Table of MacDonalds Menu Items with its Nutritional Facts
	select * from MacDonalds

-- DATA EXPLORATION
-- Find Out Distinct Menu Items
	SELECT DISTINCT category FROM MacDonalds

-- Find out Total Number of Items in the list
	SELECT DISTINCT COUNT(ITEM) AS TOTAL_ITEMS FROM MacDonalds

-- Find out Items with Highest Calories and Sugar - Top 3
	SELECT TOP 3 item, calories FROM MacDonalds
	ORDER BY calories DESC
	 
	SELECT TOP 3 item, sugar FROM MacDonalds
	ORDER BY sugar DESC

-- Find out Zero Sugar Items
	SELECT item, sugar, calories FROM MacDonalds
	WHERE sugar = 0 AND [added sugar] = 0

-- Identify Items with Saturated Fat Greater than 15 grams
	SELECT item, [sat fat]
	FROM MacDonalds
	WHERE [sat fat] > 15

-- List Items that Have More Than 500 mg of Sodium
	SELECT item, sodium 
	FROM MacDonalds
	WHERE sodium > 500

-- Find the Item with the Lowest Cholesterol Content
	SELECT TOP 1 item, cholestrol 
	FROM MacDonalds
	ORDER BY cholestrol ASC

-- STATISTICS
-- Sort Items by Transfat
	SELECT item, [trans fat] FROM MacDonalds
	ORDER BY [trans fat] DESC

-- Average amount of Fats in gms across all items in particular category
	SELECT cast(AVG([TOTAL FAT]) AS INT) AS average_fat, category FROM MacDonalds
	GROUP BY category

-- Item with Highest Amount of Protein
	SELECT item, protein	FROM MacDonalds
	ORDER BY protein DESC

-- Total Items in each Category
	SELECT category, COUNT(ITEM) AS Total_Items	FROM MacDonalds
	GROUP BY category

-- Average Nutrients by Category
	SELECT category AS Category, 
	CAST(AVG(calories) AS decimal(10,2)) AS Calories,
	CAST(AVG(protien) AS decimal(10,2)) AS Protein,
	CAST(AVG([total fat]) AS decimal(10,2)) AS Total_Fat,
	CAST(AVG(cholestrol) AS decimal(10,2)) AS Cholestrol,
	CAST(AVG(carbs) AS decimal(10,2)) AS Carbs,
	CAST(AVG(sugar) AS decimal(10,2)) AS Sugar,
	CAST(AVG(sodium) AS decimal(10,2)) AS Sodium
	FROM MacDonalds
	GROUP BY category

-- CATEGORY ANALYSIS USING WINDOWS()
	SELECT DISTINCT category AS Category,
	ROUND(MAX(sugar + [added sugar]) OVER (PARTITION BY category),2) AS Max_Sugar,
	ROUND(MIN(sugar + [added sugar]) OVER (PARTITION BY category),2) AS Min_Sugar,
	ROUND(AVG(sugar + [added sugar]) OVER (PARTITION BY category),2) AS Avg_Sugar,
	ROUND(VAR(sugar + [added sugar]) OVER (PARTITION BY category),2) AS Var_Sugar,
	ROUND(STDEV(sugar + [added sugar]) OVER (PARTITION BY category),2) AS StdDev_Sugar
	FROM MacDonalds

-- Calculate the Percentage of Calories from Fat for Each Item
	SELECT item, 
    CAST(([total fat] * 9.0 / calories) * 100 AS int) AS fat_calorie_percentage 
	FROM MacDonalds
	WHERE calories <> 0
	--Since fat provides 9 calories per gram, we multiply the fat grams by 9 and calculate the percentage relative to total calories

-- Rank the Items by Protein Content in Descending Order
	SELECT item, protein, 
    RANK() OVER (ORDER BY protein DESC) AS protein_rank 
	FROM MacDonalds

-- Identify the Healthiest Item Based on Lowest Combination of Calories, Fat, and Sodium
	SELECT item, calories, [total fat], sodium, 
    (calories + [total fat] + sodium) AS health_score
	FROM MacDonalds
	ORDER BY health_score ASC


-- Find the Top 3 Items with the Highest Sugar Content in Each Category with CTE & WINDOWS()
	WITH RankedItems AS (
    SELECT category, item, sugar, 
    RANK() OVER (PARTITION BY category ORDER BY sugar DESC) AS sugar_rank 
    FROM MacDonalds
	)
	SELECT category, item, sugar 
	FROM RankedItems
	WHERE sugar_rank <= 3

-- Calculate the Average Cholesterol Content Across All Categories and Compare It to Each Category’s Cholesterol with CTE, SUBQUERY & WINDOWS()
	WITH AvgCholesterol AS 
	(SELECT CAST(AVG(cholesterol) AS decimal (10,2)) AS overall_avg_cholesterol FROM macdonalds)
	SELECT category, 
    CAST(AVG(cholesterol) AS decimal (10,2)) AS category_avg_cholesterol, 
    (SELECT overall_avg_cholesterol FROM AvgCholesterol) AS overall_avg_cholesterol 
	FROM macdonalds
	GROUP BY category
	   
