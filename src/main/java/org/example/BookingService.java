package org.example;

import java.sql.Connection;
import java.sql.SQLException;

public class BookingService {
    public static final String INSERT_BOOKING_QUERY = "INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID) VALUES (?, ?, ?, ?, ?)";
    private final Connection connection;

    public BookingService(Connection connection) {
        this.connection = connection;
    }

    public void bookRoom(Booking booking) throws SQLException {
        var query = connection.prepareStatement(INSERT_BOOKING_QUERY);
        query.setDate(1, booking.start());
        query.setDate(2, booking.end());
        query.setInt(3, booking.nPeople());
        query.setInt(4, booking.customerId());
        query.setInt(5, booking.apartmentId());
        query.executeUpdate();
    }
}
