import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:aplikasi_bengkel_motor/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String userEmail = "";
  int userId = 0;
  String userCreatedAt = "";
  bool isLoading = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final name = await SharedPreference.getUserName();
      final email = await SharedPreference.getUserEmail();
      final id = await SharedPreference.getUserId();
      final createdAt = await SharedPreference.getUserCreatedAt();
      final imagePath = await SharedPreference.getUserProfileImage();

      if (mounted) {
        setState(() {
          userName = name ?? "User";
          userEmail = email ?? "user@example.com";
          userId = id ?? 0;
          userCreatedAt = createdAt ?? "Tanggal tidak tersedia";

          // Load profile image if exists
          if (imagePath != null && imagePath.isNotEmpty) {
            _profileImage = File(imagePath);
          }

          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });

        // Save image path to shared preferences
        await SharedPreference.saveUserProfileImage(pickedFile.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Foto profil berhasil diubah"),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memilih gambar: ${e.toString()}"),
            backgroundColor: AppColors.redAccent,
          ),
        );
      }
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout berhasil"),
              backgroundColor: AppColors.successGreen,
            ),
          );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: const Color(0xFF0A2463),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0A2463)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0A2463).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Avatar with Edit Button
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: _profileImage != null
                                    ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Container(
                                        color: Colors.white.withOpacity(0.2),
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A2463),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _showImagePickerDialog();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // User Info
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "ID: $userId",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Bergabung sejak: $userCreatedAt",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Profile Menu Items
                  const Text(
                    "Pengaturan Akun",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2463),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: "Edit Profil",
                    subtitle: "Ubah nama dan informasi profil",
                    onTap: () => _showEditProfileDialog(),
                  ),
                  _buildMenuItem(
                    icon: Icons.security,
                    title: "Keamanan",
                    subtitle: "Ubah password dan keamanan akun",
                    onTap: () => _showSecurityDialog(),
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifikasi",
                    subtitle: "Pengaturan notifikasi aplikasi",
                    onTap: () => _showNotificationSettings(),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Bantuan",
                    subtitle: "FAQ dan pusat bantuan",
                    onTap: () => _showHelpDialog(),
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: "Tentang",
                    subtitle: "Informasi aplikasi BikeCare",
                    onTap: () => _showAboutDialog(),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App Version
                  const Center(
                    child: Text(
                      "BikeCare v1.0.0\nBook. Fix. Ride.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF7B8794)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0A2463).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0A2463), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0A2463),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7B8794)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF7B8794),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Foto"),
          content: const Text("Dari mana Anda ingin mengambil foto?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: const Text("Galeri"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: const Text("Kamera"),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profil"),
          content: const Text("Fitur edit profil akan segera tersedia."),
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

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Keamanan"),
          content: const Text(
            "Fitur keamanan akan segera tersedia.\nUntuk mengubah password, silakan hubungi admin.",
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

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pengaturan Notifikasi"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Push Notifications"),
                trailing: Switch(value: true, onChanged: null),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Email Notifications"),
                trailing: Switch(value: false, onChanged: null),
              ),
            ],
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bantuan"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("• Bagaimana cara booking service?"),
              Text("• Berapa lama waktu service?"),
              Text("• Service tersedia untuk motor diluar vespa?"),
              SizedBox(height: 16),
              Text(
                "Untuk bantuan lebih lanjut:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Email: support@bikecare.com"),
              Text("Telepon: +62 811-994-0198"),
            ],
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tentang BikeCare"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.motorcycle, color: Color(0xFF0A2463)),
                  SizedBox(width: 8),
                  Text(
                    "BikeCare",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2463),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Versi: 1.0.0"),
              SizedBox(height: 8),
              Text("Book. Fix. Ride."),
              SizedBox(height: 16),
              Text(
                "BikeCare adalah aplikasi untuk memudahkan booking dan pengelolaan service motor. Dengan BikeCare, Anda dapat:",
              ),
              SizedBox(height: 8),
              Text("• Booking service dengan mudah"),
              Text("• Melacak status service"),
              Text("• Melihat riwayat service"),
              Text("• Mendapatkan laporan analitik"),
              SizedBox(height: 16),
              Text(
                "Dikembangkan dengan ❤️ untuk penggemar motor",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF7B8794),
                ),
              ),
            ],
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
