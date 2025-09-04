import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:aplikasi_bengkel_motor/widgets/booking_card.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class RiwayatServisPage extends StatefulWidget {
  const RiwayatServisPage({super.key});
  static const id = "/riwayat_servis_page";

  @override
  State<RiwayatServisPage> createState() => _RiwayatServisPageState();
}

class _RiwayatServisPageState extends State<RiwayatServisPage> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRiwayatServis();
  }

  Future<void> _loadRiwayatServis() async {
    try {
      final response = await BengkelAPI.getRiwayatServis();
      if (response.success) {
        setState(() {
          _bookings = response.data!;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading service history: $e'),
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
      appBar: AppBar(title: const Text('Riwayat Servis')),
      body: _isLoading
          ? const LoadingIndicator()
          : _bookings.isEmpty
          ? const Center(child: Text('Tidak ada riwayat servis'))
          : RefreshIndicator(
              onRefresh: _loadRiwayatServis,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  final booking = _bookings[index];
                  return BookingCard(
                    booking: booking,
                    onTap: () {
                      // Navigate to detail page if needed
                    },
                  );
                },
              ),
            ),
    );
  }
}
