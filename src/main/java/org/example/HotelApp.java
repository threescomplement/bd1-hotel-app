package org.example;

import oracle.jdbc.pool.OracleDataSource;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import java.sql.*;

public class HotelApp {
    public static void main(String[] args) {
        try (var conn = getDbConnection()) {
            showCustomers(conn);
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

    private static void showCustomers(Connection conn) throws SQLException {
        PreparedStatement query = conn.prepareStatement("SELECT id, name, surname, email FROM customers");
        ResultSet customers = query.executeQuery();
        System.out.println("id\tname\tsurname\temail");
        while (customers.next()) {
            System.out.println(
                    customers.getString(1) + "\t"
                            + customers.getString(2) + "\t"
                            + customers.getString(3) + "\t"
                            + customers.getString(4) + "\t"
            );
        }
    }
}
