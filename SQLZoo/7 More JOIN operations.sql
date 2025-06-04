Join clause use korte hole table gular common column thaka must chai

-- 1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr=1962

-- 2. Give year of 'Citizen Kane'.
select yr
from movie
where title = 'Citizen Kane'


-- 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
FROM movie
WHERE title like '%Star Trek%'
ORDER BY yr

-- 4. What id number does the actor 'Glenn Close' have?

SELECT id
FROM actor
WHERE name = 'Glenn Close'


-- 5. What is the id of the film 'Casablanca'

SELECT id
FROM movie
WHERE title= 'Casablanca'


-- 6. Obtain the cast list for 'Casablanca'.

-- what is a cast list? 
-- The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)

select name
from movie join casting on (movieid = movie.id)
       join actor on (actorid = actor.id)
where title = 'Casablanca'


-- 7. Obtain the cast list for the film 'Alien'

select name
from movie join casting on (movie.id = movieid)
           join actor on (actorid = actor.id)
where title = 'Alien' 


-- 8. List the films in which 'Harrison Ford' has appeared

select title
from movie join casting on (movie.id = casting.movieid)
           join actor on (actorid = actor.id)
where name = 'Harrison Ford'


-- 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. 
-- [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title
from movie join casting on (movie.id = casting.movieid)
           join actor on (casting.actorid = actor.id)
where name = 'Harrison Ford' and ord != 1;


-- 10. List the films together with the leading star for all 1962 films.


select title, name
from movie join casting on (movie.id = casting.movieid)
           join actor on (casting.actorid = actor.id)
where yr = 1962 and ord = 1 -- ekhane ord = 1 hoile leading star or lead character bujhay


-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id = movieid
        JOIN actor   ON actorid = actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2


-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.

-- Did you get "Little Miss Marker twice"?
-- Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).

-- Title is not a unique field, create a table of IDs in your subquery

SELECT title, name 
FROM movie join casting on (movie.id = casting.movieid and ord = 1)
           join actor on (casting.actorid = actor.id)
WHERE movie.id IN (
        SELECT movieid
        FROM casting
        WHERE actorid IN (
                SELECT id 
                FROM actor
                WHERE name = 'Julie Andrews'))


-- 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

select name
from movie join casting on (movieid = id and ord = 1)
           join actor on (actorid = actor.id)
group by name
having count(title) >= 15
order by name


-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select title, count(actorid)
from movie join casting on (movieid = movie.id)
           join actor on (actorid = actor.id)
where yr = 1978
group by title
order by count(actorid) desc, title


-- 15. List all the people who have worked with 'Art Garfunkel'

SELECT actor.name
FROM actor
    JOIN casting ON actor.id = actorid
    JOIN movie ON movieid=movie.id
WHERE actor.name <> "Art Garfunkel"
    AND movieid IN(SELECT movieid 
                     FROM casting
                          JOIN actor ON (actor.id=actorid)
                     WHERE name = "Art Garfunkel")
