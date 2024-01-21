-- Q1: Who is the senior most employee based on job title?
/* SELECT employee_id, last_name, first_name, title, levels
FROM employee
ORDER BY levels desc
limit 1; */
-- Q2: Which countries have the most invoices?
/* SELECT COUNT(*) as c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c desc; */
-- Q3: What are top 3 values of total invoice?
/* SELECT total 
FROM invoice
ORDER BY total desc
limit 3; */
/* Q4: Which city has the best customers? We would like to throw
a promotional Music fest in the city we made the most money. Write 
a query that returns one city that has the highest sum of invoice 
total. Return both the city name & sum of all invoice totals. */
/* SELECT SUM(total) as invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total desc; */
/* Q5: Who is the best customer? The customer who has spent the most
money will be declared the best customer. Write a query that returns
the person who has spent the most money. */
/* SELECT customer.customer_id, customer.first_name ,customer.last_name, SUM(invoice.total) as Invoice_total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name , customer.last_name
ORDER BY Invoice_total DESC
LIMIT 1; */
/* Q6: Write a query to return the email, first name, last name & Genre 
of all Rock Music listeners. Return your list ordered alphabetically by
email starting with A. */
/* SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email; */
/* Q7: Let's invite the artists who have written the most rock
music in our dataset. Write a query that returns the Artist name
and total track count of the top 10 Rock  bands. */
/*SELECT artist.artist_id, artist.name_1, COUNT(artist.artist_id) as number_of_songs, genre.name
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON album.artist_id = artist.artist_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name_1, genre.name
ORDER BY number_of_songs desc
LIMIT 10; */

--Below is the more optimized query for Q7--
/* SELECT artist.artist_id, artist.name_1, COUNT(artist.artist_id) as number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON album.artist_id = artist.artist_id
WHERE genre_id = (
	SELECT genre_id
	FROM genre
    WHERE genre.name LIKE 'Rock')
GROUP BY artist.artist_id, artist.name_1
ORDER BY number_of_songs desc
LIMIT 10; */

/* Q8: Return all the track names that have a song length longer
than the average song length. Return the Names and Millliseconds
for each track. Order by the length with the longest songs listed
first. */
/* SELECT name_1, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
	FROM track)
ORDER BY milliseconds desc; */

/* Q9: Find how much amount spent by each customer on best artists? 
Write a query to return customer name,best_artist name and total spent */

WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id, artist.name_1 AS artist_name_1,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id
	ORDER BY total_sales desc
	LIMIT 1
)
SELECT c.first_name, c.last_name, bsa.artist_name_1,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track tr ON tr.track_id = il.track_id
JOIN album alb ON alb.album_id = tr.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3
ORDER BY 4 DESC;

