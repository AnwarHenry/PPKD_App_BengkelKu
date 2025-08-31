import 'package:aplikasi_bengkel_motor/view/auth/login_page.dart';
import 'package:aplikasi_bengkel_motor/view/splash_screen.dart';
import 'package:aplikasi_bengkel_motor/view/user/dashboard.dart';
import 'package:aplikasi_bengkel_motor/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoCare',
      theme: ThemeData(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colors.blue.shade100,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginPage.id: (context) => const LoginPage(),
        DashboardPage.id: (context) => const DashboardPage(username: ''),
        BottomNavBar.id: (context) => const BottomNavBar(),
      },
      // home: DashboardPage(username: ''),
      // home: AddServicePage(),
    );
  }
}
