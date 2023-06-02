package org.example;

public record Apartment(int id, int nRooms, int nBathrooms, int nBeds, int maxPeople, int area, float pricePerDay,
                        int hotelId) {
}
