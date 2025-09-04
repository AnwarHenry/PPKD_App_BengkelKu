import 'package:aplikasi_bengkel_motor/view/admin/dashboard_admin.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_booking_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/service_stats_page.dart';
import 'package:aplikasi_bengkel_motor/view/auth/login_page.dart';
import 'package:aplikasi_bengkel_motor/view/auth/register_page.dart';
import 'package:aplikasi_bengkel_motor/view/splash_screen.dart';
import 'package:aplikasi_bengkel_motor/view/user/booking_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/buat_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/dashboard_user.dart';
import 'package:aplikasi_bengkel_motor/view/user/list_booking_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/profile_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/riwayat_servis_page.dart';
import 'package:aplikasi_bengkel_motor/view/welcome_screen.dart';
// import 'package:aplikasi_bengkel_motor/view/welcome_screen.dart';
// import 'package:bengkel_1/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      // home: const SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        UserDashboard.id: (context) => const UserDashboard(),
        AdminDashboard.id: (context) => const AdminDashboard(),
        ProfilePage.id: (context) => const ProfilePage(),
        BookingServicePage.id: (context) => const BookingServicePage(),
        BuatServicePage.id: (context) => const BuatServicePage(),
        RiwayatServisPage.id: (context) => const RiwayatServisPage(),
        // StatusServicePage.id: (context) => const StatusServicePage(),
        ListBookingPage.id: (context) => const ListBookingPage(),
        ManageServicesPage.id: (context) => const ManageServicesPage(),
        ManageBookingsPage.id: (context) => const ManageBookingsPage(),
        // UpdateStatusPage.id: (context) => const UpdateStatusPage(),
        ServiceStatsPage.id: (context) => const ServiceStatsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
