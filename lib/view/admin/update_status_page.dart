import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:flutter/material.dart';

class UpdateStatusPage extends StatefulWidget {
  final BookingModel booking;
  static const id = "/update_status";

  const UpdateStatusPage({super.key, required this.booking});

  @override
  State<UpdateStatusPage> createState() => _UpdateStatusPageState();
}

class _UpdateStatusPageState extends State<UpdateStatusPage> {
  String? _selectedStatus;
  bool _isLoading = false;

  final List<String> _statusOptions = [
    'pending',
    'confirmed',
    'in_progress',
    'completed',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.booking.status;
  }

  Future<void> _updateStatus() async {
    if (_selectedStatus == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await BengkelAPI.updateBookingStatus(
        bookingId: widget.booking.id,
        status: _selectedStatus!,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Status')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${widget.booking.id}'),
            Text('Customer: ${widget.booking.userName}'),
            Text('Vehicle: ${widget.booking.vehicleType}'),
            Text('Service: ${widget.booking.serviceType}'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status.replaceAll('_', ' ').toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateStatus,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
