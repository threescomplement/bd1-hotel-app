package org.example.services;

import org.example.model.Product;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.example.Common.printSeparator;

public class ProductService {
    public static final String ALL_PRODUCTS_QUERY = "SELECT * FROM SERVICES";
    public static final String ORDER_PRODUCT_QUERY = "INSERT INTO BOOKINGS_SERVICES (SERVICES_ID, BOOKING_ID) VALUES (?, ?)";
    private final Connection connection;

    public ProductService(Connection connection) {
        this.connection = connection;
    }

    public List<Product> getAllProducts() throws SQLException {
        var query = connection.prepareStatement(ALL_PRODUCTS_QUERY);
        var resultSet = query.executeQuery();
        List<Product> products = new ArrayList<>();
        while (resultSet.next()) {
            products.add(new Product(
                    resultSet.getInt(1),
                    resultSet.getString(2),
                    resultSet.getFloat(3)
            ));
        }
        return products;
    }

    public void orderProduct(int productId, int bookingId) throws SQLException {
        var query = connection.prepareStatement(ORDER_PRODUCT_QUERY);
        query.setInt(1, productId);
        query.setInt(2, bookingId);
        query.executeUpdate();
    }

    public void showProducts(List<Product> products) {
        printSeparator();
        products.forEach(p -> System.out.println(p.id() + ". " + p.name() + " $" + p.price()));
        printSeparator();
    }
}
