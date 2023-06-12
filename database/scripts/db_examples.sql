/*
Zapytanie wyświetlające informacje o wszystkich apartamentach wraz z nazwami miast i krajów, w których się znajdują:
*/
SELECT a.*, ci.name AS city, co.name AS country
FROM apartments a
         JOIN hotels h ON a.hotel_id = h.id
         JOIN addresses ad ON h.address_id = ad.id
         JOIN cities ci ON ad.city_id = ci.id
         JOIN countries co ON ci.country_id = co.id;


/*
Zapytanie wyświetlające nazwy miast, w których znajdują się apartamenty z co najmniej 3 łóżkami:
*/
SELECT ci.name AS city
FROM apartments a
         JOIN hotels h ON a.hotel_id = h.id
         JOIN addresses ad ON h.address_id = ad.id
         JOIN cities ci ON ad.city_id = ci.id
WHERE a.no_beds >= 3;


/*
Zapytanie wyświetlające informacje o rezerwacjach z datami rozpoczęcia i zakończenia, wraz z imionami i nazwiskami klientów:
*/
SELECT b.start_date, b.end_date, c.name, c.surname
FROM bookings b
         JOIN customers c ON b.customer_id = c.id;


/*
Zapytanie wyświetlające informacje o apartamentach z ceną za dobę większą niż 80 i liczbą pokoi mniejszą niż 3:
*/
SELECT a.*
FROM apartments a
WHERE a.price_per_day > 80
  AND a.no_rooms < 3;


/*
Zapytanie wyświetlające sumę cen wszystkich usług zarezerwowanych w ramach każdej rezerwacji:
*/
SELECT b.id AS booking_id, SUM(s.price) AS total_service_price
FROM bookings b
         JOIN bookings_services bs ON b.id = bs.booking_id
         JOIN services s ON bs.services_id = s.id
GROUP BY b.id;


/*
Zapytanie wyświetlające nazwiska klientów, którzy zarezerwowali apartamenty o powierzchni większej niż 100 metrów kwadratowych:
*/
SELECT c.surname
FROM customers c
         JOIN bookings b ON c.id = b.customer_id
         JOIN apartments a ON b.apartment_id = a.id
WHERE a.area > 100;


/*
Zapytanie wyświetlające średnią liczbę pokoi i łazienek we wszystkich apartamentach:
*/
SELECT ROUND(AVG(a.no_rooms), 2) AS avg_rooms, ROUND(AVG(a.no_bathrooms), 2) AS avg_bathrooms
FROM apartments a;


/*
Zapytanie wyświetlające informacje o rezerwacjach nieposiadających skargi
*/
SELECT b.*
FROM bookings b
         LEFT JOIN complaints c ON b.id = c.booking_id
WHERE c.ID IS NULL;


/*
Zapytanie wyświetlające informacje o klientach, którzy mają więcej niż jedną rezerwację,
posortowany malejąco według liczby rezerwacji:
*/
SELECT c.id, c.name, c.surname
FROM customers c
         JOIN bookings b ON c.id = b.customer_id
GROUP BY c.id, c.name, c.surname
HAVING COUNT(b.id) > 1
ORDER BY COUNT(b.id) DESC;


/*
Zapytanie wyświetlające informacje o klientach, którzy wynajęli apartamenty powyżej 30 metrów kwadratowych, których rezerwacje wyniosły
więcej niż 200 złotych. Zwraca pierwsze 10 wierszy, posortoawni względem liczby rezerwacji, a następnie sumy cen rezerwacji.
*/
SELECT c.name AS customer_name, c.email, COUNT(b.id) AS total_bookings, SUM(a.price_per_day) AS total_spent
FROM customers c
         JOIN bookings b ON c.id = b.customer_id
         JOIN apartments a ON b.apartment_id = a.id
         JOIN hotels h ON a.hotel_id = h.id
         JOIN addresses ad ON h.address_id = ad.id
         JOIN cities ci ON ad.city_id = ci.id
         JOIN countries co ON ci.country_id = co.id
WHERE a.area > 30
GROUP BY c.id, c.name, c.email
HAVING SUM(a.price_per_day) > 200
ORDER BY COUNT(b.id) DESC, SUM(a.price_per_day) DESC
    FETCH FIRST 10 ROWS ONLY;
