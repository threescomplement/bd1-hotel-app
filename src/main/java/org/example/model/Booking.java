package org.example.model;

import java.sql.Date;

public record Booking(int id, Date start, Date end, int nPeople, int customerId, int apartmentId) implements Entity {
    public Booking(Date start, Date end, int nPeople, int customerId, int apartmentId) {
        this(-1, start, end, nPeople, customerId, apartmentId);
    }
}
