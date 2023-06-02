package org.example;

import oracle.jdbc.pool.OracleDataSource;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import java.sql.*;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Pattern;


public class HotelApp {

    public static final String DATE_PATTERN = "\\d{4}-\\d{2}-\\d{2}";

    public static void main(String[] args) {
        try (var conn = getDbConnection()) {
            var customerService = new CustomerService(conn);
            var apartmentService = new ApartmentService(conn);
            var bookingService = new BookingService(conn);
            var productService = new ProductService(conn);

            var customers = customerService.getAllCustomers();
            customerService.showCustomers();
            System.out.println("Select customer");
            Scanner in = new Scanner(System.in);
            var customer = selectById(customers, in.nextInt());

            System.out.println(customer);
            var quit = false;
            while (!quit) {
                System.out.println("What do you want to do?");
                System.out.println("1. Show customer's active bookings");
                System.out.println("2. Book room");
                System.out.println("3. Change booking date");
                System.out.println("4. Cancel booking");
                System.out.println("5. Order extra service");
                System.out.println("6. Show customer's balance");
                System.out.println("7. Exit");

                var option = in.nextInt();

                switch (option) {
                    case 1 -> handleShowBookings(bookingService, customer);
                    case 2 -> handleBookApartment(apartmentService, bookingService, in, customer);
                    case 3 -> handleChangeDate(bookingService, in, customer);
                    case 4 -> handleCancelBooking(bookingService, in, customer);
                    case 5 -> handleOrderService(bookingService, productService, in, customer);
                    case 6 -> handleShowBalance(customer, customerService);
                    case 7 -> quit = true;
                    default -> System.out.println("Invalid choice");
                }
            }

        } catch (SQLException | ConfigurationException e) {
            e.printStackTrace();
        }
    }

    private static void handleShowBalance(Customer customer, CustomerService customerService) throws SQLException {
        customerService.showCustomerBalance(customer.id());
    }

    private static void handleOrderService(BookingService bookingService, ProductService productService, Scanner in, Customer customer) throws SQLException {
        var bookings = bookingService.getCustomerBookings(customer.id());
        System.out.println("Choose your reservation");
        bookingService.showBookings(bookings);
        var booking = selectById(bookings, in.nextInt());

        var services = productService.getAllProducts();
        System.out.println("Which extra service would you like to order?");
        productService.showProducts(services);
        var service = selectById(services, in.nextInt());

        productService.orderProduct(service.id(), booking.id());
        System.out.println("Ordered successfully");
    }

    private static void handleCancelBooking(BookingService bookingService, Scanner in, Customer customer) throws SQLException {
        var bookings = bookingService.getCustomerBookings(customer.id());
        System.out.println("Which reservation would you like to cancel?");
        bookingService.showBookings(bookings);
        var booking = selectById(bookings, in.nextInt());

        bookingService.cancelBooking(booking.id());
        System.out.println("Cancelled successfully");
    }

    private static void handleChangeDate(BookingService bookingService, Scanner in, Customer customer) throws SQLException {
        System.out.println("For which reservation?");
        var bookings = bookingService.getCustomerBookings(customer.id());
        bookingService.showBookings(bookings);
        var booking = selectById(bookings, in.nextInt());

        System.out.println("New start date (yyyy-mm-dd): ");
        var from = readDate(in);
        System.out.println("New end date (yyyy-mm-dd): ");
        var to = readDate(in);

        bookingService.changeBookingDate(booking.id(), from, to);
        System.out.println("Updated reservation");
    }

    private static void handleBookApartment(ApartmentService apartmentService, BookingService bookingService, Scanner in, Customer customer) throws SQLException {
        System.out.println("For what period?");
        System.out.println("From (yyyy-mm-dd): ");
        var from = readDate(in);
        System.out.println("To (yyyy-mm-dd): ");
        var to = readDate(in);
        System.out.println("Where (city name): ");
        in.nextLine();  // Do not read newline as new input
        var city = in.nextLine();

        System.out.println("Apartments available:");
        var apartments = apartmentService.getAvailableApartments(from, to, city);
        apartmentService.showApartments(apartments);

        System.out.println("Which would you like to choose?");
        var apartment = selectById(apartments, in.nextInt());

        var booking = new Booking(from, to, 1, customer.id(), apartment.id());
        bookingService.makeReservation(booking);
        System.out.println("Reservation complete.");
    }

    private static void handleShowBookings(BookingService bookingService, Customer customer) throws SQLException {
        var bookings = bookingService.getCustomerBookings(customer.id());
        bookingService.showBookings(bookings);
    }

    private static Date readDate(Scanner in) {
        return Date.valueOf(in.next(Pattern.compile(DATE_PATTERN)));
    }

    private static <T extends Entity> T selectById(List<T> entities, int id) {
        return entities.stream()
                .filter(e -> e.id() == id)
                .findFirst()
                .orElseThrow();
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
