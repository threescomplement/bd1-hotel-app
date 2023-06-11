
BEGIN
    add_service_to_booking(3, 1);
    add_service_to_booking(3, 1);
    add_service_to_booking(100000, 1);
    add_service_to_booking(1, 10000000);
end;

DELete
from BOOKINGS_SERVICES
where BOOKING_ID = 1
  and SERVICES_ID = 3;



BEGIN
    DBMS_OUTPUT.PUT_LINE('first:'); -- overlaps with booking 31
    change_booking_period(1, TO_DATE('2023-09-01'), TO_DATE('2023-09-05'));
    DBMS_OUTPUT.PUT_LINE('second:'); -- starts after it finishes
    change_booking_period(2, TO_DATE('2023-09-02'), TO_DATE('2023-09-01'));
    DBMS_OUTPUT.PUT_LINE('third:'); --unknown booking
    change_booking_period(100000, TO_DATE('2023-09-01'), TO_DATE('2023-09-01'));
    DBMS_OUTPUT.PUT_LINE('fourth:'); -- doesnt change anything
    change_booking_period(31, TO_DATE('2023-08-20'), TO_DATE('2023-09-02'));
end;/
commit;



UPDATE BOOKINGS
SET START_DATE = TO_DATE('2023-05-30', 'YYYY-MM-DD')
WHERE ID = 1;



Begin
    DBMS_OUTPUT.PUT_LINE('first:');
    UPDATE_CUSTOMER_CONTACT_INFO(1, 'mluszcz@gmail.com', '+48 213423456');
    DBMS_OUTPUT.PUT_LINE('second:');
    UPDATE_CUSTOMER_CONTACT_INFO(2, 'XXXXXXXXXXXXXXXXX', '+48 13');
    DBMS_OUTPUT.PUT_LINE('third:');
    UPDATE_CUSTOMER_CONTACT_INFO(100000, 'XXXXXXXXXXXXXXXXX', '+48 13');
    DBMS_OUTPUT.PUT_LINE('fourth:');
    UPDATE_CUSTOMER_CONTACT_INFO(2, 'XXXXXXXXXXXXXXXXX', '+48 139999999999999999999');
end;