drop table bookings_services cascade constraints purge;
drop table COMPLAINTS cascade constraints purge;
drop table PAYMENTS cascade constraints purge;
drop table ratings cascade constraints purge;
drop table bookings cascade constraints purge;
drop table apartments cascade constraints purge;
drop table customers cascade constraints purge;
drop table hotels cascade constraints purge;
drop table addresses cascade constraints purge;
drop table cities cascade constraints purge;
drop table countries cascade constraints purge;
drop table SERVICES cascade constraints purge;
drop view balance;

CREATE TABLE addresses
(
    id       INTEGER GENERATED ALWAYS AS IDENTITY,
    street   VARCHAR2(64),
    zip_code VARCHAR2(64),
    city_id  INTEGER NOT NULL
);

ALTER TABLE addresses
    ADD CONSTRAINT address_pk PRIMARY KEY (id);

CREATE TABLE apartments
(
    id            INTEGER GENERATED ALWAYS AS IDENTITY,
    no_rooms      INTEGER,
    no_bathrooms  INTEGER,
    no_beds       INTEGER,
    max_no_people INTEGER,
    area          INTEGER,
    price_per_day NUMBER(10, 2),
    hotel_id      INTEGER NOT NULL
);

ALTER TABLE apartments
    ADD CONSTRAINT apartment_pk PRIMARY KEY (id);

CREATE TABLE bookings
(
    id           INTEGER GENERATED ALWAYS AS IDENTITY,
    start_date   DATE,
    end_date     DATE,
    no_people    INTEGER,
    customer_id  INTEGER NOT NULL,
    apartment_id INTEGER NOT NULL
);

CREATE INDEX booking__idx ON
    bookings (
              apartment_id
              ASC);

ALTER TABLE bookings
    ADD CONSTRAINT booking_pk PRIMARY KEY (id);

CREATE TABLE bookings_services
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY,
    services_id INTEGER NOT NULL,
    booking_id  INTEGER NOT NULL
);

ALTER TABLE bookings_services
    ADD CONSTRAINT booking_services_pk PRIMARY KEY (id);

CREATE TABLE cities
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY,
    name       VARCHAR2(64),
    country_id INTEGER NOT NULL
);

ALTER TABLE cities
    ADD CONSTRAINT city_pk PRIMARY KEY (id);

CREATE TABLE customers
(
    id           INTEGER GENERATED ALWAYS AS IDENTITY,
    name         VARCHAR2(64),
    surname      VARCHAR2(64),
    age          INTEGER,
    gender       VARCHAR2(1),
    email        VARCHAR2(64),
    phone_number VARCHAR2(64),
    address_id   INTEGER NOT NULL
);

CREATE UNIQUE INDEX customer__idx ON
    customers (
               address_id
               ASC);

ALTER TABLE customers
    ADD CONSTRAINT customer_pk PRIMARY KEY (id);

CREATE TABLE complaints
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY,
    "date"     DATE,
    text       VARCHAR2(512),
    booking_id INTEGER NOT NULL
);

ALTER TABLE complaints
    ADD CONSTRAINT complaints_pk PRIMARY KEY (id);

CREATE TABLE countries
(
    id   INTEGER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR2(64)
);

ALTER TABLE countries
    ADD CONSTRAINT country_pk PRIMARY KEY (id);

CREATE TABLE hotels
(
    id           INTEGER GENERATED ALWAYS AS IDENTITY,
    phone_number VARCHAR2(64),
    email        VARCHAR2(64),
    stars        INTEGER,
    address_id   INTEGER NOT NULL
);

CREATE UNIQUE INDEX hotel__idx ON
    hotels (
            address_id
            ASC);

ALTER TABLE hotels
    ADD CONSTRAINT hotel_pk PRIMARY KEY (id);

CREATE TABLE payments
(
    id         INTEGER,
    timestamp  DATE,
    amount     NUMBER(10, 2),
    booking_id INTEGER NOT NULL
);

CREATE TABLE ratings
(
    id          INTEGER GENERATED ALWAYS AS IDENTITY,
    "date"      DATE,
    star_rating INTEGER,
    text        VARCHAR2(512),
    booking_id  INTEGER NOT NULL UNIQUE
);

ALTER TABLE ratings
    ADD CONSTRAINT rating_pk PRIMARY KEY (id);
ALTER TABLE ratings
    ADD CONSTRAINT booking_id_unique UNIQUE (booking_id);

CREATE TABLE services
(
    id    INTEGER GENERATED ALWAYS AS IDENTITY,
    name  VARCHAR2(64),
    price NUMBER(10, 2)
);

ALTER TABLE services
    ADD CONSTRAINT services_pk PRIMARY KEY (id);

ALTER TABLE addresses
    ADD CONSTRAINT address_city_fk FOREIGN KEY (city_id)
        REFERENCES cities (id) ON DELETE CASCADE;

ALTER TABLE apartments
    ADD CONSTRAINT apartment_hotel_fk FOREIGN KEY (hotel_id)
        REFERENCES hotels (id) ON DELETE CASCADE;

ALTER TABLE bookings
    ADD CONSTRAINT booking_apartment_fk FOREIGN KEY (apartment_id)
        REFERENCES apartments (id) ON DELETE CASCADE;

ALTER TABLE bookings
    ADD CONSTRAINT booking_customer_fk FOREIGN KEY (customer_id)
        REFERENCES customers (id) ON DELETE CASCADE;

ALTER TABLE bookings_services
    ADD CONSTRAINT booking_services_booking_fk FOREIGN KEY (booking_id)
        REFERENCES bookings (id) ON DELETE CASCADE;

ALTER TABLE bookings_services
    ADD CONSTRAINT booking_services_services_fk FOREIGN KEY (services_id)
        REFERENCES services (id) ON DELETE CASCADE;

ALTER TABLE cities
    ADD CONSTRAINT city_country_fk FOREIGN KEY (country_id)
        REFERENCES countries (id) ON DELETE CASCADE;

ALTER TABLE customers
    ADD CONSTRAINT customer_address_fk FOREIGN KEY (address_id)
        REFERENCES addresses (id) ON DELETE CASCADE;

ALTER TABLE complaints
    ADD CONSTRAINT complaints_booking_fk FOREIGN KEY (booking_id)
        REFERENCES bookings (id) ON DELETE CASCADE;

ALTER TABLE hotels
    ADD CONSTRAINT hotel_address_fk FOREIGN KEY (address_id)
        REFERENCES addresses (id) ON DELETE CASCADE;

ALTER TABLE payments
    ADD CONSTRAINT payments_booking_fk FOREIGN KEY (booking_id)
        REFERENCES bookings (id) ON DELETE CASCADE;

ALTER TABLE ratings
    ADD CONSTRAINT rating_booking_fk FOREIGN KEY (booking_id)
        REFERENCES bookings (id) ON DELETE CASCADE;


CREATE VIEW balance AS
SELECT c.id AS customer_id, 'payment' AS item, p.amount AS amount
FROM customers c
         JOIN bookings b on c.id = b.customer_id
         JOIN payments p on b.id = p.booking_id
UNION
SELECT c.id AS customer_id, 'apartment' AS item, -PAYMENT_PROCESSING.CALCULATE_APARTMENT_BOOKING_COST(b.id) AS amount
FROM customers c
         JOIN bookings b on c.id = b.customer_id
UNION
SELECT c.id AS customer_id, s.name AS item, -s.price AS amount
FROM customers c
         JOIN bookings b on c.id = b.customer_id
         JOIN bookings_services bs on b.id = bs.booking_id
         JOIN services s on bs.services_id = s.id
