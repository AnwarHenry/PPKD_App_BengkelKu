import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class BookingServicePage extends StatefulWidget {
  const BookingServicePage({super.key});
  static const id = "/booking_service_page";

  @override
  State<BookingServicePage> createState() => _BookingServicePageState();
}

class _BookingServicePageState extends State<BookingServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleTypeController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _notesController = TextEditingController();

  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final response = await BengkelAPI.getServis();
      if (response.success) {
        setState(() {
          _services = response.data!;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading services: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate() && _selectedService != null) {
      try {
        final response = await BengkelAPI.createBooking(
          vehicleType: _vehicleTypeController.text,
          licensePlate: _licensePlateController.text,
          serviceType: _selectedService!.name,
          scheduledDate: _selectedDate,
          additionalNotes: _notesController.text,
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
            content: Text('Error creating booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Service')),
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
                      controller: _licensePlateController,
                      decoration: const InputDecoration(
                        labelText: 'Plat Nomor',
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan plat nomor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<ServiceModel>(
                      initialValue: _selectedService,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Service',
                        prefixIcon: Icon(Icons.build),
                      ),
                      items: _services.map((ServiceModel service) {
                        return DropdownMenuItem<ServiceModel>(
                          value: service,
                          child: Text(
                            '${service.name} - Rp ${service.price.toStringAsFixed(0)}',
                          ),
                        );
                      }).toList(),
                      onChanged: (ServiceModel? newValue) {
                        setState(() {
                          _selectedService = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Harap pilih jenis service';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Service',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Tambahan (Opsional)',
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitBooking,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Booking Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
