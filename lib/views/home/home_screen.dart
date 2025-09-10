import 'dart:io';

import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/views/profile/profile_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_form_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_history_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_report_screen.dart';
import 'package:aplikasi_bengkel_motor/widgets/drawer_vespario.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userName = "";

  final List<Widget> _pages = [
    const HomeContentFinal(),
    const ServiceListScreen(),
    const ServiceHistoryScreen(),
    const ServiceReportScreen(showAppBar: false),
  ];

  final List<String> _titles = [
    "BikeCare",
    "Service Saya",
    "Riwayat",
    "Laporan",
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final name = await SharedPreference.getUserName();
    setState(() {
      userName = name ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? AppBar(
              title: Text(_titles[_selectedIndex]),
              centerTitle: true,
              backgroundColor: const Color(0xFF0A2463),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
                  ),
                ),
              ),
              actions: [
                // Tambahkan icon profile di pojok kanan
                IconButton(
                  icon: const Icon(Icons.person, size: 28),
                  onPressed: () {
                    context.push(
                      const ProfileScreen(),
                    ); // Navigasi ke halaman profile
                  },
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      drawer: const DrawerVesparioFinal(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0A2463),
            unselectedItemColor: const Color(0xFF7B8794),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build_outlined),
                activeIcon: Icon(Icons.build),
                label: "Service",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: "Riwayat",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: "Laporan",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContentFinal extends StatefulWidget {
  const HomeContentFinal({super.key});

  @override
  State<HomeContentFinal> createState() => _HomeContentFinalState();
}

class _HomeContentFinalState extends State<HomeContentFinal> {
  String userName = "";
  int _currentCarouselIndex = 0;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadProfileImage();
  }

  void loadUserData() async {
    final name = await SharedPreference.getUserName();
    setState(() {
      userName = name ?? "User";
    });
  }

  void loadProfileImage() async {
    final imagePath = await SharedPreference.getUserProfileImage();
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> carouselItems = [
      {
        'icon': Icons.calendar_today,
        'title': "Booking",
        'subtitle': "Buat janji servis",
        'color': const Color(0xFF0A2463),
        'gradient': const LinearGradient(
          colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
        ),
        'onTap': () {
          context.push(const BookingFormScreen());
        },
      },
      {
        'icon': Icons.list_alt,
        'title': "Daftar Booking",
        'subtitle': "Lihat appointment",
        'color': const Color(0xFF2563EB),
        'gradient': const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        'onTap': () {
          context.push(const BookingListScreen());
        },
      },
      {
        'icon': Icons.build,
        'title': "Kelola Service",
        'subtitle': "Manage servis",
        'color': const Color(0xFF059669),
        'gradient': const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF047857)],
        ),
        'onTap': () {
          context.push(const ServiceListScreen());
        },
      },
      {
        'icon': Icons.history,
        'title': "Riwayat",
        'subtitle': "Lihat riwayat",
        'color': const Color(0xFF7C3AED),
        'gradient': const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
        ),
        'onTap': () {
          context.push(const ServiceHistoryScreen());
        },
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0A2463).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar dengan foto profil
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: _profileImage != null
                            ? DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, $userName",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Selamat datang di BikeCare",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Solusi lengkap untuk perawatan kendaraan Anda. Booking service, pantau progress, dan nikmati pengalaman servis yang premium.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Menu Title
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Akses Cepat",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2463),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Carousel Menu
          Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 220,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                ),
                items: carouselItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return _buildMenuCard(
                        icon: item['icon'],
                        title: item['title'],
                        subtitle: item['subtitle'],
                        color: item['color'],
                        gradient: item['gradient'],
                        onTap: item['onTap'],
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: carouselItems.asMap().entries.map((entry) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == entry.key
                          ? const Color(0xFF0A2463)
                          : Colors.grey.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Services Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0A2463).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.construction, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      "Layanan BikeCare",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildServiceInfo(
                  Icons.check_circle,
                  "Service rutin dan berkala dengan teknisi profesional",
                ),
                _buildServiceInfo(
                  Icons.check_circle,
                  "Perbaikan mesin dan body dengan garansi resmi",
                ),
                _buildServiceInfo(
                  Icons.check_circle,
                  "Penggantian spare part original dengan harga terbaik",
                ),
                _buildServiceInfo(
                  Icons.check_circle,
                  "Konsultasi gratis dan estimasi biaya transparan",
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    context.push(const BookingFormScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Pelajari Lebih Lanjut",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Promo Section - Mengganti Stats Overview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      "Promo Spesial",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPromoItem(
                  "Service Berkala",
                  "Diskon 15% untuk service berkala hingga akhir bulan",
                ),
                _buildPromoItem(
                  "Ganti Oli",
                  "Gratis pengecekan mesin untuk setiap ganti oli",
                ),
                _buildPromoItem(
                  "Paket Service Lengkap",
                  "Dapatkan harga khusus untuk paket service lengkap",
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Aksi untuk melihat promo lebih lanjut
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Lihat Semua Promo",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF10B981)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
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
