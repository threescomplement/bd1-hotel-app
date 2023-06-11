
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
    DBMS_OUTPUT.PUT_LINE('first:');
    change_booking_period(1, TO_DATE('2021-09-01'), TO_DATE('2021-09-05'));
    DBMS_OUTPUT.PUT_LINE('second:');
    change_booking_period(2, TO_DATE('2023-09-02'), TO_DATE('2023-09-01'));
    DBMS_OUTPUT.PUT_LINE('third:');
    change_booking_period(100000, TO_DATE('2023-09-01'), TO_DATE('2023-09-01'));
    DBMS_OUTPUT.PUT_LINE('fourth:'); -- this is checked by a trigger
    change_booking_period(31, TO_DATE('2023-08-20'), TO_DATE('2023-09-02'));
end;