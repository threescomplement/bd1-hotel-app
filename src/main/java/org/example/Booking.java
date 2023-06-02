package org.example;

import java.sql.Date;

public record Booking(int id, Date start, Date end, int nPeople, int customerId, int apartmentId) {
    public Booking(Date start, Date end, int nPeople, int customerId, int apartmentId) {
        this(0, start, end, nPeople, customerId, apartmentId);
    }
}
