import ballerina/http;
import ballerinax/ai;

configurable string serviceUrl = "http://localhost:8080";

# Search hotels with optional filters like location, dates, price range, and rating
#
# + location - Location to search for hotels
# + checkInDate - Check-in date in YYYY-MM-DD format
# + checkOutDate - Check-out date in YYYY-MM-DD format  
# + numberOfGuests - Number of guests
# + maxPrice - Maximum price per night
# + minRating - Minimum hotel rating
# + return - List of hotels matching the criteria or error
@ai:AgentTool
@display {
    label: "Search Hotels",
    iconPath: ""
}
isolated function _searchHotels(string? location = (), string? checkInDate = (), 
        string? checkOutDate = (), int? numberOfGuests = (), 
        decimal? maxPrice = (), decimal? minRating = ()) returns ApiResponse|error {
    
    http:Client httpClient = check new (serviceUrl);
    
    string queryParams = "";
    string[] params = [];
    
    if location is string {
        params.push("location=" + location);
    }
    if checkInDate is string {
        params.push("checkInDate=" + checkInDate);
    }
    if checkOutDate is string {
        params.push("checkOutDate=" + checkOutDate);
    }
    if numberOfGuests is int {
        params.push("numberOfGuests=" + numberOfGuests.toString());
    }
    if maxPrice is decimal {
        params.push("maxPrice=" + maxPrice.toString());
    }
    if minRating is decimal {
        params.push("minRating=" + minRating.toString());
    }
    
    if params.length() > 0 {
        queryParams = "?" + string:'join("&", ...params);
    }
    
    ApiResponse response = check httpClient->get("/api/v1/hotels" + queryParams);
    return response;
}

# Get detailed information about a specific hotel by its ID
#
# + hotelId - Unique identifier of the hotel
# + return - Hotel details or error response
@ai:AgentTool
@display {
    label: "Get Hotel Details",
    iconPath: ""
}
isolated function _getHotelById(string hotelId) returns ApiResponse|ErrorResponse|error {
    http:Client httpClient = check new (serviceUrl);
    ApiResponse|ErrorResponse response = check httpClient->get("/api/v1/hotels/" + hotelId);
    return response;
}

# Create a new hotel booking
#
# + hotelId - ID of the hotel to book
# + guestName - Name of the guest making the booking
# + guestEmail - Email address of the guest
# + checkInDate - Check-in date in YYYY-MM-DD format
# + checkOutDate - Check-out date in YYYY-MM-DD format
# + numberOfGuests - Number of guests for the booking
# + numberOfRooms - Number of rooms to book
# + return - Booking confirmation details or error
@ai:AgentTool
@display {
    label: "Create Hotel Booking",
    iconPath: ""
}
isolated function _createBooking(string hotelId, string guestName, string guestEmail,
        string checkInDate, string checkOutDate, int numberOfGuests, 
        int numberOfRooms) returns ApiResponse|ErrorResponse|error {
    
    http:Client httpClient = check new (serviceUrl);
    
    BookingRequest bookingRequest = {
        hotelId: hotelId,
        guestName: guestName,
        guestEmail: guestEmail,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        numberOfGuests: numberOfGuests,
        numberOfRooms: numberOfRooms
    };
    
    ApiResponse|ErrorResponse response = check httpClient->post("/api/v1/bookings", bookingRequest);
    return response;
}

# Get details of a specific booking by its ID
#
# + bookingId - Unique identifier of the booking
# + return - Booking details or error response
@ai:AgentTool
@display {
    label: "Get Booking Details",
    iconPath: ""
}
isolated function _getBookingById(string bookingId) returns ApiResponse|ErrorResponse|error {
    http:Client httpClient = check new (serviceUrl);
    ApiResponse|ErrorResponse response = check httpClient->get("/api/v1/bookings/" + bookingId);
    return response;
}

# Retrieve all bookings in the system
#
# + return - List of all bookings or error
@ai:AgentTool
@display {
    label: "Get All Bookings",
    iconPath: ""
}
isolated function _getAllBookings() returns ApiResponse|error {
    http:Client httpClient = check new (serviceUrl);
    ApiResponse response = check httpClient->get("/api/v1/bookings");
    return response;
}

# Cancel an existing booking by its ID
#
# + bookingId - Unique identifier of the booking to cancel
# + return - Cancellation confirmation or error response
@ai:AgentTool
@display {
    label: "Cancel Booking",
    iconPath: ""
}
isolated function _cancelBooking(string bookingId) returns ApiResponse|ErrorResponse|error {
    http:Client httpClient = check new (serviceUrl);
    ApiResponse|ErrorResponse response = check httpClient->delete("/api/v1/bookings/" + bookingId);
    return response;
}

# Check the health status of the hotel booking service
#
# + return - Service health status or error
@ai:AgentTool
@display {
    label: "Check Service Health",
    iconPath: ""
}
isolated function _getHealthStatus() returns ApiResponse|error {
    http:Client httpClient = check new (serviceUrl);
    ApiResponse response = check httpClient->get("/api/v1/health");
    return response;
}

# Search hotels by location only (convenience function)
#
# + location - Location to search for hotels
# + return - List of hotels in the specified location or error
@ai:AgentTool
@display {
    label: "Search Hotels by Location",
    iconPath: ""
}
isolated function _searchHotelsByLocation(string location) returns ApiResponse|error {
    return _searchHotels(location = location);
}

# Search hotels within a specific price range
#
# + maxPrice - Maximum price per night
# + minRating - Minimum hotel rating (optional)
# + return - List of hotels within price range or error
@ai:AgentTool
@display {
    label: "Search Hotels by Price Range",
    iconPath: ""
}
isolated function _searchHotelsByPriceRange(decimal maxPrice, decimal? minRating = ()) returns ApiResponse|error {
    return _searchHotels(maxPrice = maxPrice, minRating = minRating);
}

# Search hotels by minimum rating
#
# + minRating - Minimum hotel rating required
# + return - List of hotels with specified minimum rating or error
@ai:AgentTool
@display {
    label: "Search Hotels by Rating",
    iconPath: ""
}
isolated function _searchHotelsByRating(decimal minRating) returns ApiResponse|error {
    return _searchHotels(minRating = minRating);
}

# Create a simple booking with default values for single guest and room
#
# + hotelId - ID of the hotel to book
# + guestName - Name of the guest making the booking
# + guestEmail - Email address of the guest
# + checkInDate - Check-in date in YYYY-MM-DD format
# + checkOutDate - Check-out date in YYYY-MM-DD format
# + return - Booking confirmation details or error
@ai:AgentTool
@display {
    label: "Create Simple Booking",
    iconPath: ""
}
isolated function _createSimpleBooking(string hotelId, string guestName, string guestEmail,
        string checkInDate, string checkOutDate) returns ApiResponse|ErrorResponse|error {
    
    return _createBooking(hotelId, guestName, guestEmail, checkInDate, checkOutDate, 1, 1);
}
