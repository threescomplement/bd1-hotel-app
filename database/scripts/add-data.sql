-- Insert data into the country table
INSERT INTO countries (id, name)
VALUES (1, 'United States');
INSERT INTO countries (id, name)
VALUES (2, 'France');

-- Insert data into the city table
INSERT INTO cities (id, name, country_id)
VALUES (1, 'New York City', 1);
INSERT INTO cities (id, name, country_id)
VALUES (2, 'Paris', 2);
INSERT INTO cities (id, name, country_id)
VALUES (3, 'Los Angeles', 1);

-- Insert data into the address table
INSERT INTO addresses (id, street, zip_code, city_id)
VALUES (1, '123 Main St', '10001', 1);
INSERT INTO addresses (id, street, zip_code, city_id)
VALUES (2, '456 Rue de la Paix', '75001', 2);
INSERT INTO addresses (id, street, zip_code, city_id)
VALUES (3, '789 Hollywood Blvd', '90001', 3);

-- Insert data into the hotel table
INSERT INTO hotels (id, phone_number, email, stars, address_id)
VALUES (1, '1234567890', 'hotel1@example.com', 4, 1);
INSERT INTO hotels (id, phone_number, email, stars, address_id)
VALUES (2, '0987654321', 'hotel2@example.com', 3, 2);

-- Insert data into the apartment table
INSERT INTO apartments (id, no_rooms, no_bathrooms, no_beds, max_no_people, area, price_per_day, hotel_id)
VALUES (1, 2, 1, 2, 4, 100, 150.00, 1);
INSERT INTO apartments (id, no_rooms, no_bathrooms, no_beds, max_no_people, area, price_per_day, hotel_id)
VALUES (2, 3, 2, 3, 6, 150, 200.00, 1);
INSERT INTO apartments (id, no_rooms, no_bathrooms, no_beds, max_no_people, area, price_per_day, hotel_id)
VALUES (3, 1, 1, 1, 2, 50, 100.00, 2);

-- Insert data into the customer table
INSERT INTO customers (id, name, surname, age, gender, email, phone_number, address_id)
VALUES (1, 'John', 'Doe', 30, 'M', 'john.doe@example.com', '1234567890', 1);
INSERT INTO customers (id, name, surname, age, gender, email, phone_number, address_id)
VALUES (2, 'Jane', 'Smith', 25, 'F', 'jane.smith@example.com', '0987654321', 2);

-- Insert data into the booking table
INSERT INTO bookings (id, start_date, end_date, no_people, customer_id, apartment_id)
VALUES (1, TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-05', 'YYYY-MM-DD'), 2, 1, 1);
INSERT INTO bookings (id, start_date, end_date, no_people, customer_id, apartment_id)
VALUES (2, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-05', 'YYYY-MM-DD'), 4, 2, 2);
INSERT INTO bookings (id, start_date, end_date, no_people, customer_id, apartment_id)
VALUES (3, TO_DATE('2023-08-01', 'YYYY-MM-DD'), TO_DATE('2023-08-05', 'YYYY-MM-DD'), 1, 1, 3);
INSERT INTO bookings (id, start_date, end_date, no_people, customer_id, apartment_id)
VALUES (4, TO_DATE('2023-06-14', 'YYYY-MM-DD'), TO_DATE('2023-06-20', 'YYYY-MM-DD'), 1, 1, 3);

-- Insert data into the services table
INSERT INTO services (id, name, price)
VALUES (1, 'Room Service', 10.00);
INSERT INTO services (id, name, price)
VALUES (2, 'Laundry Service', 15.00);
INSERT INTO services (id, name, price)
VALUES (3, 'Spa Service', 20.00);

-- Insert data into the booking_services table
INSERT INTO bookings_services (services_id, booking_id)
VALUES (1, 1);
INSERT INTO bookings_services (services_id, booking_id)
VALUES (2, 1);
INSERT INTO bookings_services (services_id, booking_id)
VALUES (3, 2);
INSERT INTO bookings_services (services_id, booking_id)
VALUES (3, 3);

-- Insert data into the complaints table
INSERT INTO complaints (id, "date", text, booking_id)
VALUES (1, TO_DATE('2023-06-02', 'YYYY-MM-DD'), 'The bed was too fluffy!', 1);
INSERT INTO complaints (id, "date", text, booking_id)
VALUES (2, TO_DATE('2023-07-02', 'YYYY-MM-DD'), 'The shower had singing mermaids!', 2);
INSERT INTO complaints (id, "date", text, booking_id)
VALUES (3, TO_DATE('2023-08-02', 'YYYY-MM-DD'), 'The view was too picturesque and distracting!', 3);

-- Insert data into the payments table
INSERT INTO payments (id, timestamp, amount, booking_id)
VALUES (1, TO_DATE('2023-06-05', 'YYYY-MM-DD'), 300.00, 1);
INSERT INTO payments (id, timestamp, amount, booking_id)
VALUES (2, TO_DATE('2023-07-05', 'YYYY-MM-DD'), 800.00, 2);
INSERT INTO payments (id, timestamp, amount, booking_id)
VALUES (3, TO_DATE('2023-08-05', 'YYYY-MM-DD'), 100.00, 3);

-- Insert data into the rating table
INSERT INTO ratings (id, "date", star_rating, text, booking_id)
VALUES (1, TO_DATE('2023-06-06', 'YYYY-MM-DD'), 4, 'The hotel staff were hilarious!', 1);
INSERT INTO ratings (id, "date", star_rating, text, booking_id)
VALUES (2, TO_DATE('2023-07-06', 'YYYY-MM-DD'), 5, 'The apartment had magical teleporting doors!', 2);
INSERT INTO ratings (id, "date", star_rating, text, booking_id)
VALUES (3, TO_DATE('2023-08-06', 'YYYY-MM-DD'), 3, 'The hotel had its own chocolate factory!', 3);

COMMIT;
