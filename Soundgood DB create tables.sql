DROP TABLE IF EXISTS "parent" CASCADE;
DROP TABLE IF EXISTS "person" CASCADE;
DROP TABLE IF EXISTS "soundgood_facility" CASCADE;
DROP TABLE IF EXISTS "administrator" CASCADE;
DROP TABLE IF EXISTS "instrument_for_rent" CASCADE;
DROP TABLE IF EXISTS "instrument_rented" CASCADE;
DROP TABLE IF EXISTS "instruments_learning" CASCADE;
DROP TABLE IF EXISTS "lesson_pricing" CASCADE;
DROP TABLE IF EXISTS "opening_hours" CASCADE;
DROP TABLE IF EXISTS "student" CASCADE;
DROP TABLE IF EXISTS "student_invoice" CASCADE;
DROP TABLE IF EXISTS "student_parent" CASCADE;
DROP TABLE IF EXISTS "instructor" CASCADE;
DROP TABLE IF EXISTS "instructor_paycheck" CASCADE;
DROP TABLE IF EXISTS "instrument_skill" CASCADE;
DROP TABLE IF EXISTS "scheduled_lesson" CASCADE;
DROP TABLE IF EXISTS "student_scheduled_lesson" CASCADE;
DROP TABLE IF EXISTS "ensemble" CASCADE;
DROP TABLE IF EXISTS "group_lesson" CASCADE;
DROP TABLE IF EXISTS "sibling_to" CASCADE;
DROP TABLE IF EXISTS "student_application" CASCADE;
DROP TABLE IF EXISTS "individual_lesson" CASCADE;
DROP TABLE IF EXISTS "advanced_audition" CASCADE;


CREATE TABLE "parent" (
    "parent_id" serial NOT NULL,
    "email" VARCHAR(50) UNIQUE,
    "phone_number" VARCHAR(15) UNIQUE,
    PRIMARY KEY ("parent_id")
);

CREATE TABLE "person" (
    "person_id" serial NOT NULL,
    "first_name" VARCHAR(30),
    "sur_name" VARCHAR(30),
    "person_number" VARCHAR(12) UNIQUE,
    "age" INT,
    "email" VARCHAR(50) UNIQUE,
    "phone_number" VARCHAR(20) UNIQUE,
    "street" VARCHAR(30),
    "zip_code" VARCHAR(10),
    "city" VARCHAR(20),
    PRIMARY KEY ("person_id")
);

CREATE TABLE "soundgood_facility" (
    "facility_id" serial NOT NULL,
    "name" VARCHAR(30),
    "street" VARCHAR(30),
    "zip_code" CHAR(10),
    "city" VARCHAR(20),
    "school_id" VARCHAR(10) NOT NULL UNIQUE,
    PRIMARY KEY ("facility_id")
);

CREATE TABLE "student" (
    "student_id" serial NOT NULL,
    "person_id" INT NOT NULL REFERENCES "person",
    PRIMARY KEY ("student_id")
);


CREATE TABLE "student_invoice" (
    "invoice_id" serial NOT NULL,
    "sibling_discount" INT,
    "number_of_lessons" INT,
    "total_price_rental" INT,
	"month" VARCHAR(9),
    "student_id" INT REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("invoice_id")
);

CREATE TABLE "student_parent" (
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    "parent_id" INT NOT NULL REFERENCES "parent" ON DELETE CASCADE,
    PRIMARY KEY ("student_id", "parent_id")
);

CREATE TABLE "administrator" (
    "admin_id" serial NOT NULL,
    "staff_id" VARCHAR(10) NOT NULL UNIQUE,
    "facility_id" INT NOT NULL REFERENCES "soundgood_facility" ON DELETE CASCADE,
    "person_id" INT NOT NULL REFERENCES "person" ON DELETE CASCADE,
    PRIMARY KEY ("admin_id")
);

CREATE TABLE "instructor" (
    "instr_id" serial NOT NULL,
    "staff_id" VARCHAR(10) NOT NULL UNIQUE,
    "facility_id" INT NOT NULL REFERENCES "soundgood_facility" ON DELETE CASCADE,
    "person_id" INT NOT NULL REFERENCES "person" ON DELETE CASCADE,
    PRIMARY KEY ("instr_id")
);

CREATE TABLE "instructor_paycheck" (
    "paycheck_id" serial NOT NULL,
    "month" VARCHAR(9) NOT NULL,
    "given_lessons" INT,
    "instr_id" INT NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    PRIMARY KEY ("paycheck_id")
);

CREATE TABLE "instrument_for_rent" (
    "rental_id" serial NOT NULL,
    "instrumentType" VARCHAR(20),
    "instrumentBrand" VARCHAR(20),
    "instrumentMonthlyRent" INT,
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("rental_id")
);

CREATE TABLE "instrument_rented" (
    "instrument" VARCHAR(30) NOT NULL,
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("instrument", "student_id")
);

CREATE TABLE "instrument_skill" (
    "instrument" VARCHAR(20) NOT NULL,
    "instr_id" INT NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    PRIMARY KEY ("instr_id", "instrument")
);

CREATE TABLE "instruments_learning" (
    "instrument_skill" CHAR(10),
    "instrument" VARCHAR(20),
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("instrument", "student_id")
);

CREATE TABLE "lesson_pricing" (
    "pricing_id" serial NOT NULL,
    "day_of_week" VARCHAR(9) UNIQUE NOT NULL,
    "lesson_level" CHAR(10) NOT NULL,
    "lesson_type" VARCHAR(12) NOT NULL,
    "price" INT NOT NULL,
    "admin_id" INT REFERENCES "administrator",
    PRIMARY KEY ("pricing_id")
);

CREATE TABLE "opening_hours" (
    "day_of_week" VARCHAR(9) NOT NULL,
    "open" VARCHAR(5),
    "close" VARCHAR(5),
    "facility_id" INT NOT NULL REFERENCES "soundgood_facility" ON DELETE CASCADE,
    PRIMARY KEY ("facility_id", "day_of_week")
);

CREATE TABLE "scheduled_lesson" (
    "lesson_id" serial NOT NULL,
    "room" VARCHAR(20),
    "time" TIME(5),
    "date" DATE,
    "lesson_type" VARCHAR(12),
    "min_participants" INT,
    "max_participants" INT,
    "pricing_id" INT,
    "instr_id" INT NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    "admin_id" INT REFERENCES "administrator",
    PRIMARY KEY ("lesson_id")
);

CREATE TABLE "sibling_to" (
    "student_id_1" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    "student_id_2" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("student_id_1", "student_id_2")
);

CREATE TABLE "student_application" (
    "sa_id" serial NOT NULL,
    "admittion_result" VARCHAR(500),
    "claimed_advanced_skill" VARCHAR(20),
    "admin_id" INT REFERENCES "administrator",
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("sa_id")
);

CREATE TABLE "student_scheduled_lesson" (
    "lesson_id" INT NOT NULL REFERENCES "scheduled_lesson" ON DELETE CASCADE,
	"room" INT REFERENCES "scheduled_lesson",
	"date" INT REFERENCES "scheduled_lesson",
	"time" INT REFERENCES "scheduled_lesson",
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("lesson_id", "student_id")
);

CREATE TABLE "advanced_audition" (
    "aa_id" serial NOT NULL,
    "time" TIME(5),
    "date" DATE,
    "room" VARCHAR(20),
    "instrument" VARCHAR(20),
    "audition_result" VARCHAR(500),
    "instr_id" INT NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    "sa_id" INT NOT NULL REFERENCES "student_application" ON DELETE CASCADE,
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
	UNIQUE("sa_id", "student_id"),
    PRIMARY KEY ("aa_id", "time", "date")
);


CREATE TABLE "ensemble" (
    "ens_id" serial NOT NULL,
    "genre" VARCHAR(20),
    "lesson_id" INT NOT NULL REFERENCES "scheduled_lesson" ON DELETE CASCADE,
	"room" INT REFERENCES "scheduled_lesson",
	"date" INT REFERENCES "scheduled_lesson",
	"time" INT REFERENCES "scheduled_lesson",
    PRIMARY KEY ("ens_id")
);

CREATE TABLE "group_lesson" (
    "grl_id" serial NOT NULL,
    "instrument" VARCHAR(30),
    "lesson_level" VARCHAR(12),
    "lesson_id" INT NOT NULL REFERENCES "scheduled_lesson" ON DELETE CASCADE,
	"room" INT REFERENCES "scheduled_lesson",
	"date" INT REFERENCES "scheduled_lesson",
	"time" INT REFERENCES "scheduled_lesson",
    PRIMARY KEY ("grl_id")
);

CREATE TABLE "individual_lesson" (
    "il_id" INT NOT NULL,
    "individual_level" VARCHAR(12),
    "instrument_type" VARCHAR(20),
    "room" VARCHAR(20),
    "time" TIME(5),
    "date" DATE,
    "pricing_id" INT REFERENCES "lesson_pricing",
    "instr_id" INT NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    "admin_id" INT REFERENCES "administrator",
    "student_id" INT NOT NULL REFERENCES "student" ON DELETE CASCADE,
    PRIMARY KEY ("il_id", "room", "time", "date")
);