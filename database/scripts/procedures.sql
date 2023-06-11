-- change_booking_period(id, start_date, end_date) - sprawdza czy istnieje taka rezerwacja, czy daty są w dobrej kolejności i czy nie nachodzi na inna tego samego pokoju
-- update_customer_contact_info(id, email, number) - sprawdza czy number jest poprawnej długości
-- add_service_to_booking(service_id, booking_id) - dodaje nowy wiersz w booking-services i sprawdza czy taki booking i servis istnieją

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
        close booking;
        return;
    end if;
    close booking;

    UPDATE BOOKINGS
    set START_DATE = start_date,
        END_DATE   = end_date
    where ID = booking_id;


Exception
    when
        INVALID_NUMBER then
        DBMS_OUTPUT.PUT_LINE('Invalid dates!');
end;/


create or replace procedure update_customer_contact_info(customer_id CUSTOMERS.ID%type, n_email CUSTOMERS.EMAIL%type,
                                                         p_number CUSTOMERS.PHONE_NUMBER%type)
AS
    v_given_customer CUSTOMERS%rowtype;
    cursor customer is (Select *
                        from CUSTOMERS
                        where ID = customer_id);
Begin
    open customer;
    fetch customer into v_given_customer;
    if customer%notfound then
        DBMS_OUTPUT.PUT_LINE('Customer not found!');
        close customer;
        return;
    end if;
    close customer;
    if p_number < 9 or p_number > 14 then
        DBMS_OUTPUT.PUT_LINE('Invalid number!');
        return;
    end if;

    UPDATE CUSTOMERS
    set EMAIL        = n_email,
        PHONE_NUMBER = p_number
    where ID = customer_id;
EXCEPtion
    when others then
        DBMS_OUTPUT.PUT_LINE('Failed to update customer!');
end;/



create or replace procedure add_service_to_booking(service_id SERVICES.ID%type, book_id BOOKINGS.ID%type)
AS
    v_given_service SERVICES%rowtype;
    v_given_booking BOOKINGS%rowtype;
    cursor service is (Select *
                       from SERVICES
                       where ID = service_id);
    cursor booking is (Select *
                       from BOOKINGS
                       where ID = book_id);
begin
    open service;
    fetch service into v_given_service;
    if service%notfound then
        DBMS_OUTPUT.PUT_LINE('Service not found!');
        close service;
        return;
    end if;
    close service;
    open booking;
    fetch booking into v_given_booking;
    if booking%notfound then
        DBMS_OUTPUT.PUT_LINE('Booking not found!');
        close booking;
        return;
    end if;
    close booking;
    for book_serv in (Select BOOKING_ID, SERVICES_ID from BOOKINGS_SERVICES)
        loop
            if book_serv.BOOKING_ID = book_id and book_serv.SERVICES_ID = service_id then
                DBMS_OUTPUT.PUT_LINE('Service already added!');
                return;
            end if;
        end loop;
    INSERT into BOOKINGS_SERVICES VALUES (Default, service_id, book_id);
EXCEPTION
    when others then
        DBMS_OUTPUT.PUT_LINE('Failed to add service!');
end;/



