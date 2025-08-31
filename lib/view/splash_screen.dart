import 'dart:async';

import 'package:aplikasi_bengkel_motor/view/auth/login_page.dart';
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
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b3866),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background_bengkel.png",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // overlay agar elegan
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo_bengkelku.png", height: 250),
                const SizedBox(height: 20),
                const Text(
                  "BengkelKu",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
