-- change_booking_period(id, start_date, end_date) - sprawdza czy istnieje taka rezerwacja, czy daty są w dobrej kolejności i czy nie nachodzi na inna tego samego pokoju
-- update_customer_contact_info(id, email, number) - sprawdza czy number jest poprawnej długości
-- add_service_to_booking(service_id, booking_id) - dodaje nowy wiersz w booking-services i sprawdza czy taki booking i servis istnieją

-- this procedure is used to update the dates of a booking, but only if that booking exists and also if
-- the apartment is available between the dates (identified by apartment_id)
create or replace procedure change_booking_period(booking_id BOOKINGS.ID%type, start_date Date, end_date DATE)
AS
    v_given_booking BOOKINGS%rowtype;
    cursor booking is (Select * from BOOKINGS where ID = booking_id);
Begin
    if (end_date < start_date) then
        raise INVALID_NUMBER;
    End if;
    open booking;
    fetch booking into v_given_booking;
    if  booking%notfound then
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
end;