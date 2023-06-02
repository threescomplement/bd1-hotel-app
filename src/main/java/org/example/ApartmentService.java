package org.example;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApartmentService {
    private final Connection connection;
    private static final String FREE_APARTMENTS_QUERY = """
            SELECT * FROM apartments a
            WHERE NOT EXISTS(
                            SELECT b.id FROM bookings b
                            WHERE b.APARTMENT_ID = a.ID
                            AND (
                            (b.START_DATE >= ? AND  b.START_DATE <= ? )
                            OR (b.END_DATE >= ? AND b.END_DATE <= ?))
                            )
            """;

    public ApartmentService(Connection connection) {
        this.connection = connection;
    }

    public List<Apartment> getAvailableApartments(Date from, Date to) throws SQLException {
        var query = connection.prepareStatement(FREE_APARTMENTS_QUERY);
        query.setDate(1, from);
        query.setDate(2, to);
        query.setDate(3, from);
        query.setDate(4, to);
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
}
