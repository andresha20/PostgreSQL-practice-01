-- DATA TYPES

	-- Boolean
	-- Character: char, varchar, text
	-- Numeric: integer, floating-point number
	-- Temporal: date, time, timestamp, interval
	-- UUID: Universally Unique Identifiers
	-- Array: Stores an array of strings, numbers, etc.
	-- JSON
	-- Hstore key-value pair
	-- Special types such as network address and geometric data.

-- Select all

SELECT * FROM payment;

-- Select with distinct

SELECT DISTINCT(release_year) FROM film;

-- Select with distinct and count

SELECT COUNT(DISTINCT amount) FROM film;

-- Where

SELECT COUNT (*) FROM film
WHERE rating = 'R' OR rating = 'PG-13';

-- What's the email for the customer with the name Nancy Thomas?

SELECT email FROM customer
WHERE first_name = 'Nancy'
AND last_name = 'Thomas';

-- What are the titles of the 5 shortest (in length of runtime) movies?

SELECT title,length FROM film
ORDER BY length ASC
LIMIT 5;

-- If the previous customer can watch any movie that is 50 minutes or less in run time, how many options does she have?

SELECT COUNT(title) FROM film
WHERE length <= 50;

-- How many payment transactions where greater than $5.00?

SELECT COUNT(amount) FROM payment
WHERE amount > 5.00;

-- How many actors have a first name that starts with the letter P?

SELECT COUNT(*) FROM actor
WHERE first_name LIKE 'P%';

-- How many unique districts are our customers from?

SELECT COUNT(DISTINCT(district)) FROM address;

-- Retrieve the list of names for those distinct districts from the previous question

SELECT DISTINCT(district) FROM address;

-- How many films have a rating of R and a replacement cost between $5 and $15?

SELECT COUNT(*) FROM film
WHERE rating = 'R'
AND replacement_cost BETWEEN 5 AND 15;

-- How many films have the word Truman somewhere in the title?

SELECT COUNT(*) FROM films
WHERE title LIKE '%Truman%';

-- We have 2 staff members with Staff IDs 1 and 2. We want to give a bonus to the staff member that handled the most payments (most in terms of number of payments processed, not total dollar amount).
-- How many payments did each staff member handle and who gets the bonus?

SELECT staff_id, COUNT(AMOUNT) FROM payment
GROUP BY staff_id;

-- Corporate HQis conducting a study on the relationship between replacement cost and a movieMPAA rating (e.g.G, PG,R, etc).
-- What's the average replacement cost per MPAA rating?

SELECT rating, ROUND(AVG(replacement_cost), 2) FROM film
GROUP BY rating;

-- We are running a promotion to reward our top 5 customers with coupons.
-- What are the customer IDs of the top 5 customers by total spend?

SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

-- We are launching a platinum service for our most loyal customers. We'll assign platinum status to customers that have had 40 or more transaction payments.
-- What customer_ids are elegible for platinum status?

SELECT customer_id, COUNT(*) FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;

-- What are the customer IDs of customers who have spent more than $100 in payment transactions with our staff_id member 2?

SELECT customer_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 100;

-- Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.

SELECT customer_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110;

-- How many films begin with the letter J?

SELECT COUNT(*) FROM film
WHERE title LIKE 'J%';

-- What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?

SELECT first_name, last_name FROM customer
WHERE first_name LIKE 'E%'
AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;

-- California sales tax laws have changed and we need to alert our customers of this through email.
-- What are the emails of the customers who live in California?

SELECT district, email FROM address
INNER JOIN customer ON address.address_id = customer.address_id
WHERE district = 'California';

-- A customer walks in and is a huge fan of the actor 'Nick Wahlberg' and thus wants to know which movies he's in.
-- Get a list of all the movies 'Nick Wahlberg' has been in.

SELECT title, first_name, last_name FROM film_actor
INNER JOIN actor 
ON film_actor.actor_id = actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id
WHERE fist_name = 'Nick'
AND last_name = 'Wahlberg';

-- Full outer joins

SELECT * FROM Registrations FULL OUTER JOIN Logins
ON Registrations.name = Logins.name
WHERE Registrations.reg_id IS null OR
Logins.log_id IS null

-- Left outer join

SELECT * FROM Registrations
LEFT OUTER JOIN Logins
ON Registrations.name = Logins.name
WHERE Logins.log_id IS null;

-- During which months did payments occur? Format your answer to return back the full month name.

SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) FROM payment;

-- How many payments ocurred on a Monday?

SELECT COUNT(*) FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1;

-- Get a list of students who scored better than the average grade:

SELECT student, grade FROM test_scores
WHERE grade > (SELECT AVG(grade) FROM test_scores);

-- Select students on honor table:

SELECT student, grade FROM test_scores
WHERE student IN (SELECT student FROM honor_roll_table);

-- Using self-join to see reports according to employee_id:

SELECT emp.name, report.name AS rep 
FROM employees AS emp
JOIN employees AS report 
ON emp.emp_id = report.report_id;

-- CASE: General case

SELECT a,
	CASE 
		WHEN a = 1 THEN 'one'
		WHEN a = 2 THEN 'two'
	ELSE
		'other'
	END
FROM test;


-- CASE: Case expression

SELECT a,
	CASE 
		WHEN 1 THEN 'one'
		WHEN 2 THEN 'two'
	ELSE
		'other'
	END
FROM test;

SELECT
	SUM (CASE rental_rate
		WHEN 2.99 THEN 1
		ELSE 0
	END) AS regular,
	SUM (CASE rental_rate
		WHEN 2.99 THEN 1
		ELSE 0
	END) AS bargains
FROM film

-- Coalesce

SELECT item, (price - COALESCE(discount, 0)) FROM table;

-- Nullif

NULLIF(10,12)
Returns 10

-- How can you retrieve all the information from the cd.facilities table?

SELECT * FROM cd.facilities; 

-- You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?

SELECT name, membercost FROM cd.facilities;

-- How can you produce a list of facilities that charge a fee to members?

SELECT * FROM cd.facilities WHERE membercost > 0;

-- How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND
(membercost < monthlymaintenance/50.0);

-- How can you produce a list of all facilities with the word 'Tennis' in their name?

SELECT * FROM cd.facilities WHERE name LIKE '%Tennis%';

-- How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

SELECT * FROM cd.facilities WHERE facid IN (1,5);

-- How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid, surname, firstname, joindate 
FROM cd.members WHERE joindate >= '2012-09-01';

-- How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.

SELECT DISTINCT surname FROM cd.members
ORDER BY  surname LIMIT 10;

-- You'd like to get the signup date of your last member. How can you retrieve this information?

SELECT MAX(joindate) AS latest_signup FROM cd.members;

-- Produce a count of the number of facilities that have a cost to guests of 10 or more.

SELECT COUNT(*) FROM cd.facilities 
WHERE guestcost >= 10;

-- Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid, sum(slots) AS "Total Slots" FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' 
GROUP BY facid 
ORDER BY SUM(slots);

-- Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.

SELECT facid, sum(slots) AS total_slots FROM cd.bookings 
GROUP BY facid 
HAVING SUM(slots) > 1000 
ORDER BY facid;

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT cd.bookings.starttime AS start, cd.facilities.name AS name 
FROM cd.facilities 
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid 
WHERE cd.facilities.facid IN (0,1) AND cd.bookings.starttime >= '2012-09-21' AND cd.bookings.starttime < '2012-09-22' 
ORDER BY cd.bookings.starttime;

-- How can you produce a list of the start times for bookings by members named 'David Farrell'?

SELECT cd.bookings.starttime 
FROM cd.bookings 
INNER JOIN cd.members 
ON cd.members.memid = cd.bookings.memid 
WHERE cd.members.firstname='David' AND cd.members.surname='Farrell';

-- TRIGGERS

-- A PostgreSQL trigger is a function called automatically whenever an event such as an insert, update, or deletion occurs.
-- A PostgreSQL trigger can be defined to fire in the following cases:

	-- Before attempting any operation on a row (before constraints are checked and the INSERT, UPDATE or DELETE is attempted).
	-- When an operation has been completed (after constraints are checked and the INSERT, UPDATE, or DELETE has been completed).
	-- In spite of the operation (in the case of INSERT, UPDATE, or DELETE on a view).

CREATE OR REPLACE FUNCTION log_last_name_changes()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS $$
BEGIN
	IF NEW.last_name <> OLD.last_name THEN
		 INSERT INTO employee_audits(employee_id,last_name,changed_on)
		 VALUES(OLD.id,OLD.last_name,now());
	END IF;

	RETURN NEW;
END;
$$

-- 

CREATE TRIGGER last_name_changes
BEFORE UPDATE
ON employees
FOR EACH ROW
EXECUTE PROCEDURE log_last_name_changes();

-- DROP TRIGGER

DROP TRIGGER username_check
ON staff;






