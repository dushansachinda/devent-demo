import ballerina/uuid;
import ballerina/time;

// Sample hotel data - in real implementation, this would come from a database
Hotel[] hotelDatabase = [
    {
        hotelId: "hotel_001",
        name: "Grand Plaza Hotel",
        location: "New York",
        description: "Luxury hotel in the heart of Manhattan",
        pricePerNight: 299.99,
        availableRooms: 25,
        amenities: ["WiFi", "Pool", "Gym", "Restaurant", "Spa"],
        rating: 4.5
    },
    {
        hotelId: "hotel_002",
        name: "Seaside Resort",
        location: "Miami",
        description: "Beautiful beachfront resort with ocean views",
        pricePerNight: 199.99,
        availableRooms: 15,
        amenities: ["WiFi", "Beach Access", "Pool", "Restaurant"],
        rating: 4.2
    },
    {
        hotelId: "hotel_003",
        name: "Mountain View Lodge",
        location: "Denver",
        description: "Cozy lodge with stunning mountain views",
        pricePerNight: 149.99,
        availableRooms: 8,
        amenities: ["WiFi", "Fireplace", "Hiking Trails", "Restaurant"],
        rating: 4.0
    }
];

Booking[] bookingDatabase = [];

public function searchHotels(SearchCriteria searchCriteria) returns Hotel[] {
    Hotel[] filteredHotels = [];
    
    foreach Hotel hotel in hotelDatabase {
        boolean matchesLocation = searchCriteria.location is () || 
            hotel.location.toLowerAscii().includes((<string>searchCriteria.location).toLowerAscii());
        
        boolean matchesPrice = searchCriteria.maxPrice is () || 
            hotel.pricePerNight <= <decimal>searchCriteria.maxPrice;
        
        boolean matchesRating = searchCriteria.minRating is () || 
            hotel.rating >= <decimal>searchCriteria.minRating;
        
        if matchesLocation && matchesPrice && matchesRating {
            filteredHotels.push(hotel);
        }
    }
    
    return filteredHotels;
}

public function getHotelById(string hotelId) returns Hotel? {
    foreach Hotel hotel in hotelDatabase {
        if hotel.hotelId == hotelId {
            return hotel;
        }
    }
    return ();
}

public function createBooking(BookingRequest bookingRequest) returns Booking|error {
    Hotel? hotel = getHotelById(bookingRequest.hotelId);
    
    if hotel is () {
        return error("Hotel not found");
    }
    
    if hotel.availableRooms < bookingRequest.numberOfRooms {
        return error("Insufficient rooms available");
    }
    
    string bookingId = uuid:createType1AsString();
    time:Utc currentTime = time:utcNow();
    string createdAt = time:utcToString(currentTime);
    
    // Calculate total amount (simplified calculation)
    decimal totalAmount = hotel.pricePerNight * bookingRequest.numberOfRooms;
    
    Booking newBooking = {
        bookingId: bookingId,
        hotelId: bookingRequest.hotelId,
        guestName: bookingRequest.guestName,
        guestEmail: bookingRequest.guestEmail,
        checkInDate: bookingRequest.checkInDate,
        checkOutDate: bookingRequest.checkOutDate,
        numberOfGuests: bookingRequest.numberOfGuests,
        numberOfRooms: bookingRequest.numberOfRooms,
        totalAmount: totalAmount,
        status: "confirmed",
        createdAt: createdAt
    };
    
    bookingDatabase.push(newBooking);
    
    // Update available rooms
    hotel.availableRooms = hotel.availableRooms - bookingRequest.numberOfRooms;
    
    return newBooking;
}

public function getBookingById(string bookingId) returns Booking? {
    foreach Booking booking in bookingDatabase {
        if booking.bookingId == bookingId {
            return booking;
        }
    }
    return ();
}

public function getAllBookings() returns Booking[] {
    return bookingDatabase;
}

public function cancelBooking(string bookingId) returns boolean {
    foreach int i in 0..<bookingDatabase.length() {
        if bookingDatabase[i].bookingId == bookingId {
            Booking booking = bookingDatabase[i];
            booking.status = "cancelled";
            
            // Restore available rooms
            Hotel? hotel = getHotelById(booking.hotelId);
            if hotel is Hotel {
                hotel.availableRooms = hotel.availableRooms + booking.numberOfRooms;
            }
            
            return true;
        }
    }
    return false;
}