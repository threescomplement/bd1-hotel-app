package org.example;

import java.sql.Date;

public record Booking(int id, Date start, Date end, int nPeople, int customerId, int apartmentId) {
}