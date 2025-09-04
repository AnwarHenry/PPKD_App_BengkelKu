import 'package:aplikasi_bengkel_motor/view/admin/dashboard_admin.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_booking_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/manage_service_page.dart';
import 'package:aplikasi_bengkel_motor/view/admin/service_stats_page.dart';
import 'package:aplikasi_bengkel_motor/view/user/dashboard_user.dart';
import 'package:aplikasi_bengkel_motor/view/user/profile_page.dart';
import 'package:aplikasi_bengkel_motor/view/welcome_screen.dart';
// import 'package:bengkel_1/utils/role_checker.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isAdmin;

  const AppDrawer({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[800]),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BengkelKu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Professional Automotive Service',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          if (isAdmin) ...[
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pushReplacementNamed(context, AdminDashboard.id);
              },
            ),
            _buildDrawerItem(
              icon: Icons.book_online,
              title: 'Manage Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageBookingsPage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.build,
              title: 'Manage Services',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageServicesPage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.analytics,
              title: 'Statistics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServiceStatsPage()),
                );
              },
            ),
          ] else ...[
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pushReplacementNamed(context, UserDashboard.id);
              },
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: 'Booking History',
              onTap: () {
                // Navigate to booking history
              },
            ),
            _buildDrawerItem(
              icon: Icons.car_repair,
              title: 'My Vehicles',
              onTap: () {
                // Navigate to vehicles
              },
            ),
          ],
          const Divider(),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // Navigate to settings
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomeScreen.id,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
