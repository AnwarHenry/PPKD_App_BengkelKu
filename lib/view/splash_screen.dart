import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/utils/role_checker.dart';
import 'package:aplikasi_bengkel_motor/view/admin/dashboard_admin.dart';
import 'package:aplikasi_bengkel_motor/view/user/dashboard_user.dart';
import 'package:aplikasi_bengkel_motor/view/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await PreferenceHandler.getToken();

    // Jika ada token, langsung navigasi ke dashboard tanpa validasi
    if (token != null && token.isNotEmpty) {
      // Ambil role dari user data yang tersimpan
      final role = await RoleChecker.getUserRole();

      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, AdminDashboard.id);
      } else {
        Navigator.pushReplacementNamed(context, UserDashboard.id);
      }
    } else {
      // Jika tidak ada token, redirect ke welcome screen
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_bengkelku.png",
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.build,
                      size: 60,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "BengkelKu",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Professional Automotive Service",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
