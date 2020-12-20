
--soundgood_facility
INSERT INTO "soundgood_facility" ("name", "street", "zip_code", 
    "city", "school_id")
VALUES ('Soundgood', 'Pjäxvägen', '29476', 'Sölvesborg', '1');
--

--person (student)
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Birgitta', 'Björk', '0006155782', '20', 'birgitta.sjoblom@gmail.com', 
    '0163479668', 'Guldhamra mariedamm', '63239', 'Eskilstuna');

INSERT INTO "student" ("person_id")
VALUES('1');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Gunnar', 'Lejon', '8211016954', '38', 'gunnar.lejon@gmail.com', 
    '0609046509', 'Adinavägen', '85463', 'Sundsvall');

INSERT INTO "student" ("person_id")
VALUES('2');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Ulrik', 'Thelin', '9604103391', '24', 'ulrik.nordell@gmail.com', 
    '0629527207', 'Industrikajen', '88130', 'Sollefteå');

INSERT INTO "student" ("person_id")
VALUES('3');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Vega', 'Bergendahl', '7610181583', '44', 'vega.bergendahl@gmail.com', 
    '0956412765', 'Åsaka björkebacken', '92137', 'Lycksele');

INSERT INTO "student" ("person_id")
VALUES('4');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Carin', 'Wahlqvist', '9107134265', '29', 'carin.wahlqvist@gmail.com', 
    '0528960298', 'Jälavägen', '46237', 'Vänersborg');
-- ^ not accepted yet

--parent
INSERT INTO "parent" ("email", "phone_number", "student_id")
VALUES ('carl-gustav.thelin@gmail.com', '0544638391', '3');
--
INSERT INTO "parent" ("email", "phone_number", "student_id")
VALUES ('natalia.björk@gmail.com', '0124100535', '2');
--

--person (administrator)
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Robin', 'Rodin', '8403309191', '36', 'robin.rodin@gmail.com', 
    '0606281351', 'Öggestorp solås', '73135', 'Köping');

INSERT INTO "administrator" ("staff_id", "facility_id", "person_id")
VALUES ('1', '1', '5');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Erling', 'Söderlind', '6612174976', '54', 'erling.soderlind@gmail.com', 
    '0262947234', 'Öby gård', '34331', 'Älmhult');

INSERT INTO "administrator" ("staff_id", "facility_id", "person_id")
VALUES ('2', '1', '6');
--

--person (instructor)
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Lukas', 'Enqvist', '7106198331', '49', 'lukas.enqvist@gmail.com', 
    '0916490537', 'Sjöblads väg', '95336', 'Haparanda');

INSERT INTO "instructor" ("staff_id", "facility_id", "person_id")
VALUES ('3', '1', '7');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Alma', 'Renberg', '7003287542', '50', 'alma.renberg@gmail.com', 
    '0948937966', 'Ramnåsvägen', '91292', 'Vilhelmina');

INSERT INTO "instructor" ("staff_id", "facility_id", "person_id")
VALUES ('4', '1', '8');
--
INSERT INTO "person" ("first_name", "sur_name", "person_number", "age", "email", 
    "phone_number", "street", "zip_code", "city")
VALUES ('Viviann', 'Törnqvist', '560607', '64', 'vivianne.tornqvist@gmail.com', 
    '0189517887', 'Kronhjulsstigen', '75446', 'Uppsala');

INSERT INTO "instructor" ("staff_id", "facility_id", "person_id")
VALUES ('5', '1', '9');
--

--instrument_for_rent
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('guitar', 'Gibson', '25', 'false');
--
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('piano', 'Shure', '35', 'false');
--
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('saxophone', 'Yamaha', '30', 'true');
--
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('drums', 'Sennheiser', '50', 'false');
--
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('drums', 'Sennheiser', '50', 'true');
--
INSERT INTO "instrument_for_rent" ("instrument_type", "instrument_brand", 
    "instrument_monthly_rent", "rented")
VALUES ('drums', 'Sennheiser', '50', 'false');
--

--rented_instrument
INSERT INTO "rented_instrument" ("rental_start_date", "rental_end_date", 
    "rental_id")
VALUES ('2017-01-20', '2018-01-20', '1');
--
INSERT INTO "rented_instrument" ("rental_start_date", "rental_end_date", 
    "rental_id")
VALUES ('2017-04-06', '2017-06-06', '2');
--
INSERT INTO "rented_instrument" ("rental_start_date", "rental_end_date", 
    "rental_id")
VALUES ('2017-07-06', '2017-08-06', '2');
--
INSERT INTO "rented_instrument" ("rental_start_date", "rental_end_date", 
    "student_id", "rental_id")
VALUES ('2020-05-21', '2021-05-21', '3', '3');
--
INSERT INTO "rented_instrument" ("rental_start_date", "rental_end_date", 
    "student_id", "rental_id")
VALUES ('2020-08-30', '2021-04-30', '2', '5');
--

--instrument_skill
INSERT INTO "instrument_skill" ("instrument", "instr_id")
VALUES ('guitar', '1');
--
INSERT INTO "instrument_skill" ("instrument", "instr_id")
VALUES ('piano', '1');
--
INSERT INTO "instrument_skill" ("instrument", "instr_id")
VALUES ('drums', '2');
--
INSERT INTO "instrument_skill" ("instrument", "instr_id")
VALUES ('saxophone', '3');
--

--instrument_learning
INSERT INTO "instrument_learning" ("instrument_skill", 
    "instrument", "student_id")
VALUES ('advanced', 'piano', '1');
--
INSERT INTO "instrument_learning" ("instrument_skill", 
    "instrument", "student_id")
VALUES ('beginner', 'guitar', '1');
--
INSERT INTO "instrument_learning" ("instrument_skill", 
    "instrument", "student_id")
VALUES ('beginner', 'guitar', '2');
--
INSERT INTO "instrument_learning" ("instrument_skill", 
    "instrument", "student_id")
VALUES ('advanced', 'drums', '3');
--
INSERT INTO "instrument_learning" ("instrument_skill", 
    "instrument", "student_id")
VALUES ('intermediate', 'saxophone', '4')
--

--opening_hours
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('monday', '10:00', '19:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('tuesday', '10:00', '19:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('wednesday', '10:00', '19:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('thursday', '10:00', '19:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('friday', '10:00', '19:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "open", 
    "close", "facility_id")
VALUES ('saturday', '11:00', '15:00', '1');
--
INSERT INTO "opening_hours" ("day_of_week", "facility_id")
VALUES ('sunday', '1');
--

--lesson_pricing
INSERT INTO "lesson_pricing" ("day_of_week", "lesson_level",
    "lesson_type", "price", "admin_id")
VALUES ('tuesday', 'beginner', 'group lesson', '90', '2');
--
INSERT INTO "lesson_pricing" ("day_of_week",
    "lesson_type", "price", "admin_id")
VALUES ('tuesday', 'ensemble', '95', '2');
--
INSERT INTO "lesson_pricing" ("day_of_week", "lesson_level",
    "lesson_type", "price", "admin_id")
VALUES ('saturday', 'advanced', 'group lesson', '130', '2');
--
INSERT INTO "lesson_pricing" ("day_of_week", "lesson_level",
    "lesson_type", "price", "admin_id")
VALUES ('saturday', 'intermediate', 'group lesson', '120', '2');
--
INSERT INTO "lesson_pricing" ("day_of_week", "lesson_level",
    "lesson_type", "price", "admin_id")
VALUES ('wednesday', 'intermediate', 'individual', '200', '2');
--
INSERT INTO "lesson_pricing" ("day_of_week", "lesson_level",
    "lesson_type", "price", "admin_id")
VALUES ('wednesday', 'advanced', 'individual', '220', '2');
--

--scheduled_lesson (5/1 -> tuesday | 9/1 -> saturday | 12/1 -> tuesday)
INSERT INTO "scheduled_lesson" ("room", "start_time", "date", "lesson_type",
    "min_participants", "max_participants", "pricing_id", "instr_id",
    "admin_id")
VALUES ('201', '10:00', '2021-01-05', 'group lesson', '1', '5', '1', '1', '1');   --beginner guitar
--
INSERT INTO "scheduled_lesson" ("room", "start_time", "date", "lesson_type",
    "min_participants", "max_participants", "pricing_id", "instr_id",
    "admin_id")
VALUES ('202', '10:00', '2021-01-05', 'ensemble', '1', '5', '2', '2', '1');
--
INSERT INTO "scheduled_lesson" ("room", "start_time", "date", "lesson_type",
    "min_participants", "max_participants", "pricing_id", "instr_id",
    "admin_id")
VALUES ('201', '15:00', '2021-01-09', 'group lesson', '1', '5', '3', '1', '1');   --advanced piano
--
INSERT INTO "scheduled_lesson" ("room", "start_time", "date", "lesson_type",
    "min_participants", "max_participants", "pricing_id", "instr_id",
    "admin_id")
VALUES ('203', '14:00', '2021-01-09', 'group lesson', '1', '5', '4', '3', '1');   --intermediate saxophone
--
INSERT INTO "scheduled_lesson" ("room", "start_time", "date", "lesson_type",
    "min_participants", "max_participants", "pricing_id", "instr_id",
    "admin_id")
VALUES ('204', '11:00', '2021-01-12', 'ensemble', '1', '5', '2', '2', '1');
--

--sibling_to
INSERT INTO "sibling_to" ("student_id_1", "student_id_2")
VALUES ('2', '4');
--

--student_application (1 student apply for 2 instruments)
INSERT INTO "student_application" ("admittion_result", 
    "claimed_advanced_skill", "admin_id", "student_id")
VALUES('Accepted', 'piano', '1' ,'1');
--
INSERT INTO "student_application" ("admittion_result", 
    "admin_id", "student_id")
VALUES('Accepted', '1' ,'1');
--
INSERT INTO "student_application" ("admittion_result", 
    "admin_id", "student_id")
VALUES('Accepted', '1' ,'2');
--
INSERT INTO "student_application" ("admittion_result", 
    "claimed_advanced_skill", "admin_id", "student_id")
VALUES('Accepted', 'drums', '1' ,'3');
--
INSERT INTO "student_application" ("admittion_result",
    "admin_id", "student_id")
VALUES('Accepted', '1' ,'4');
--
INSERT INTO "student_application" ("admittion_result", 
    "claimed_advanced_skill", "admin_id", "student_id")
VALUES('Not decided yet', 'guitar', '1' ,'5');
--

--student_scheduled_lesson (2 students attending 2 lessons)
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('1', '1');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('1', '2');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('2', '3');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('3', '1');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('4', '4');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('5', '3');
--
INSERT INTO "student_scheduled_lesson" ("lesson_id", "student_id")
VALUES ('5', '2');
--

--advanced_audition
INSERT INTO "advanced_audition" ("start_time", "date", "room", 
    "instrument", "audition_result", "instr_id", "sa_id", "student_id")
VALUES ('10:00', '2020-01-06', '205', 'piano', 'Accepted', '1', '1', '1');
INSERT INTO "advanced_audition" ("start_time", "date", "room", 
    "instrument", "audition_result", "instr_id", "sa_id", "student_id")
VALUES ('11:00', '2020-01-07', '205', 'saxophone', 'Accepted', '2', '4', '3');

--ensemble
INSERT INTO "ensemble" ("genre", "lesson_id")
VALUES ('rock', '2');
--
INSERT INTO "ensemble" ("genre", "lesson_id")
VALUES ('pop', '5');
--

--group_lesson
INSERT INTO "group_lesson" ("instrument", "lesson_level", "lesson_id")
VALUES ('guitar', 'beginner', '1');
--
INSERT INTO "group_lesson" ("instrument", "lesson_level", "lesson_id")
VALUES ('piano', 'advanced', '3');
--
INSERT INTO "group_lesson" ("instrument", "lesson_level", "lesson_id")
VALUES ('saxophone', 'intermediate', '4');
--

--individual_lesson
INSERT INTO "individual_lesson" ("individual_level", "instrument_type", 
    "room", "start_time", "date", "pricing_id", "instr_id", "admin_id", "student_id")
VALUES ('intermediate', 'saxophone', '202', '11:00', '2020-12-16', '5', '3', '2', '4');
--
INSERT INTO "individual_lesson" ("individual_level", "instrument_type", 
    "room", "start_time", "date", "pricing_id", "instr_id", "admin_id", "student_id")
VALUES ('advanced', 'piano', '202', '14:00', '2020-12-16', '6', '1', '2', '1');
--













--student_invoice (one per student) TA BORT?
INSERT INTO "student_invoice" ("sibling_discount", "number_of_lessons", 
    "total_price_rental", "month", "student_id")
VALUES ('', '', '', '', '')
--
INSERT INTO "student_invoice" ("sibling_discount", "number_of_lessons", 
    "total_price_rental", "month", "student_id")
VALUES ('', '', '', '', '')
--
INSERT INTO "student_invoice" ("sibling_discount", "number_of_lessons", 
    "total_price_rental", "month", "student_id")
VALUES ('', '', '', '', '')
--
INSERT INTO "student_invoice" ("sibling_discount", "number_of_lessons", 
    "total_price_rental", "month", "student_id")
VALUES ('', '', '', '', '')
--

--instructor_paycheck (one per instructor) TA BORT?
INSERT INTO "instructor_paycheck" ("month", "given_lessons", "instr_id")
VALUES ('', '', '')
--
INSERT INTO "instructor_paycheck" ("month", "given_lessons", "instr_id")
VALUES ('', '', '')
--
INSERT INTO "instructor_paycheck" ("month", "given_lessons", "instr_id")
VALUES ('', '', '')
--