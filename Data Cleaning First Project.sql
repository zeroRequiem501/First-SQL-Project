# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;


SELECT *
FROM(
SELECT Row_ID, 
CONCAT(Country, Year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
FROM world_life_expectancy) AS Row_Table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy
WHERE Row_ID IN(
		SELECT Row_ID
        FROM(
			SELECT Row_ID, 
			CONCAT(Country, Year),
			ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
			FROM world_life_expectancy) AS Row_Table
			WHERE Row_Num > 1);
            
SELECT * 
FROM world_life_expectancy
WHERE status = '';

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE status <> '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
					FROM world_life_expectancy
					WHERE Status = 'Developing');
                    
                    
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';


SELECT * 
FROM world_life_expectancy
WHERE `Life Expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life Expectancy`, 
t2.Country, t2.Year, t2.`Life Expectancy`,
t3.Country, t3.Year, t3.`Life Expectancy`,
Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life Expectancy` = '';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life Expectancy` = Round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
WHERE t1.`Life Expectancy` = '';