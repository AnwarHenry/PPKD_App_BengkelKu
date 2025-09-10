import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:aplikasi_bengkel_motor/views/auth/login_screen.dart';
import 'package:aplikasi_bengkel_motor/views/profile/profile_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_form_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_history_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_report_screen.dart';
import 'package:flutter/material.dart';

class DrawerVesparioFinal extends StatefulWidget {
  const DrawerVesparioFinal({super.key});

  @override
  State<DrawerVesparioFinal> createState() => _DrawerVesparioFinalState();
}

class _DrawerVesparioFinalState extends State<DrawerVesparioFinal> {
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await SharedPreference.getUserName();
    final email = await SharedPreference.getUserEmail();

    if (mounted) {
      setState(() {
        userName = name ?? "User";
        userEmail = email ?? "user@example.com";
      });
    }
  }

  Future<void> logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redAccent,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await SharedPreference.clearAll();
        if (mounted) {
          Navigator.of(context).pop(); // Close drawer
          context.pushAndRemoveAll(const LoginScreen());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error logout: ${e.toString()}"),
              backgroundColor: AppColors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo and Name
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.motorcycle,
                        color: AppColors.mintGreen,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vespario",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Book. Fix. Ride.",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // User Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.mintGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),

                // Home
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: "Home",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),

                // Booking Service
                _buildDrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: "Booking Service",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(const BookingFormScreen());
                  },
                ),

                // Daftar Booking
                _buildDrawerItem(
                  icon: Icons.list_alt_outlined,
                  title: "Daftar Booking",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(const BookingListScreen());
                  },
                ),

                // Kelola Service
                _buildDrawerItem(
                  icon: Icons.build_outlined,
                  title: "Kelola Service",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(const ServiceListScreen());
                  },
                ),

                // Riwayat Service
                _buildDrawerItem(
                  icon: Icons.history_outlined,
                  title: "Riwayat Service",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(const ServiceHistoryScreen());
                  },
                ),

                // Laporan - DENGAN APPBAR karena dari drawer
                _buildDrawerItem(
                  icon: Icons.analytics_outlined,
                  title: "Laporan",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(
                      const ServiceReportScreen(showAppBar: true),
                    ); // WITH APPBAR
                  },
                ),

                const Divider(height: 24),

                // Profil
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: "Profil",
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(const ProfileScreen());
                  },
                ),

                // Pengaturan
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: "Pengaturan",
                  onTap: () {
                    Navigator.of(context).pop();
                    _showSettingsDialog();
                  },
                ),

                // Bantuan
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: "Bantuan",
                  onTap: () {
                    Navigator.of(context).pop();
                    _showHelpDialog();
                  },
                ),

                const Divider(height: 24),

                // Logout
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  title: "Logout",
                  isDestructive: true,
                  onTap: logout,
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mediumGray.withOpacity(0.2)),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  "Vespario v1.ng",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "© 2025 Vespario. All rights reserved.",
                  style: TextStyle(fontSize: 10, color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.redAccent : AppColors.mintGreen,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isDestructive ? AppColors.redAccent : AppColors.darkGray,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.settings, color: AppColors.mintGreen),
              SizedBox(width: 8),
              Text("Pengaturan"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text("Notifikasi"),
                subtitle: const Text("Atur notifikasi aplikasi"),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Handle notification toggle
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text("Mode Gelap"),
                subtitle: const Text("Beralih ke tema gelap"),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Handle dark mode toggle
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text("Bahasa"),
                subtitle: const Text("Bahasa Indonesia"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle language selection
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.infoBlue),
              SizedBox(width: 8),
              Text("Bantuan"),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cara Menggunakan Vespario:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  "1. Booking Service",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("   • Pilih menu 'Booking Service'"),
                Text("   • Isi formulir booking"),
                Text("   • konversi ke service jika perlu"),
                SizedBox(height: 8),
                Text(
                  "2. Kelola Service",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("   • Buat service baru"),
                Text("   • Update status service"),
                Text("   • Hapus service jika perlu"),
                SizedBox(height: 8),
                Text(
                  "3. Lihat Riwayat",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("   • Cek service yang sudah selesai"),
                Text("   • Lihat detail service"),
                SizedBox(height: 8),
                Text(
                  "4. Laporan",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("   • Analisa statistik service"),
                Text("   • Monitor tren bulanan"),
                SizedBox(height: 16),
                Text(
                  "Butuh bantuan lebih lanjut?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Email: support@vespario.com"),
                Text("Telepon: +62 811-994-0198"),
                Text("WhatsApp: +62 811-994-0198"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
