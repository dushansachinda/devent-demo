import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerinax/ai;

service /api/v1 on new http:Listener(servicePort) {

    // Search hotels
    resource function get hotels(string? location, string? checkInDate,
            string? checkOutDate, int? numberOfGuests,
            decimal? maxPrice, decimal? minRating) returns ApiResponse {

        SearchCriteria searchCriteria = {
            location: location,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfGuests: numberOfGuests,
            maxPrice: maxPrice,
            minRating: minRating
        };

        Hotel[] hotels = searchHotels(searchCriteria);

        return {
            success: true,
            message: "Hotels retrieved successfully",
            data: hotels
        };
    }

    // Get specific hotel details
    resource function get hotels/[string hotelId]() returns ApiResponse|ErrorResponse {
        Hotel? hotel = getHotelById(hotelId);

        if hotel is () {
            return {
                success: false,
                message: "Hotel not found",
                errorCode: "HOTEL_NOT_FOUND"
            };
        }

        return {
            success: true,
            message: "Hotel details retrieved successfully",
            data: hotel
        };
    }

    // Create a new booking
    resource function post bookings(@http:Payload BookingRequest bookingRequest) returns ApiResponse|ErrorResponse {
        Booking|error bookingResult = createBooking(bookingRequest);

        if bookingResult is error {
            log:printError("Booking creation failed", bookingResult);
            return {
                success: false,
                message: bookingResult.message(),
                errorCode: "BOOKING_FAILED"
            };
        }

        return {
            success: true,
            message: "Booking created successfully",
            data: bookingResult
        };
    }

    // Get specific booking details
    resource function get bookings/[string bookingId]() returns ApiResponse|ErrorResponse {
        Booking? booking = getBookingById(bookingId);

        if booking is () {
            return {
                success: false,
                message: "Booking not found",
                errorCode: "BOOKING_NOT_FOUND"
            };
        }

        return {
            success: true,
            message: "Booking details retrieved successfully",
            data: booking
        };
    }

    // Get all bookings
    resource function get bookings() returns ApiResponse {
        Booking[] bookings = getAllBookings();

        return {
            success: true,
            message: "All bookings retrieved successfully",
            data: bookings
        };
    }

    // Cancel a booking
    resource function delete bookings/[string bookingId]() returns ApiResponse|ErrorResponse {
        boolean cancelled = cancelBooking(bookingId);

        if !cancelled {
            return {
                success: false,
                message: "Booking not found or already cancelled",
                errorCode: "CANCELLATION_FAILED"
            };
        }

        return {
            success: true,
            message: "Booking cancelled successfully",
            data: ()
        };
    }

    // Health check endpoint
    resource function get health() returns ApiResponse {
        return {
            success: true,
            message: "Hotel Booking Service is running",
            data: {
                status: "healthy",
                version: apiVersion,
                timestamp: time:utcToString(time:utcNow())
            }
        };
    }
}

listener ai:Listener BookingAiAgentListener = new (listenOn = check http:getDefaultListener());

service /BookingAiAgent on BookingAiAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check bookingAiAgent->run(request.message);
        return {message: stringResult};
    }
}