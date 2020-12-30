
---------------------------------------------------------------------------------------
--TASK 1

--Show the number of instruments rented per month during a specified year. 
SELECT COUNT(*) AS rentals_per_month, date_part('month', rental_start_date) AS month
FROM rented_instrument AS ri
WHERE date_part('year', ri.rental_start_date) = '2017'
GROUP BY date_part('month', rental_start_date)

--It shall be possible to retrieve the total number of rented instruments (just one number)
SELECT COUNT(*) AS total_rentals
FROM rented_instrument

--Rented instruments of each kind, one number per kind. List sorted by number of rentals.
SELECT COUNT(ri.rental_id) AS no_times_rented, ifr.instrument_type, ri.rental_id
FROM rented_instrument AS ri, instrument_for_rent AS ifr
WHERE ri.rental_id = ifr.rental_id
GROUP BY ri.rental_id, ifr.instrument_type
ORDER BY no_times_rented DESC
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 2

--The same as above, but retrieve the average number of rentals per month during the 
--entire year, instead of the total for each month.
SELECT ROUND(CAST(COUNT(*) AS decimal)/12, 2) AS average_rentals_per_month, 2017 AS year
FROM rented_instrument AS ri
WHERE date_part('year', ri.rental_start_date) = '2017'
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 3

--Show the number of lessons given per month during a specified year. 
SELECT SUM(no_of_lessons), month
FROM(
    SELECT COUNT(il.il_id) AS no_of_lessons, date_part('month', il.date) AS month
    FROM individual_lesson AS il
    WHERE date_part('year', il.date) = '2021'
    GROUP BY date_part('month', il.date)
  UNION ALL
    SELECT COUNT(sl.lesson_id) AS no_of_lessons, date_part('month', sl.date) AS month
    FROM scheduled_lesson AS sl
    WHERE date_part('year', sl.date) = '2021'
    GROUP BY date_part('month', sl.date)
) AS no_of_lessons
GROUP BY month

--It shall be possible to retrieve the total number of lessons, just one number (of one year)
SELECT SUM(no_of_lessons), '2021' AS year
FROM(
    SELECT COUNT(il.il_id) AS no_of_lessons
    FROM individual_lesson AS il
    WHERE date_part('year', il.date) = '2021'
  UNION ALL
    SELECT COUNT(sl.lesson_id) AS no_of_lessons
    FROM scheduled_lesson AS sl
    WHERE date_part('year', sl.date) = '2021'
) AS no_of_lessons

--Show the specific number of individual lessons, group lessons and ensembles. 
SELECT no_of_lessons AS frequency, lesson_type, '2021' AS year
FROM(
    SELECT COUNT(lesson_type) AS no_of_lessons, lesson_type
    FROM scheduled_lesson AS sl
    WHERE date_part('year', sl.date) = '2021'
    GROUP BY lesson_type
  UNION ALL
    SELECT COUNT(*) AS no_of_lessons, 'individual lesson' AS lesson_type
    FROM individual_lesson AS il
    WHERE date_part('year', il.date) = '2021'
) AS foo
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 4
--The same as above, but retrieve the average number of lessons per month during the entire year, 
--instead of the total for each month.
SELECT ROUND(CAST(SUM(no_of_lessons) AS decimal)/12, 2), month
FROM(
    SELECT COUNT(il.il_id) AS no_of_lessons, date_part('month', il.date) AS month
    FROM individual_lesson AS il
    WHERE date_part('year', il.date) = '2021'
    GROUP BY date_part('month', il.date)
  UNION ALL
    SELECT COUNT(sl.lesson_id) AS no_of_lessons, date_part('month', sl.date) AS month
    FROM scheduled_lesson AS sl
    WHERE date_part('year', sl.date) = '2021'
    GROUP BY date_part('month', sl.date)
) AS no_of_lessons
GROUP BY month
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 5

--List all instructors who has given more than a specific number of lessons (independent of type) during the current month.
SELECT i.instr_id, p.first_name, p.sur_name, summary.lessons_given
FROM instructor AS i, person AS p, (
    SELECT i.instr_id, SUM(result.lessons_given) AS lessons_given
    FROM instructor AS i, (
        SELECT i.instr_id, COUNT(i.instr_id) as lessons_given
        FROM instructor AS i, individual_lesson AS il
        WHERE date_part('year', il.date) = '2021' AND date_part('month', il.date) = '1' AND il.instr_id = i.instr_id
        GROUP BY i.instr_id
      UNION ALL
        SELECT i.instr_id, COUNT(i.instr_id) as lessons_given
        FROM instructor AS i, scheduled_lesson AS sl
        WHERE date_part('year', sl.date) = '2021' AND date_part('month', sl.date) = '1' AND sl.instr_id = i.instr_id
        GROUP BY i.instr_id
    ) AS result
    WHERE result.instr_id = i.instr_id
    GROUP BY i.instr_id
) AS summary
WHERE summary.lessons_given > 2 AND summary.instr_id = i.instr_id AND i.person_id = p.person_id
ORDER BY summary.lessons_given DESC;

--Also list the three instructors having given most lessons during the last month, 
--sorted by number of given lessons. 
SELECT i.instr_id, p.first_name, p.sur_name, SUM(result.lessons_given) AS lessons_given
FROM instructor AS i, person AS p, (
    SELECT i.instr_id, COUNT(i.instr_id) as lessons_given
    FROM instructor AS i, individual_lesson AS il
    WHERE date_part('year', il.date) = '2021' AND date_part('month', il.date) = '1' AND il.instr_id = i.instr_id
    GROUP BY i.instr_id
 UNION ALL
    SELECT i.instr_id, COUNT(i.instr_id) as lessons_given
    FROM instructor AS i, scheduled_lesson AS sl
    WHERE date_part('year', sl.date) = '2021' AND date_part('month', sl.date) = '1' AND sl.instr_id = i.instr_id
    GROUP BY i.instr_id
) AS result
WHERE result.instr_id = i.instr_id AND i.person_id = p.person_id
GROUP BY i.instr_id, p.first_name, p.sur_name
ORDER BY lessons_given DESC
LIMIT 3;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 6

--List all ensembles held during the next week, sorted by music genre and weekday. 
SELECT e.genre, sl.date, sl.room, EXTRACT(DOW FROM sl.date) AS weekday
FROM scheduled_lesson AS sl, ensemble AS e
WHERE sl.lesson_id = e.lesson_id AND sl.date > CURRENT_DATE
AND date_part('week', sl.date) -----DOES NOT GIVE ENSEMBLES WITH NO STUDENTS ATTENDING-----
    BETWEEN date_part('week', CURRENT_DATE)+1 AND date_part('week', CURRENT_DATE)+2
ORDER BY genre, EXTRACT(DOW FROM sl.date)

--For each ensemble tell whether it's full booked, has 1-2 seats left or has more seats left.
SELECT sl.lesson_type, sl.date, sl.max_participants - result.seats_taken AS seats_left
FROM scheduled_lesson AS sl, (
    SELECT COUNT(student_id) as seats_taken, e.lesson_id
    FROM student_scheduled_lesson AS ssl
    RIGHT JOIN ensemble AS e
    ON ssl.lesson_id = e.lesson_id
    GROUP BY e.lesson_id
) AS result
WHERE sl.lesson_id = result.lesson_id
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--TASK 7

--List the three instruments with the lowest monthly rental fee. 
SELECT instrument_type, instrument_brand, instrument_monthly_rent
FROM instrument_for_rent
ORDER BY instrument_monthly_rent ASC
LIMIT 3;

--For each instrument tell whether it is rented or available to rent. 
SELECT * 
FROM instrument_for_rent
ORDER BY rented DESC;

--Also tell when the next group lesson for each listed instrument is scheduled.
SELECT DISTINCT ON (instrument) instrument, date, room
FROM scheduled_lesson AS sl, group_lesson AS gl
WHERE sl.lesson_id = gl.lesson_id
AND sl.date > CURRENT_DATE
ORDER BY instrument, sl.date ASC
---------------------------------------------------------------------------------------