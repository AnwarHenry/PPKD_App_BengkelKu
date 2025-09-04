class Endpoints {
  static const String baseUrl = "https://appbengkel.mobileprojp.com";

  // Auth endpoints
  static String get register => '$baseUrl/api/register';
  static String get login => '$baseUrl/api/login';
  static String get logout => '$baseUrl/api/logout';
  static String get profile => '$baseUrl/api/profile';

  // Servis endpoints
  static String get servis => '$baseUrl/api/servis';
  static String get bookingServis => '$baseUrl/api/booking-servis';
  static String get riwayatServis => '$baseUrl/api/riwayat-servis';

  // Helper methods untuk endpoints dengan parameter
  static String servisStatus(int id) => '$servis/$id/status';
  static String deleteServis(int id) => '$servis/$id';
  static String updateServis(int id) => '$servis/$id';
  static String getServisById(int id) => '$servis/$id';
  static String getBookingById(int id) => '$bookingServis/$id';
  static String updateBookingStatus(int id) => '$bookingServis/$id/status';
  static String deleteBooking(int id) => '$bookingServis/$id';

  // Admin endpoints
  static String get adminStats => '$baseUrl/api/admin/stats';
  static String get adminUsers => '$baseUrl/api/admin/users';
  static String get adminAllBookings => '$baseUrl/api/admin/bookings';
  static String get adminAllServices => '$baseUrl/api/admin/services';
}
