-- change_booking_period(id, start_date, end_date) - sprawdza czy istnieje taka rezerwacja, czy daty są w dobrej kolejności i czy nie nachodzi na inna tego samego pokoju
-- update_customer_contact_info(id, email, number) - sprawdza czy number jest poprawnej długości
-- add_service_to_booking(service_id, booking_id) - dodaje nowy wiersz w booking-services i sprawdza czy taki booking i servis istnieją

-- this procedure is used to update the dates of a booking, but only if that booking exists and also if
-- the apartment is available between the dates (identified by apartment_id)
create or replace procedure change_booking_period(booking_id BOOKINGS.ID%type, start_date Date, end_date DATE)
AS
    v_given_booking BOOKINGS%rowtype;
    cursor booking is (Select *
                       from BOOKINGS
                       where ID = booking_id);
Begin
    if (end_date < start_date) then
        raise INVALID_NUMBER;
    End if;
    open booking;
    fetch booking into v_given_booking;
    if booking%notfound then
        DBMS_OUTPUT.PUT_LINE('Booking not found!');
        return;
    end if;

    UPDATE BOOKINGS
    set START_DATE = start_date,
        END_DATE   = end_date
    where ID = booking_id;


Exception
    when
        INVALID_NUMBER then
        DBMS_OUTPUT.PUT_LINE('Invalid dates!');
end;/


create or replace procedure update_customer_contact_info(customer_id CUSTOMERS.ID%type, email CUSTOMERS.EMAIL%type,
                                                         p_number CUSTOMERS.PHONE_NUMBER%type)
AS
    v_given_customer CUSTOMERS%rowtype;
    cursor customer is (Select *
                        from CUSTOMERS
                        where ID = customer_id);
Begin
    fetch customer into v_given_customer;
    if customer%notfound then
        DBMS_OUTPUT.PUT_LINE('Customer not found!');
        return;
    end if;
    if p_number < 9 or p_number > 14 then
        DBMS_OUTPUT.PUT_LINE('Invalid number!');
        return;
    end if;

    UPDATE CUSTOMERS
    set EMAIL        = email,
        PHONE_NUMBER = p_number
    where ID = customer_id;
EXCEPtion
when others then
    DBMS_OUTPUT.PUT_LINE('Failed to update customer!');
end;/



create or replace procedure add_service_to_booking(service_id SERVICES.ID%type, booking_id BOOKINGS.ID%type)
AS
    v_given_service SERVICES%rowtype;
    v_given_booking BOOKINGS%rowtype;
    cursor service is (Select *
                       from SERVICES
                       where ID = service_id);
    cursor booking is (Select *
                       from BOOKINGS
                       where ID = booking_id);
begin
    fetch service into v_given_service;
    if service%notfound then
        DBMS_OUTPUT.PUT_LINE('Service not found!');
        return;
    end if;
    fetch booking into v_given_booking;
    if booking%notfound then
        DBMS_OUTPUT.PUT_LINE('Booking not found!');
        return;
    end if;
    INSERT into BOOKINGS_SERVICES VALUES (DEFAULT, service_id, booking_id);
EXCEPTION
    when others then
        DBMS_OUTPUT.PUT_LINE('Failed to add service!');
end;/



