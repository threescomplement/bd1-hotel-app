package org.example.model;

public record Customer(int id, String name, String surname, int age, String gender, String email, String phoneNumber, int addressId) implements Entity {

}
