package org.example.services;

import org.example.model.Booking;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.example.Common.printSeparator;

public class BookingService {
    public static final String INSERT_BOOKING_QUERY = "INSERT INTO BOOKINGS (START_DATE, END_DATE, NO_PEOPLE, CUSTOMER_ID, APARTMENT_ID) VALUES (?, ?, ?, ?, ?)";
    public static final String CUSTOMER_BOOKINGS_QUERY = "SELECT * FROM BOOKINGS WHERE CUSTOMER_ID = ?";
    public static final String UPDATE_BOOKING_DATES_QUERY = "UPDATE BOOKINGS SET START_DATE = ?, END_DATE = ? WHERE ID = ?";
    private final Connection connection;

    public BookingService(Connection connection) {
        this.connection = connection;
    }

    public void makeReservation(Booking booking) throws SQLException {
        var query = connection.prepareStatement(INSERT_BOOKING_QUERY);
        query.setDate(1, booking.start());
        query.setDate(2, booking.end());
        query.setInt(3, booking.nPeople());
        query.setInt(4, booking.customerId());
        query.setInt(5, booking.apartmentId());
        query.executeUpdate();
    }

    public void showBookings(List<Booking> bookings) {
        printSeparator();
        bookings.forEach(b -> System.out.println(
                b.id() + ". from " + b.start().toString() + " to " + b.end().toString())
        );
        printSeparator();
    }

    public List<Booking> getCustomerBookings(int customerId) throws SQLException {
        var query = connection.prepareStatement(CUSTOMER_BOOKINGS_QUERY);
        query.setInt(1, customerId);
        var resultSet = query.executeQuery();
        List<Booking> bookings = new ArrayList<>();

        while (resultSet.next()) {
            bookings.add(new Booking(
                    resultSet.getInt(1),
                    resultSet.getDate(2),
                    resultSet.getDate(3),
                    resultSet.getInt(4),
                    resultSet.getInt(5),
                    resultSet.getInt(6)
            ));
        }
        return bookings;
    }

    public void changeBookingDate(int bookingId, Date from, Date to) throws SQLException {
        var query = connection.prepareStatement(UPDATE_BOOKING_DATES_QUERY);
        query.setDate(1, from);
        query.setDate(2, to);
        query.setInt(3, bookingId);
        query.executeUpdate();
    }

    public void cancelBooking(int bookingId) throws SQLException {
        var query = connection.prepareStatement("DELETE FROM BOOKINGS WHERE ID = ?");
        query.setInt(1, bookingId);
        query.executeUpdate();
    }
}
