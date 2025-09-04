import 'dart:convert';

import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/view/admin/dashboard_admin.dart';
import 'package:aplikasi_bengkel_motor/view/auth/register_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/dashboard_user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const id = "/login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final credentials = await PreferenceHandler.getSavedCredentials();

      if (credentials['rememberMe'] == true &&
          credentials['email'] != null &&
          credentials['password'] != null) {
        setState(() {
          emailController.text = credentials['email']!;
          passwordController.text = credentials['password']!;
          _rememberMe = credentials['rememberMe']!;
        });

        // Tampilkan info login terakhir jika ada
        if (credentials['lastLogin'] != null) {
          final lastLogin = credentials['lastLogin'] as DateTime;
          final timeAgo = _getTimeAgo(lastLogin);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terakhir login: $timeAgo'),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Beberapa detik yang lalu';
    }
  }

  Future<void> _saveCredentials() async {
    await PreferenceHandler.saveCredentials(
      email: emailController.text,
      password: passwordController.text,
      rememberMe: _rememberMe,
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await BengkelAPI.loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response.success) {
          // Simpan token dan data user
          await PreferenceHandler.saveToken(response.data!.token);
          await PreferenceHandler.saveUser(
            json.encode(response.data!.user.toJson()),
          );

          // Simpan kredensial dan update waktu login
          await _saveCredentials();
          await PreferenceHandler.updateLastLogin();

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigasi ke dashboard berdasarkan role
          final role = response.data!.user.role;
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, AdminDashboard.id);
          } else {
            Navigator.pushReplacementNamed(context, UserDashboard.id);
          }
        }
      } catch (e) {
        String errorMessage = "Terjadi kesalahan saat login";
        if (e.toString().contains("Email atau password salah")) {
          errorMessage = "Email atau password salah";
        } else if (e.toString().contains("connection") ||
            e.toString().contains("socket") ||
            e.toString().contains("network")) {
          errorMessage =
              "Tidak dapat terhubung ke server. Periksa koneksi internet Anda";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearCredentials() async {
    await PreferenceHandler.clearCredentials();
    setState(() {
      emailController.clear();
      passwordController.clear();
      _rememberMe = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kredensial login telah dihapus'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void loginAsGuest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Masuk sebagai tamu - fitur terbatas"),
        backgroundColor: Colors.blue,
      ),
    );

    Navigator.pushReplacementNamed(context, UserDashboard.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        //   },
        // ),
        title: const Text('Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCredentials,
            tooltip: 'Hapus kredensial tersimpan',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(
                      "Professional Automotive Service",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Image.asset(
                          "assets/images/logo_bengkelku.png",
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.build,
                                size: 50,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Masuk untuk mengakses layanan bengkel",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        "Email",
                        "Masukkan email Anda",
                        Icons.email,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        } else if (!value.contains("@")) {
                          return "Email harus mengandung @";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        "Password",
                        "Masukkan password Anda",
                        Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        } else if (value.length < 6) {
                          return "Password minimal 6 karakter";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            Set<WidgetState> states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.orange;
                            }
                            return Colors.white;
                          }),
                        ),
                        const Text(
                          "Ingat saya",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Tooltip(
                          message:
                              'Email dan password akan disimpan untuk login otomatis',
                          child: Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade500,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  UserDashboard.id,
                                );
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          "Masuk sebagai Tamu",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterPage(),
                                    ),
                                  );
                                },
                          child: Text(
                            "Daftar di sini",
                            style: TextStyle(
                              color: Colors.orange.shade300,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    String hint,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.withOpacity(0.8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: TextStyle(color: Colors.orange.shade200, fontSize: 12),
    );
  }
}
