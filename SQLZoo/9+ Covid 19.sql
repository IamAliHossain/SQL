-- 1.
-- The example uses a WHERE clause to show the cases in 'Italy' in March 2020.

-- Modify the query to show data from Spain


SELECT name, DAY(whn), confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn



-- 2.
-- The LAG function is used to show data from the preceding row or the table. When lining up rows the data is partitioned by country name and ordered by the data whn. That means that only data from Italy is considered.

-- Modify the query to show confirmed for the day before.


SELECT name, DAY(whn), confirmed,
   LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) as day_before
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn



-- 3.
-- The number of confirmed case is cumulative - but we can use LAG to recover the number of new cases reported for each day.

-- Show the number of new cases for each day, for Italy, for March.


SELECT name, DAY(whn), 
       confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) newcases
FROM covid
WHERE name = 'Italy'
   AND MONTH(whn) = 3
ORDER BY whn;



-- 4.
-- The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects.

-- You can filter the data to view only Monday's figures WHERE WEEKDAY(whn) = 0.

-- Show the number of new cases in Italy for each week in 2020 - show Monday only.

SELECT name, DATE_FORMAT(whn,'%Y-%m-%d'), 
       confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) newcases
FROM covid
WHERE name = 'Italy'
   AND WEEKDAY(whn) = 0
   AND YEAR(whn) = 2020 
ORDER BY whn;


-- 5.
-- You can JOIN a table using DATE arithmetic. This will give different results if data is missing.

-- Show the number of new cases in Italy for each week - show Monday only.

-- In the sample query we JOIN this week tw with last week lw using the DATE_ADD function.

SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), (tw.confirmed - lw.confirmed) newCases
FROM covid tw LEFT JOIN covid lw ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
   AND tw.name = lw.name
WHERE tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn




-- 6.
-- This query shows the number of confirmed cases together with the world ranking for cases for the date '2020-04-20'. The number of COVID deaths is also shown.

-- United States has the highest number, Spain is number 2...

-- Notice that while Spain has the second highest confirmed cases, Italy has the second highest number of deaths due to the virus.

-- Add a column to show the ranking for the number of deaths due to COVID.

SELECT 
   name,
   confirmed,
   RANK() OVER (ORDER BY confirmed DESC) rc,
   deaths,
   RANK() OVER (ORDER BY deaths DESC) deaths_cnt
  FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC



-- 7.
-- This query includes a JOIN t the world table so we can access the total population of each country and calculate infection rates (in cases per 100,000).
-- Show the infection rate ranking for each country. Only include countries with a population of at least 10 million.

SELECT 
   world.name,
   ROUND(100000*confirmed/population,2) as infection_rates_per_100000, 
   RANK() OVER(ORDER BY 100000*confirmed/population ) infection_Rate

FROM covid JOIN world ON covid.name=world.name
WHERE whn = '2020-04-20' AND population > 10000000
ORDER BY population DESC



-- 8.
-- For each country that has had at least 20000 new cases in a single day, show name of country, 
-- the date of the peak number of new cases and the peak value.

SELECT DISTINCT name, 
                DATE_FORMAT(whn,'%Y-%m-%d') date, 
                newcases peakNewCases
  FROM (SELECT name, whn,
               confirmed - LAG(confirmed, 1)
          OVER (PARTITION BY name ORDER BY whn) newcases
          FROM covid) a
 WHERE newcases = (SELECT MAX(newcases)
                     FROM (SELECT name, confirmed - LAG(confirmed, 1)
                             OVER (PARTITION BY name ORDER BY whn) newcases
                             FROM covid) b
                    WHERE a.name = b.name
                    GROUP BY name)
   AND newcases >= 20000
 ORDER BY name;