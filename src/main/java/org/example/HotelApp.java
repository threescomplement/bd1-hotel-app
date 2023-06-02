package org.example;

import oracle.jdbc.pool.OracleDataSource;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelApp {
    public static void main(String[] args) {
        try (var conn = getDbConnection()) {
            showCustomers(conn);
            showCustomerBalance(conn, 1);
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

    private static void printSeparator() {
        System.out.println("------------------------------");
    }

    private static void showCustomers(Connection conn) throws SQLException {
        PreparedStatement query = conn.prepareStatement("SELECT id, name, surname, email FROM customers");
        ResultSet customers = query.executeQuery();

        printSeparator();
        System.out.println("id\tname\tsurname\temail");
        while (customers.next()) {
            System.out.println(
                    customers.getString(1) + "\t"
                            + customers.getString(2) + "\t"
                            + customers.getString(3) + "\t"
                            + customers.getString(4) + "\t"
            );
        }
        printSeparator();
    }

    private static void showCustomerBalance(Connection conn, int customerId) throws SQLException {
        var products = getCustomerProducts(conn, customerId);
        var total = getTotalBalance(products);
        var formatString = "%-16s\t%10.2f\n";
        printSeparator();
        System.out.format("%-16s\t%s\n", "Item", "Amount");
        products.forEach(product -> System.out.printf(formatString, product.name(), product.price()));
        System.out.printf("%-16s\t%10.2f\n", "Total:", total);
        printSeparator();
    }

    private static List<Product> getCustomerProducts(Connection conn, int customerId) throws SQLException {
        var query = conn.prepareStatement("SELECT item, amount FROM balance WHERE customer_id = ?");
        query.setInt(1, customerId);
        var resultSet = query.executeQuery();
        var products = new ArrayList<Product>();

        while (resultSet.next()) {
            products.add(new Product(resultSet.getString(1), resultSet.getFloat(2)));
        }

        return products;
    }

    private static float getTotalBalance(List<Product> products) {
        return products.stream()
                .map(Product::price)
                .reduce(0.0f, Float::sum);
    }
}
