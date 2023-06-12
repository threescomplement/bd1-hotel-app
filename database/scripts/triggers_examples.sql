-- trigger 1 - check for clash of bookings
BEGIN
    -- inserting a booking which does not clash with any other booking
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-06-06', 'YYYY-MM-DD'), TO_DATE('2023-06-11', 'YYYY-MM-DD'), 1, 2, 1);

    -- inserting another booking which clashes with the last one
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-06-06', 'YYYY-MM-DD'), TO_DATE('2023-06-11', 'YYYY-MM-DD'), 1, 2, 1);
END;

-- trigger 2 - trying to modify the address bound to a hotel
BEGIN
    UPDATE ADDRESSES SET STREET = 'new street' WHERE ID = 1;
END;


-- trigger 3 - enforce max_no_people
BEGIN
    -- inserting a booking where no_people = max_no_people
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-09-06', 'YYYY-MM-DD'), TO_DATE('2023-09-11', 'YYYY-MM-DD'), 4, 2, 1);
    -- modifying no_people to be grater than max_no_people in the previously made booking
    UPDATE BOOKINGS
    SET NO_PEOPLE = 5
    WHERE START_DATE = TO_DATE('2023-09-06', 'YYYY-MM-DD')
      AND END_DATE = TO_DATE('2023-09-11', 'YYYY-MM-DD')
      AND CUSTOMER_ID = 2
      AND APARTMENT_ID = 1;

    -- inserting a booking where no_people > max_no_people to violate the max number in the apt
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-10-06', 'YYYY-MM-DD'), TO_DATE('2023-10-11', 'YYYY-MM-DD'), 5, 2, 1);
END;


-- trigger 4 - inserting a booking with a customer id whose debt is > 2900
BEGIN
    INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID)
    VALUES (TO_DATE('2023-12-06', 'YYYY-MM-DD'), TO_DATE('2023-12-11', 'YYYY-MM-DD'), 1, 2, 1);
END;

