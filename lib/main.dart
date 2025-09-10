import 'package:aplikasi_bengkel_motor/theme/app_theme.dart';
import 'package:aplikasi_bengkel_motor/views/auth/login_screen.dart';
import 'package:aplikasi_bengkel_motor/views/auth/register_screen.dart';
import 'package:aplikasi_bengkel_motor/views/home/home_screen.dart';
import 'package:aplikasi_bengkel_motor/views/profile/profile_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_form_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_history_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_report_screen.dart';
import 'package:aplikasi_bengkel_motor/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MotoCare - Book. Fix. Ride.",
      debugShowCheckedModeBanner: false,
      theme: AppThemeFinal.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingFormScreen(),
        '/service': (context) => const ServiceListScreen(),
        '/history': (context) => const ServiceHistoryScreen(),
        '/report': (context) => const ServiceReportScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
