package org.example.model;

public record Product(int id, String name, float price) implements Entity {
    public Product(String name, float price) {
        this(-1, name, price);
    }
}
