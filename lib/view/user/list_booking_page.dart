import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:aplikasi_bengkel_motor/widgets/booking_card.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class ListBookingPage extends StatefulWidget {
  const ListBookingPage({super.key});
  static const id = "/list_booking_page";

  @override
  State<ListBookingPage> createState() => _ListBookingPageState();
}

class _ListBookingPageState extends State<ListBookingPage> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final response = await BengkelAPI.getUserBookings();
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
      appBar: AppBar(title: const Text('List Booking')),
      body: _isLoading
          ? const LoadingIndicator()
          : _bookings.isEmpty
          ? const Center(child: Text('Tidak ada booking'))
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
                      _showBookingDetails(booking);
                    },
                  );
                },
              ),
            ),
    );
  }

  void _showBookingDetails(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kendaraan: ${booking.vehicleType}'),
            Text('Plat: ${booking.licensePlate}'),
            Text('Service: ${booking.serviceType}'),
            Text('Status: ${booking.status}'),
            Text(
              'Tanggal: ${booking.scheduledDate.toString().substring(0, 10)}',
            ),
            Text('Biaya: Rp ${booking.totalCost.toStringAsFixed(0)}'),
            if (booking.additionalNotes != null)
              Text('Catatan: ${booking.additionalNotes}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
