
---------------------------------------------------------------------------------------
--TASK 1

--Show the number of instruments rented per month during a specified year. 
CREATE VIEW annual_rentals_per_month AS SELECT COUNT(*) AS no_of_rentals, date_part('month', rental_start_date) AS month
FROM rented_instrument AS ri
WHERE date_part('year', ri.rental_start_date) = '2017'
GROUP BY date_part('month', rental_start_date);

--It shall be possible to retrieve the total number of rented instruments (just one number)
SELECT COUNT(*) AS total_rentals
FROM rented_instrument;

--Rented instruments of each kind, one number per kind. List sorted by number of rentals.
CREATE VIEW rented_instruments_per_kind AS SELECT ifr.instrument_type, COUNT(ifr.instrument_type) AS no_times_rented
FROM rented_instrument AS ri, instrument_for_rent AS ifr
WHERE ri.instrument_id = ifr.instrument_id
GROUP BY ifr.instrument_type
ORDER BY no_times_rented DESC;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 2

--The same as above, but retrieve the average number of rentals per month during the 
--entire year, instead of the total for each month.
CREATE VIEW annual_average_rentals_per_month AS SELECT ROUND(CAST(COUNT(*) AS decimal)/12, 2) AS average_rentals_per_month, 2017 AS year
FROM rented_instrument AS ri
WHERE date_part('year', ri.rental_start_date) = '2017';
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 3

--Show the number of lessons given per month during a specified year. 
CREATE VIEW annual_lessons_per_month AS SELECT COUNT(*), date_part('month', result.date) AS month
FROM (
    SELECT il.date AS date 
    FROM individual_lesson AS il
  UNION ALL
    SELECT sl.date AS date
    FROM scheduled_lesson AS sl
) AS result
WHERE date_part('year', result.date) = '2021'
GROUP BY date_part('month', result.date);

--It shall be possible to retrieve the total number of lessons, just one number (of one year)
SELECT COUNT(*), '2021' AS year
FROM (
    SELECT il.date AS date
    FROM individual_lesson AS il
  UNION ALL
    SELECT sl.date AS date
    FROM scheduled_lesson AS sl
) AS result
WHERE date_part('year', result.date) = '2021';

--Show the specific number of individual lessons, group lessons and ensembles. 
CREATE VIEW lessons_per_kind AS SELECT COUNT(lesson_type), lesson_type, '2021' AS year
FROM(
    SELECT lesson_type, sl.date AS date
    FROM scheduled_lesson AS sl
  UNION ALL
    SELECT 'individual lesson' AS lesson_type, il.date AS date
    FROM individual_lesson AS il
) AS result
WHERE date_part('year', result.date) = '2021'
GROUP BY result.lesson_type;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 4
--The same as above, but retrieve the average number of lessons per month during the entire year, 
--instead of the total for each month.
CREATE VIEW annual_average_lessons_per_month AS SELECT ROUND(CAST(COUNT(*) AS decimal)/12, 2) AS average_lessons_per_month, '2021' AS year
FROM (
    SELECT il.date AS date
    FROM individual_lesson AS il
  UNION ALL
    SELECT sl.date AS date
    FROM scheduled_lesson AS sl
) AS result
WHERE date_part('year', result.date) = '2021';
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 5

--List all instructors who has given more than a specific number of lessons (independent of type) during the current month.
CREATE MATERIALIZED VIEW instructors_at_risk AS SELECT p.first_name, p.sur_name, summary.lessons_given
FROM person AS p, (
    SELECT result.person_id, COUNT(result.person_id) AS lessons_given
    FROM (
        SELECT i.person_id, i.instr_id, il.date
        FROM instructor AS i, individual_lesson AS il
        WHERE i.instr_id = il.instr_id
      UNION ALL
        SELECT i.person_id, i.instr_id, sl.date
        FROM instructor AS i, scheduled_lesson AS sl
        WHERE i.instr_id = sl.instr_id
    ) AS result
    WHERE date_part('year', result.date) = '2021' AND date_part('month', result.date) = '1'
    GROUP BY result.person_id
) AS summary
WHERE summary.lessons_given > 2 AND summary.person_id = p.person_id
ORDER BY summary.lessons_given DESC;

--Also list the three instructors having given most lessons during the last month, 
--sorted by number of given lessons. 
CREATE MATERIALIZED VIEW given_lessons_leaderboard AS SELECT p.first_name, p.sur_name, COUNT(result.person_id) AS lessons_given
FROM person AS p, (
    SELECT i.person_id, il.date
    FROM instructor AS i, individual_lesson AS il
    WHERE il.instr_id = i.instr_id
 UNION ALL
    SELECT i.person_id, sl.date
    FROM instructor AS i, scheduled_lesson AS sl
    WHERE sl.instr_id = i.instr_id
) AS result
WHERE result.person_id = p.person_id AND date_part('year', result.date) = '2021' AND date_part('month', result.date) = '1'
GROUP BY p.first_name, p.sur_name
ORDER BY lessons_given DESC
LIMIT 3;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 6

--List all ensembles held during the next week, sorted by music genre and weekday. 
CREATE MATERIALIZED VIEW ensembles_next_week AS SELECT e.genre, sl.date, sl.room, EXTRACT(DOW FROM sl.date) AS weekday, date_part('week', sl.date)
FROM scheduled_lesson AS sl, ensemble AS e
WHERE sl.lesson_id = e.lesson_id AND sl.date > CURRENT_DATE
AND date_part('week', sl.date) = 1;

--For each ensemble tell whether it's full booked, has 1-2 seats left or has more seats left.
CREATE MATERIALIZED VIEW seats_left_ensembles AS SELECT sl.lesson_type, sl.date, sl.max_participants - result.seats_taken AS seats_left
FROM scheduled_lesson AS sl, (
    SELECT COUNT(student_id) as seats_taken, e.lesson_id
    FROM student_scheduled_lesson AS ssl
    RIGHT JOIN ensemble AS e
    ON ssl.lesson_id = e.lesson_id
    GROUP BY e.lesson_id
) AS result
WHERE sl.lesson_id = result.lesson_id;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 7

--List the three instruments with the lowest monthly rental fee. 
CREATE MATERIALIZED VIEW lowest_fee_instruments AS SELECT instrument_type, instrument_brand, instrument_monthly_rent
FROM instrument_for_rent
ORDER BY instrument_monthly_rent ASC
LIMIT 3;

--For each instrument tell whether it is rented or available to rent. 
CREATE MATERIALIZED VIEW rentable_instruments AS SELECT ifr.instrument_type, ifr.instrument_brand, ifr.instrument_monthly_rent, ifr.rented
FROM instrument_for_rent AS ifr
ORDER BY rented DESC;

--Also tell when the next group lesson for each listed instrument is scheduled.
CREATE VIEW next_group_lesson_per_instrument AS SELECT DISTINCT ON (gl.instrument) instrument, sl.date, sl.room
FROM scheduled_lesson AS sl, group_lesson AS gl
WHERE sl.lesson_id = gl.lesson_id
AND sl.date >= '2021-01-04'
ORDER BY gl.instrument, sl.date ASC;
---------------------------------------------------------------------------------------