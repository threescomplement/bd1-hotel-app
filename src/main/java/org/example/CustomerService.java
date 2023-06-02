package org.example;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.example.Common.printSeparator;

public class CustomerService {
    public static final String CUSTOMER_INFO_QUERY = "SELECT id, name, surname, email FROM customers";
    public static final String CUSTOMER_PRODUCTS_QUERY = "SELECT item, amount FROM balance WHERE customer_id = ?";
    private final Connection connection;

    public CustomerService(Connection connection) {
        this.connection = connection;
    }

    void showCustomers() throws SQLException {
        PreparedStatement query = connection.prepareStatement(CUSTOMER_INFO_QUERY);
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

    void showCustomerBalance(int customerId) throws SQLException {
        var products = getCustomerProducts(customerId);
        var total = getTotalBalance(products);
        var formatString = "%-16s\t%10.2f\n";
        printSeparator();
        System.out.format("%-16s\t%s\n", "Item", "Amount");
        products.forEach(product -> System.out.printf(formatString, product.name(), product.price()));
        System.out.printf("%-16s\t%10.2f\n", "Total:", total);
        printSeparator();
    }

    private List<Product> getCustomerProducts(int customerId) throws SQLException {
        var query = connection.prepareStatement(CUSTOMER_PRODUCTS_QUERY);
        query.setInt(1, customerId);
        var resultSet = query.executeQuery();
        var products = new ArrayList<Product>();

        while (resultSet.next()) {
            products.add(new Product(resultSet.getString(1), resultSet.getFloat(2)));
        }

        return products;
    }

    private float getTotalBalance(List<Product> products) {
        return products.stream()
                .map(Product::price)
                .reduce(0.0f, Float::sum);
    }
}
