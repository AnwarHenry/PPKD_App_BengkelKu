class BengkelEndpoint {
  static const String baseUrl = "https://appbengkel.mobileprojp.com/";

  // Auth
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";

  // Booking
  static const String getBookings = "$baseUrl/bookings";
  static const String createBooking = "$baseUrl/bookings/create";
  static const String updateBooking = "$baseUrl/bookings/update";
  static const String deleteBooking = "$baseUrl/bookings/delete";

  // Service
  static const String services = "$baseUrl/services";

  // Mechanic
  static const String mechanics = "$baseUrl/mechanics";

  // Report
  static const String reports = "$baseUrl/reports";

  // Profile
  static const String profile = "$baseUrl/profile";
}
