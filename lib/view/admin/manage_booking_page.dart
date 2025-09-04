import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:aplikasi_bengkel_motor/widgets/booking_card.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class ManageBookingsPage extends StatefulWidget {
  const ManageBookingsPage({super.key});
  static const id = "/manage_booking";
  @override
  State<ManageBookingsPage> createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final response = await BengkelAPI.getAllBookings();
      if (response.success) {
        setState(() {
          _bookings = response.data!;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading bookings: $e'),
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
      appBar: AppBar(title: const Text('Manage Bookings')),
      body: _isLoading
          ? const LoadingIndicator()
          : _bookings.isEmpty
          ? const Center(child: Text('No bookings found'))
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  final booking = _bookings[index];
                  return BookingCard(
                    booking: booking,
                    onTap: () {
                      // Show booking details
                    },
                  );
                },
              ),
            ),
    );
  }
}
