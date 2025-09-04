import 'dart:convert';

import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/utils/app_colors.dart';
import 'package:aplikasi_bengkel_motor/view/user/booking_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/list_booking_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/profile_page.dart';
import 'package:aplikasi_bengkel_motor/widgets/custom_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});
  static const id = "/user_dashboard";

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;
  int _currentCarouselIndex = 0;
  String _userName = "Pelanggan";
  int _userPoints = 125;
  bool _isTokenValid = true;

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Servis',
      'icon': Icons.build,
      'page': const BookingServicePage(),
    },
    {
      'title': 'Ganti Oli',
      'icon': Icons.invert_colors,
      'page': const BookingServicePage(),
    },
    {
      'title': 'Tune Up',
      'icon': Icons.tune,
      'page': const BookingServicePage(),
    },
    {
      'title': 'Perbaikan',
      'icon': Icons.engineering,
      'page': const BookingServicePage(),
    },
  ];

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Promo Servis Berkala',
      'subtitle': 'Diskon 20% untuk servis berkala bulan ini',
      'action': 'Lihat Detail',
      'color': Colors.orange,
    },
    {
      'title': 'Ganti Oli Gratis Check Up',
      'subtitle': 'Setiap ganti oli gratis pengecekan komponen',
      'action': 'Lihat Detail',
      'color': Colors.blue,
    },
    {
      'title': 'Program Loyalitas',
      'subtitle': 'Kumpulkan poin untuk mendapatkan hadiah menarik',
      'action': 'Lihat Detail',
      'color': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Booking Servis',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'page': const BookingServicePage(),
    },
    {
      'title': 'Riwayat Servis',
      'icon': Icons.history,
      'color': Colors.purple,
      'page': const ListBookingPage(),
    },
    {
      'title': 'Status Kendaraan',
      'icon': Icons.motorcycle_sharp,
      'color': Colors.orange,
      'page': const ListBookingPage(),
    },
    {
      'title': 'List Booking',
      'icon': Icons.list_alt,
      'color': Colors.green,
      'page': const ListBookingPage(),
    },
  ];

  final List<Map<String, dynamic>> _recentServices = [
    {
      'vehicle': 'Motor NMax 155cc',
      'date': '15 Nov 2023',
      'service': 'Servis Berkala',
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
    {
      'vehicle': 'Honda Beat 110cc',
      'date': '10 Nov 2023',
      'service': 'Ganti Oli',
      'status': 'Diproses',
      'statusColor': Colors.orange,
    },
    {
      'vehicle': 'Yamaha MX King 150cc',
      'date': '5 Nov 2023',
      'service': 'Tune Up',
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkTokenValidity();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');

      if (userJson != null) {
        final userData = json.decode(userJson);
        setState(() {
          _userName = userData['name'] ?? 'Pelanggan';
          _userPoints = userData['points'] ?? 125;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _checkTokenValidity() async {
    try {
      await BengkelAPI.getUserProfile();
      setState(() {
        _isTokenValid = true;
      });
    } catch (e) {
      setState(() {
        _isTokenValid = false;
      });
      _showTokenExpiredDialog();
    }
  }

  void _showTokenExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sesi Login Habis'),
          content: const Text(
            'Sesi login Anda telah habis. Silakan login kembali.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await BengkelAPI.logout();
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/welcome_screen',
        (route) => false,
      );
    }
  }

  void _showNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur notifikasi akan segera hadir!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BengkelKu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              _showNotification(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ).then((_) {
                _loadUserData();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildFeaturesSection(),
              const SizedBox(height: 25),
              _buildPromoSection(),
              const SizedBox(height: 25),
              _buildServicesSection(),
              const SizedBox(height: 25),
              _buildRecentServicesSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $_userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  'Mari rawat kendaraan Anda bersama kami',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_userPoints Poin',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari layanan atau sparepart...',
          prefixIcon: const Icon(Icons.search, color: AppColor.text),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 15,
          ),
          hintStyle: const TextStyle(color: AppColor.text),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fitur Utama',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 3.0,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _features[index]['page'],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _features[index]['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _features[index]['color'].withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _features[index]['icon'],
                            color: _features[index]['color'],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _features[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _features[index]['color'],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Promo Spesial',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
        ),
        const SizedBox(height: 15),
        CustomCarouselSlider(
          carouselItems: _carouselItems,
          height: 160,
          autoPlay: true,
          onPageChanged: (index) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Kami',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _services[index]['page'],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _services[index]['icon'],
                          color: Colors.blue[800],
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _services[index]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentServicesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Servis Terbaru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 15),
          ..._recentServices.map((service) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.motorcycle_sharp,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['vehicle'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${service['service']} • ${service['date']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: service['statusColor'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        service['status'],
                        style: TextStyle(
                          color: service['statusColor'],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListBookingPage()),
                );
              },
              child: const Text(
                'Lihat Semua Riwayat →',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListBookingPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookingServicePage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListBookingPage()),
            );
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'List Booking',
        ),
      ],
    );
  }
}
