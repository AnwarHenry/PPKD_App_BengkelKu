import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class BuatServicePage extends StatefulWidget {
  const BuatServicePage({super.key});
  static const id = "/buat_service_page";

  @override
  State<BuatServicePage> createState() => _BuatServicePageState();
}

class _BuatServicePageState extends State<BuatServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleTypeController = TextEditingController();
  final _complaintController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitServiceRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await BengkelAPI.createBooking(
          vehicleType: _vehicleTypeController.text,
          licensePlate: 'TEMP',
          serviceType: 'Custom Service',
          scheduledDate: DateTime.now(),
          additionalNotes: _complaintController.text,
        );

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating service request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Service Request')),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _vehicleTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kendaraan',
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan jenis kendaraan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _complaintController,
                      decoration: const InputDecoration(
                        labelText: 'Keluhan/Kebutuhan Service',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan keluhan atau kebutuhan service';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitServiceRequest,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Kirim Request Service'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
