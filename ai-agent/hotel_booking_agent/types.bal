public type Hotel record {
    string hotelId;
    string name;
    string location;
    string description;
    decimal pricePerNight;
    int availableRooms;
    string[] amenities;
    decimal rating;
};

public type BookingRequest record {
    string hotelId;
    string guestName;
    string guestEmail;
    string checkInDate;
    string checkOutDate;
    int numberOfGuests;
    int numberOfRooms;
};

public type Booking record {
    string bookingId;
    string hotelId;
    string guestName;
    string guestEmail;
    string checkInDate;
    string checkOutDate;
    int numberOfGuests;
    int numberOfRooms;
    decimal totalAmount;
    string status;
    string createdAt;
};

public type SearchCriteria record {
    string? location;
    string? checkInDate;
    string? checkOutDate;
    int? numberOfGuests;
    decimal? maxPrice;
    decimal? minRating;
};

public type ApiResponse record {
    boolean success;
    string message;
    anydata? data;
};

public type ErrorResponse record {
    boolean success;
    string message;
    string errorCode;
};