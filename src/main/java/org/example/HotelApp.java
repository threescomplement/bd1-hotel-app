package org.example;

import oracle.jdbc.pool.OracleDataSource;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

public class HotelApp {
    public static void main(String[] args) {
        try (var conn = getDbConnection()) {
            System.out.println("Hello");
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

        var connectionString = String.format(
                "jdbc:oracle:thin:%s/%s@//%s:%s/%s",
                username, password, host, port, serviceName);

        var dataSource = new OracleDataSource();

        dataSource.setURL(connectionString);
        Connection connection = dataSource.getConnection();

        DatabaseMetaData meta = connection.getMetaData();
        System.out.println("Established connection with DB");
        System.out.println(meta.getDatabaseProductVersion());

        return connection;
    }
}
