package org.example;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import static org.example.Common.printSeparator;

public class CustomerService {
    public static final String CUSTOMER_PRODUCTS_QUERY = "SELECT item, amount FROM balance WHERE customer_id = ?";
    private final Connection connection;

    public CustomerService(Connection connection) {
        this.connection = connection;
    }


    public List<Customer> getAllCustomers() throws SQLException {
        var query = connection.prepareStatement("SELECT * FROM CUSTOMERS");
        var resultSet = query.executeQuery();
        var customers = new LinkedList<Customer>();
        while (resultSet.next()) {
            customers.add(new Customer(
                    resultSet.getInt(1),
                    resultSet.getString(2),
                    resultSet.getString(3),
                    resultSet.getInt(4),
                    resultSet.getString(5),
                    resultSet.getString(6),
                    resultSet.getString(7),
                    resultSet.getInt(8)
            ));
        }
        return customers;
    }

    void showCustomers() throws SQLException {
        var customers = getAllCustomers();
        printSeparator();
        System.out.println("id\tname\tsurname\temail");
        customers.forEach(customer -> System.out.println(
                customer.id() + "\t" + customer.name() + "\t" + customer.surname() + "\t" + customer.email())
        );
        printSeparator();
    }

    public void showCustomerBalance(int customerId) throws SQLException {
        var products = getCustomerProducts(customerId);
        var total = getTotalBalance(products);
        var formatString = "%-16s\t%10.2f\n";
        printSeparator();
        System.out.format("%-16s\t%s\n", "Item", "Amount");
        products.forEach(product -> System.out.printf(formatString, product.name(), product.price()));
        System.out.printf("%-16s\t%10.2f\n", "Total:", total);
        printSeparator();
    }

    public List<Product> getCustomerProducts(int customerId) throws SQLException {
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
