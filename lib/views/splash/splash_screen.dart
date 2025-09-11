import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:aplikasi_bengkel_motor/views/auth/login_screen.dart';
import 'package:aplikasi_bengkel_motor/views/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    bool isLoggedIn = await SharedPreference.isLoggedIn();

    if (isLoggedIn) {
      context.pushAndRemoveAll(const HomeScreen());
    } else {
      context.pushAndRemoveAll(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_bengkel.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/bikecare_logo.png",
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 24),

              const SizedBox(width: 12),

              // Slogan
              const Text(
                "Layanan otomotif terbaik untuk kendaraan Anda",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Loading Indicator
              const CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 3,
              ),

              const SizedBox(height: 20),

              const Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
