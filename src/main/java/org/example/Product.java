package org.example;

public record Product(int id, String name, float price) {
    public Product(String name, float price) {
        this(-1, name, price);
    }
}
