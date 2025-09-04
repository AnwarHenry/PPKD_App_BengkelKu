import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_booking_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/service_stats_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/update_status_page.dart';
import 'package:aplikasi_bengkel_motor/view/welcome_screen.dart';
import 'package:aplikasi_bengkel_motor/widgets/app_drawer.dart';
import 'package:aplikasi_bengkel_motor/widgets/booking_card.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bengkel_1/api/bengkel_api.dart';
// import 'package:bengkel_1/api/models/booking_model.dart';
// import 'package:bengkel_1/api/models/service_model.dart';
// import 'package:bengkel_1/utils/role_checker.dart';
// import 'package:bengkel_1/view/admin/manage_bookings_page.dart';
// import 'package:bengkel_1/view/admin/manage_services_page.dart';
// import 'package:bengkel_1/view/admin/service_stats_page.dart';
// import 'package:bengkel_1/view/admin/update_status_page.dart';
// import 'package:bengkel_1/view/welcome_screen.dart';
// import 'package:bengkel_1/view/widgets/app_drawer.dart';
// import 'package:bengkel_1/view/widgets/booking_card.dart';
// import 'package:bengkel_1/view/widgets/loading_indicator.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  static const id = "/admin_dashboard";

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  List<BookingModel> _recentBookings = [];
  List<ServiceModel> _popularServices = [];
  int _totalBookings = 0;
  int _pendingBookings = 0;
  int _completedBookings = 0;
  bool _isLoading = true;
  bool _isTokenValid = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _checkTokenValidity();
  }

  Future<void> _loadDashboardData() async {
    try {
      final bookingsResponse = await BengkelAPI.getAllBookings();
      final servicesResponse = await BengkelAPI.getAllServices();

      if (bookingsResponse.success && servicesResponse.success) {
        setState(() {
          _recentBookings = bookingsResponse.data!.take(5).toList();
          _popularServices = servicesResponse.data!.take(3).toList();
          _totalBookings = bookingsResponse.data!.length;
          _pendingBookings = bookingsResponse.data!
              .where((booking) => booking.status == 'pending')
              .length;
          _completedBookings = bookingsResponse.data!
              .where((booking) => booking.status == 'completed')
              .length;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
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
        WelcomeScreen.id,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: const AppDrawer(isAdmin: true),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticsSection(),
                  const SizedBox(height: 24),
                  _buildRecentBookingsSection(),
                  const SizedBox(height: 24),
                  _buildPopularServicesSection(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
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
                MaterialPageRoute(builder: (_) => const ManageBookingsPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageServicesPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceStatsPage()),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total Bookings',
          _totalBookings.toString(),
          Icons.book,
          Colors.blue,
        ),
        _buildStatCard(
          'Pending',
          _pendingBookings.toString(),
          Icons.pending_actions,
          Colors.orange,
        ),
        _buildStatCard(
          'Completed',
          _completedBookings.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Services',
          _popularServices.length.toString(),
          Icons.build,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._recentBookings.map(
          (booking) => BookingCard(
            booking: booking,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateStatusPage(booking: booking),
                ),
              );
            },
          ),
        ),
        if (_recentBookings.isEmpty)
          const Center(child: Text('No bookings found')),
      ],
    );
  }

  Widget _buildPopularServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Services',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._popularServices.map(
          (service) => ListTile(
            leading: const Icon(Icons.build, color: Colors.blue),
            title: Text(service.name),
            subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
            trailing: Text('${service.durationMinutes} min'),
          ),
        ),
        if (_popularServices.isEmpty)
          const Center(child: Text('No services found')),
      ],
    );
  }
}
