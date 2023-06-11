BEGIN
    -- inserting a booking which does not clash with any other booking
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-06-06', 'YYYY-MM-DD'), TO_DATE('2023-06-11', 'YYYY-MM-DD'), 1, 2, 1);

    -- inserting another booking which clashes with the last one
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-06-06', 'YYYY-MM-DD'), TO_DATE('2023-06-11', 'YYYY-MM-DD'), 1, 2, 1);

    -- updating a booking so that it does not clash with any other booking
    UPDATE BOOKINGS
    SET START_DATE = TO_DATE('2023-05-30', 'YYYY-MM-DD')
    WHERE ID = 1;

    -- inserting a booking that clashes with another one
    INSERT INTO BOOKINGS
    VALUES (6, 2023 - 06 - 10, 2023 - 06 - 17, 2, 2, 1);

    -- updating a booking so that it clashes with another one
    UPDATE BOOKINGS
    SET START_DATE = 2023 - 06 - 11
    WHERE ID = 5;
END;


-- trigger 2 - trying to modify the address bound to a hotel
-- trigger 2 - modifying an address not bound to a hotel


-- trigger 3 - inserting a reservation where no_people = max_no_people
-- trigger 3 - modifying no_people to be grater than max_no_people
-- trigger 3 - inserting a reservation where no_people > max_no_people to violate the max number in the apt


-- trigger 4 - inserting a booking where a customer has an ok balance
-- trigger 4 - inserting a booking the customer of which has too much debt
-- trigger 4 - modifying the customer_id of a booking to a customer that has too much debt