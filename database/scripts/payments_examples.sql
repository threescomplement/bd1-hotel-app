
-- calculate_apartment_booking_cost function
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total cost of booking with id 1 is ' ||
                         PAYMENT_PROCESSING.CALCULATE_APARTMENT_BOOKING_COST(1) || 'PLN.');
end;


-- calculate_total_cost (including extra services)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total cost of booking with id 1 is ' ||
                         PAYMENT_PROCESSING.CALCULATE_TOTAL_COST(1) || 'PLN.');
end;


-- calculate_customer_balance function which sums up all of his payments and spendings
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total balance of customer with id 1 is ' ||
                         PAYMENT_PROCESSING.CALCULATE_CUSTOMER_BALANCE(1) || 'PLN.');
end;