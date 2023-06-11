/*
Trigger checking whether an inserted/updated booking does not clash with another one, so
that there aren't two bookings for the same apt that overlap.
*/
CREATE OR REPLACE TRIGGER check_whether_apt_is_free
    BEFORE INSERT
    ON BOOKINGS
    FOR EACH ROW
DECLARE
    v_reservations number;
BEGIN
    SELECT COUNT(*)
    INTO v_reservations
    FROM BOOKINGS
    WHERE (APARTMENT_ID = :new.APARTMENT_ID
        AND ((:new.START_DATE <= END_DATE AND :new.start_date >= START_DATE)
            OR (:new.END_DATE >= START_DATE and :new.END_DATE <= END_DATE)))
      AND ID != :new.ID;
    IF v_reservations > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Apartment is already booked for this period');
    END IF;
END;


/*
Trigger checking whether a modified address is bound to a hotel. If it is, then it cannot be changed.
*/
CREATE OR REPLACE TRIGGER cant_change_hotel_address
    BEFORE UPDATE
    ON ADDRESSES
    FOR EACH ROW
DECLARE
    v_hotels number;
BEGIN
    SELECT COUNT(*) INTO v_hotels FROM HOTELS WHERE ADDRESS_ID = :old.ID;
    IF v_hotels > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Can''t change address bound to a hotel!');
    END IF;
end;


/*
Trigger checking whether the inserted/modified reservation does not violate the max number of people per
apartment.
*/
CREATE OR REPLACE TRIGGER check_max_people_per_apartment
    BEFORE INSERT OR UPDATE
    ON BOOKINGS
    FOR EACH ROW
    WHEN (new.NO_PEOPLE != old.NO_PEOPLE or new.ID != old.ID or old.ID IS NULL)
DECLARE
    v_max_people number;
BEGIN
    SELECT MAX_NO_PEOPLE INTO v_max_people FROM APARTMENTS WHERE ID = :new.APARTMENT_ID;
    IF v_max_people < :new.NO_PEOPLE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Too many people for this apartment! Max number of people is ' || v_max_people);
    END IF;
end;


/*
Trigger checking whether the customer making the reservation does not have too much debt (2900 PLN in this case).
If he does, then he cannot make a reservation.
*/
CREATE OR REPLACE TRIGGER check_customer_debt
    BEFORE INSERT
    ON BOOKINGS
    FOR EACH ROW
DECLARE
    v_balance           number;
    v_max_debt constant number := 2900;
BEGIN
    SELECT SUM(AMOUNT) INTO v_balance FROM BALANCE WHERE CUSTOMER_ID = :new.CUSTOMER_ID;
    IF v_balance < -v_max_debt THEN
        RAISE_APPLICATION_ERROR(-20003,
                                'Customer has too much debt! Max debt is ' || v_max_debt || '. Customer debt is ' ||
                                -v_balance || '.');
    END IF;
end;