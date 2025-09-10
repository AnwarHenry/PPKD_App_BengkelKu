import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/services/api/auth_service.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:aplikasi_bengkel_motor/views/home/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    "assets/images/logo_bengkelku.png",
                    width: 220,
                    height: 220,
                  ),
                  const SizedBox(height: 16),

                  // Register Form dengan latar belakang semi-transparan
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction, // Tambahkan ini
                      child: Column(
                        children: [
                          // Judul Daftar yang dipindahkan ke tengah
                          const Column(
                            children: [
                              Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Buat akun baru untuk memulai",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Name Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Nama Lengkap",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Masukkan nama lengkap anda",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  errorStyle: TextStyle(
                                    // Style untuk pesan error
                                    color: Colors.orange[200],
                                    fontSize: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Masukkan email anda",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  errorStyle: TextStyle(
                                    // Style untuk pesan error
                                    color: Colors.orange[200],
                                    fontSize: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Email harus mengandung @';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Masukkan password anda",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  errorStyle: TextStyle(
                                    // Style untuk pesan error
                                    color: Colors.orange[200],
                                    fontSize: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  if (value.length < 6) {
                                    return 'Password minimal 6 karakter';
                                  }
                                  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                                    return 'Huruf awal harus huruf besar';
                                  }
                                  if (!RegExp(
                                    r'[!@#$%^&*(),.?":{}|<>]',
                                  ).hasMatch(value)) {
                                    return 'Password harus menggunakan simbol';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text(
                                "Sudah punya akun? Masuk disini",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (response.data?.token != null && response.data?.user != null) {
        await SharedPreference.saveUserData(
          token: response.data!.token!,
          userId: response.data!.user!.id!,
          userName: response.data!.user!.name!,
          userEmail: response.data!.user!.email!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil"),
              backgroundColor: AppColors.successGreen,
            ),
          );
          context.pushAndRemoveAll(const HomeScreen());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: AppColors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
