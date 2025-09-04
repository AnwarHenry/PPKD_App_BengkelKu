import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class ServiceStatsPage extends StatefulWidget {
  const ServiceStatsPage({super.key});
  static const id = "/service_stats";
  @override
  State<ServiceStatsPage> createState() => _ServiceStatsPageState();
}

class _ServiceStatsPageState extends State<ServiceStatsPage> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final response = await BengkelAPI.getAdminStats();
      if (response.success) {
        setState(() {
          _stats = response.data!;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading stats: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Statistics')),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard(
                    'Total Bookings',
                    _stats['total_bookings']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    'Pending Bookings',
                    _stats['pending_bookings']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    'Completed Bookings',
                    _stats['completed_bookings']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    'Total Revenue',
                    '\$${_stats['total_revenue']?.toString() ?? '0'}',
                  ),
                  _buildStatCard(
                    'Active Users',
                    _stats['active_users']?.toString() ?? '0',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
