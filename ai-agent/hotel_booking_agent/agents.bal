// This file can be used for future agent-related functionality
// Currently empty as chat interfaces are removed

// import ballerinax/ai;

// final ai:OpenAiProvider _bookingAiAgentModel = check new (apikey, "gpt-4o-2024-08-06");
// final ai:Agent _bookingAiAgentagentAgent = check new (
//     systemPrompt = {role: "Hotel Booking Assistant", instructions: string `You are a Hotel booking management assistant, designed to guide hotel through each step of the hotel booking process, asking relevant questions to ensure orders are handled accurately and efficiently.`}, model = _bookingAiAgentModel, tools = []
// );



import ballerinax/ai;

final ai:OpenAiProvider bookingAiAgentModel = check new (apikey, "gpt-4o-2024-08-06");
final ai:Agent bookingAiAgent = check new (
    systemPrompt = {
        role: "Hotel Booking Assistant", 
        instructions: string `You are a Hotel booking management assistant, designed to guide customers through each step of the hotel booking process. You can help with:
        
        1. Searching for hotels by location, price range, rating, and dates
        2. Getting detailed information about specific hotels
        3. Creating new bookings for customers
        4. Retrieving booking details and managing existing reservations
        5. Canceling bookings when needed
        
        Always ask relevant questions to ensure bookings are handled accurately and efficiently. When creating bookings, make sure to collect all required information: hotel ID, guest name, email, check-in/check-out dates, number of guests, and number of rooms.
        
        Be helpful, professional, and ensure all booking details are confirmed before processing.`
    }, 
    model = bookingAiAgentModel, 
    tools = [
        _searchHotels,
        _getHotelById,
        _createBooking,
        _getBookingById,
        _getAllBookings,
        _cancelBooking,
        _getHealthStatus,
        _searchHotelsByLocation,
        _searchHotelsByPriceRange,
        _searchHotelsByRating,
        _createSimpleBooking
    ]
);
