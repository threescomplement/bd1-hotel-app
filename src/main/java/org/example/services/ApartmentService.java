package org.example.services;

import org.example.model.Apartment;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.example.Common.printSeparator;

public class ApartmentService {
    private static final String FREE_APARTMENTS_QUERY = """
            SELECT *
            FROM apartments apt
            JOIN HOTELS h on h.ID = apt.HOTEL_ID
            JOIN ADDRESSES addr on addr.ID = h.ADDRESS_ID
            JOIN CITIES c on c.ID = addr.CITY_ID
            WHERE LOWER(c.name) LIKE ? AND NOT EXISTS(
                            SELECT b.id FROM bookings b
                            WHERE b.APARTMENT_ID = apt.ID
                            AND (
                            (b.START_DATE >= ? AND  b.START_DATE <= ? )
                            OR (b.END_DATE >= ? AND b.END_DATE <= ?))
                            )
            """;
    private final Connection connection;

    public ApartmentService(Connection connection) {
        this.connection = connection;
    }

    public List<Apartment> getAvailableApartments(Date from, Date to, String city) throws SQLException {
        var query = connection.prepareStatement(FREE_APARTMENTS_QUERY);
        query.setString(1, "%" + city.toLowerCase() + "%");
        query.setDate(2, from);
        query.setDate(3, to);
        query.setDate(4, from);
        query.setDate(5, to);
        var resultSet = query.executeQuery();
        List<Apartment> apartments = new ArrayList<>();

        while (resultSet.next()) {
            apartments.add(new Apartment(
                    resultSet.getInt(1),
                    resultSet.getInt(2),
                    resultSet.getInt(3),
                    resultSet.getInt(4),
                    resultSet.getInt(5),
                    resultSet.getInt(6),
                    resultSet.getFloat(7),
                    resultSet.getInt(8)
            ));
        }

        return apartments;
    }

    public void showApartments(List<Apartment> apartments) {
        printSeparator();
        apartments.forEach(apt -> System.out.println(
                apt.id() + ". with " + apt.nRooms() + " rooms, $" + apt.pricePerDay() + " per day"
        ));
        printSeparator();
    }

    public List<Apartment> getAvailableApartments(Date from, Date to) throws SQLException {
        return getAvailableApartments(from, to, "");
    }
}
