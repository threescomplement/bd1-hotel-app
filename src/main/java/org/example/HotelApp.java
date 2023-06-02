package org.example;

import oracle.jdbc.pool.OracleDataSource;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import java.sql.*;

import static org.example.Common.printSeparator;

public class HotelApp {
    public static void main(String[] args) {
        try (var conn = getDbConnection()) {
            var customerService = new CustomerService(conn);
            var apartmentService = new ApartmentService(conn);
            var bookingService = new BookingService(conn);
            var productService = new ProductService(conn);

            customerService.showCustomers();
            customerService.showCustomerBalance(1);

            System.out.println("Free apartments in New York");
            var freeApartments = apartmentService.getAvailableApartments(Date.valueOf("2024-06-14"), Date.valueOf("2024-06-15"), "new york");
            freeApartments.forEach(System.out::println);

            System.out.println("All free apartments");
            freeApartments = apartmentService.getAvailableApartments(Date.valueOf("2024-06-14"), Date.valueOf("2024-06-15"));
            freeApartments.forEach(System.out::println);

            bookingService.bookRoom(new Booking(Date.valueOf("2024-06-10"), Date.valueOf("2024-06-30"), 1, 1, 1));

            printSeparator();
            System.out.println("Bookings for customer 1");
            bookingService.getCustomerBookings(1).forEach(System.out::println);

            productService.orderProduct(1, 1);

            printSeparator();
            System.out.println("All products");
            productService.getAllProducts().forEach(System.out::println);


        } catch (SQLException | ConfigurationException e) {
            e.printStackTrace();
        }
    }

    private static PropertiesConfiguration getDbProperties() throws ConfigurationException {
        return new PropertiesConfiguration("db.properties");
    }

    private static Connection getDbConnection() throws ConfigurationException, SQLException {
        var properties = getDbProperties();
        var host = properties.getString("jdbc.host");
        var username = properties.getString("jdbc.username");
        var password = properties.getString("jdbc.password");
        var port = properties.getString("jdbc.port");
        var serviceName = properties.getString("jdbc.service.name");

        var connectionString = String.format("jdbc:oracle:thin:%s/%s@//%s:%s/%s", username, password, host, port, serviceName);

        var dataSource = new OracleDataSource();

        dataSource.setURL(connectionString);
        Connection connection = dataSource.getConnection();

        DatabaseMetaData meta = connection.getMetaData();
        System.out.println("Established connection with DB");
        System.out.println(meta.getDatabaseProductVersion());

        return connection;
    }

}
