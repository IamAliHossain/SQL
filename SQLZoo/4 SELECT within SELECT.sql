-- 10. Some countries have populations more than three times that of all of their neighbours (in the same continent). Give the countries and continents.
select name, continent from world x
where population >= ALL(
                        select population*3 from world y
                        where x.continent = y.continent
                        and x.name <> y.name
                     )