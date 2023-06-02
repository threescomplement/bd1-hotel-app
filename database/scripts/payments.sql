CREATE OR REPLACE PACKAGE payment_processing
AS
    FUNCTION calculate_apartment_booking_cost(p_booking_id bookings.id%TYPE) RETURN payments.amount%TYPE;
    FUNCTION calculate_total_cost(p_booking_id bookings.id%TYPE) RETURN payments.amount%TYPE;
    FUNCTION calculate_customer_balance(p_customer_id customers.id%TYPE) RETURN payments.amount%TYPE;
END;
/


create OR REPLACE package body payment_processing as
    FUNCTION calculate_total_cost(p_booking_id bookings.id%TYPE) RETURN payments.amount%TYPE
    AS
        v_total_amount  payments.amount%TYPE := 0;
        v_services_sum  payments.amount%TYPE;
    BEGIN

        v_total_amount := v_total_amount + calculate_apartment_booking_cost(p_booking_id);

        SELECT SUM(s.price)
        INTO v_services_sum
        FROM bookings b
                 JOIN BOOKINGS_SERVICES bs ON b.ID = bs.BOOKING_ID
                 JOIN SERVICES s ON bs.SERVICES_ID = s.ID
        WHERE b.id = p_booking_id
        GROUP BY b.id;
        v_total_amount := v_total_amount + v_services_sum;

        RETURN v_total_amount;

    END calculate_total_cost;

    FUNCTION calculate_customer_balance(p_customer_id customers.id%TYPE) RETURN payments.amount%TYPE
    AS
        v_total payments.amount%TYPE;
    BEGIN
        SELECT SUM(amount) INTO v_total FROM balance WHERE customer_id = p_customer_id;
        RETURN v_total;

    END calculate_customer_balance;


    FUNCTION calculate_apartment_booking_cost(p_booking_id bookings.id%TYPE) RETURN payments.amount%TYPE
    AS
        v_start         DATE;
        v_end           DATE;
        v_days          INTEGER;
        v_price_per_day apartments.price_per_day%TYPE;
    BEGIN
        SELECT b.start_date, b.end_date, a.PRICE_PER_DAY
        INTO v_start, v_end, v_price_per_day
        FROM bookings b
                 JOIN apartments a ON b.APARTMENT_ID = a.ID
        WHERE b.id = p_booking_id;

        v_days := v_end - v_start + 1;
        RETURN v_days * v_price_per_day;
    END calculate_apartment_booking_cost;

END payment_processing;
