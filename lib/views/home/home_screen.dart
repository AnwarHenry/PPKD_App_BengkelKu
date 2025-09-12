import 'dart:io';

import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:aplikasi_bengkel_motor/services/api/service_api.dart';
import 'package:aplikasi_bengkel_motor/views/profile/profile_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_form_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/booking_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_history_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_list_screen.dart';
import 'package:aplikasi_bengkel_motor/views/service/service_report_screen.dart';
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
    "Servis Saya",
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
                IconButton(
                  icon: const Icon(Icons.person, size: 28),
                  onPressed: () {
                    context.push(const ProfileScreen());
                  },
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
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
                label: "Servis",
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
  final TextEditingController _searchController = TextEditingController();

  // Data status kendaraan dari service terbaru
  Map<String, dynamic>? _latestService;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchLatestService();
  }

  void loadUserData() async {
    final name = await SharedPreference.getUserName();
    setState(() {
      userName = name ?? "User";
    });
  }

  Future<void> fetchLatestService() async {
    try {
      // Mengambil data service terbaru dari API
      final response = await ServiceApi.getAllServices();

      if (response.data != null && response.data!.isNotEmpty) {
        // Urutkan berdasarkan tanggal dibuat (terbaru pertama)
        response.data!.sort((a, b) {
          final dateA = a.createdAt != null
              ? DateTime.parse(a.createdAt!)
              : DateTime(0);
          final dateB = b.createdAt != null
              ? DateTime.parse(b.createdAt!)
              : DateTime(0);
          return dateB.compareTo(dateA);
        });

        // Ambil service terbaru
        final latestService = response.data!.first;

        setState(() {
          _latestService = {
            'id': latestService.id,
            'vehicleType': latestService.vehicleType,
            'complaint': latestService.complaint,
            'bookingDate': latestService.createdAt,
            'status': latestService.status?.toLowerCase() ?? '',
          };
          _isLoading = false;
          _errorMessage = '';
        });

        // Simpan ke shared preferences untuk akses cepat
        await SharedPreference.saveLatestService(_latestService!);
      } else {
        // Coba ambil dari booking jika tidak ada service
        final bookingResponse = await ServiceApi.getAllBookings();
        if (bookingResponse.data != null && bookingResponse.data!.isNotEmpty) {
          bookingResponse.data!.sort((a, b) {
            final dateA = a.createdAt != null
                ? DateTime.parse(a.createdAt!)
                : DateTime(0);
            final dateB = b.createdAt != null
                ? DateTime.parse(b.createdAt!)
                : DateTime(0);
            return dateB.compareTo(dateA);
          });

          final latestBooking = bookingResponse.data!.first;

          setState(() {
            _latestService = {
              'id': latestBooking.id,
              'vehicleType': latestBooking.vehicleType,
              'complaint': latestBooking.description,
              'bookingDate': latestBooking.bookingDate,
              'status': '',
            };
            _isLoading = false;
          });

          await SharedPreference.saveLatestBooking(_latestService!);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = '';
          });
        }
      }
    } catch (e) {
      print('Error fetching service data: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data service';
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    if (query.toLowerCase().contains('booking') ||
        query.toLowerCase().contains('janji')) {
      context.push(const BookingListScreen());
    } else if (query.toLowerCase().contains('service') ||
        query.toLowerCase().contains('kelola')) {
      context.push(const ServiceListScreen());
    } else if (query.toLowerCase().contains('riwayat') ||
        query.toLowerCase().contains('history')) {
      context.push(const ServiceHistoryScreen());
    } else if (query.toLowerCase().contains('laporan') ||
        query.toLowerCase().contains('report')) {
      context.push(const ServiceReportScreen(showAppBar: false));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Icons.access_time;
      case 'diproses':
        return Icons.build;
      case 'selesai':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0A2463), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFF0A2463)),
            SizedBox(height: 12),
            Text(
              "Memuat status service...",
              style: TextStyle(color: Color(0xFF0A2463)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: fetchLatestService,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2463),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.directions_bike, color: Colors.grey, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Belum ada service aktif',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Silakan booking service terlebih dahulu untuk melihat status',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push(const BookingFormScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2463),
            ),
            child: const Text('Booking Service'),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStatusSection() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_latestService == null) {
      return _buildEmptyState();
    }

    final status = _latestService!['status']?.toString() ?? 'menunggu';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              // Icon(Icons.directions_bike, color: Color(0xFF0A2463), size: 24),
              SizedBox(width: 12),
              Text(
                "Status Servis Terkini",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A2463),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _latestService!['complaint']?.toString() ??
                            'Service rutin',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info Service Lengkap
          _buildInfoItem(
            Icons.two_wheeler,
            "Jenis Kendaraan",
            _latestService!['vehicleType']?.toString() ?? 'Motor Matic',
          ),
          const SizedBox(height: 12),

          _buildInfoItem(
            Icons.description,
            "Keluhan",
            _latestService!['complaint']?.toString() ?? 'Tidak ada keluhan',
          ),
          const SizedBox(height: 12),

          _buildInfoItem(
            Icons.calendar_today,
            "Tanggal Booking",
            _formatDate(_latestService!['bookingDate']?.toString()),
          ),
          const SizedBox(height: 12),

          _buildInfoItem(
            Icons.calendar_month,
            "Status",
            status.toUpperCase(),
            valueColor: statusColor,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
      physics: const CarouselScrollPhysics(
        // parent: AlwaysScrollableScrollPhysics(),
      ),
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
                    // Avatar dengan assets image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/profile.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                  "BikeCare adalah Solusi terbaik untuk perawatan kendaraan Anda.",
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

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Cari booking, riwayat, status ...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIcon: Icon(Icons.search, color: Color(0xFF0A2463)),
              ),
              onSubmitted: _performSearch,
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
                  height: 270,
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

          // Status Kendaraan dan Service
          _buildVehicleStatusSection(),

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
}
