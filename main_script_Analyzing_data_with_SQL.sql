# Define to use sakila Database
USE sakila;

# 1a. Display the first and last names of all actors from the table actor.
SELECT 
first_name AS "First Name", 
last_name AS "Last Name" 
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. 
# Name the column Actor Name.

SELECT 
first_name AS "First Name", 
last_name AS "Last Name", 
CONCAT(first_name, " ", last_name) AS "Actor Name"
FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know 
# only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
actor_id AS "Actor ID",
first_name AS "First Name", 
last_name AS "Last Name"
FROM actor
WHERE first_name = 'Joe' ;

# 2b. Find all actors whose last name contain the letters GEN:
SELECT 
actor_id AS "Actor ID",
first_name AS "First Name", 
last_name AS "Last Name"
FROM actor
WHERE last_name LIKE "%GEN%";

# 2c. Find all actors whose last names contain the letters LI. This time, 
# order the rows by last name and first name, in that order:
SELECT 
actor_id AS "Actor ID",
first_name AS "First Name", 
last_name AS "Last Name"
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: 
# Afghanistan, Bangladesh, and China:
SELECT 
country_id AS "Country ID", 
country AS "Country" 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing 
# queries on a description, so create a column in the table actor named description and 
#use the data type BLOB (Make sure to research the type BLOB, as the difference between it 
# and VARCHAR are significant).
ALTER TABLE actor ADD Actor_Description TINYBLOB;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
# Delete the description column.
ALTER TABLE actor DROP COLUMN Actor_Description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, 
COUNT(*) AS "actors_with_last_name"
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors.
SELECT last_name, 
COUNT(*) AS "actors_with_last_name_greater_than_2"
FROM actor
GROUP BY last_name
HAVING actors_with_last_name_greater_than_2 >= 2;

# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
# GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name='HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT first_name, last_name FROM actor 
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
# GROUCHO was the correct name after all! In a single query, if the first name of the actor
# is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

SELECT first_name, last_name FROM actor 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME ='address'; 

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
# Use the tables staff and address:
SELECT 
staff.first_name, staff.last_name, 
address.address FROM staff INNER JOIN address ON staff.address_id = address.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
# Use tables staff and payment.
SELECT first_name, last_name, SUM(amount) AS 'Amount by each staff member'
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE ( '2005-08-%')
GROUP BY payment.staff_id;

# 6c. List each film and the number of actors who are listed for that film. 
# Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id) AS 'Amount of actors by film'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id) AS 'Amount of films by inventory ID'
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible' 
GROUP BY inventory.film_id;

# 6e. Using the tables payment and customer and the JOIN command, list the total 
# paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) AS 'Total amount paid by each customer'
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters K and Q have also soared 
# in popularity. Use subqueries to display the titles of movies starting with the letters K and Q 
# whose language is English.
SELECT * FROM film
WHERE film.title LIKE ('K%') OR film.title LIKE ('Q%')
AND 
film.language_id LIKE 
(SELECT language_id FROM language WHERE name = 'English');

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id LIKE(SELECT film_id FROM film
WHERE film.title LIKE ('Alone Trip'));

# 7c. You want to run an email marketing campaign in Canada, for which you 
# will need the names and email addresses of all Canadian customers. Use joins to 
# retrieve this information.
SELECT ID, customer_id, first_name, last_name, email, city, country
FROM customer
INNER JOIN customer_list
ON customer.customer_id = customer_list.ID
WHERE customer_list.country LIKE 'Canada';

# 7d. Sales have been lagging among young families, and you wish to target all 
# family movies for a promotion. Identify all movies categorized as family films.
SELECT (SELECT name FROM category
WHERE name = 'Family') AS "Movie category:", title, description, rating 
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id
WHERE category_id LIKE (SELECT category_id FROM category
WHERE name = 'Family');


# 7e. Display the most frequently rented movies in descending order.




SELECT *
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id
WHERE category_id LIKE (SELECT category_id FROM category
WHERE name = 'Family');



SELECT title, description, rating 
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id;




show tables;






# 7f. Write a query to display how much business, in dollars, each store brought in.
# 7g. Write a query to display for each store its store ID, city, and country.
# 7h. List the top five genres in gross revenue in descending order. (Hint: you may
# need to use the following tables: category, film_category, inventory, payment, and rental.)
# 8a. In your new role as an executive, you would like to have an easy way of viewing the 
# Top five genres by gross revenue. Use the solution from the problem above to create a view. 
# If you haven't solved 7h, you can substitute another query to create a view.
# 8b. How would you display the view that you created in 8a?
# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.







/*
