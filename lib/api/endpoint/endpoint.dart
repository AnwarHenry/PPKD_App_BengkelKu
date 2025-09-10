class Endpoint {
  static const String baseUrl = "https://appbengkel.mobileprojp.com";

  // Auth Endpoints
  static const String register = "$baseUrl/api/register";
  static const String login = "$baseUrl/api/login";
  static const String profile = "$baseUrl/api/profile";

  // Booking Endpoints (COMPLETE CRUD)
  static const String bookingServis = "$baseUrl/api/booking-servis";
  static String updateBooking(int id) => "$baseUrl/api/booking-servis/$id";
  static String deleteBooking(int id) => "$baseUrl/api/booking-servis/$id";

  // Service Endpoints
  static const String servis = "$baseUrl/api/servis";
  static const String riwayatServis = "$baseUrl/api/riwayat-servis";
  static String convertBookingToService(int bookingId) =>
      "$baseUrl/api/servis/from-booking/$bookingId";

  // Service Status Endpoints
  static String servisStatus(int id) => "$baseUrl/api/servis/$id/status";
  static String deleteServis(int id) => "$baseUrl/api/servis/$id";
}
