import 'package:aplikasi_bengkel_motor/extension/navigation.dart';
import 'package:aplikasi_bengkel_motor/services/api/service_api.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final TextEditingController bookingDateController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  final List<String> vehicleTypes = [
    "Motor Matic",
    "Motor Bebek",
    "Motor Sport",
    "Motor Trail",
    "Motor Moge",
  ];

  String? selectedVehicleType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Service"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A2463), // Warna header diubah
        foregroundColor: Colors.white, // Warna teks dan icon di header
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0A2463),
                    Color(0xFF1E3A8A),
                  ], // Gradient baru
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white, // Warna icon diubah menjadi putih
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Booking Service Motor Anda",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.white, // Warna teks diubah menjadi putih
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Isi form di bawah untuk membuat booking service kendaraan anda",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ), // Warna teks diubah
                  ),
                ],
              ),
            ),

            height(24),

            // Booking Date Field
            buildTitle("Tanggal Booking"),
            height(8),
            buildDateField(),

            height(16),

            // Vehicle Type Field
            buildTitle("Jenis Kendaraan"),
            height(8),
            buildVehicleDropdown(),

            height(16),

            // Description Field
            buildTitle("Deskripsi Servis"),
            height(8),
            buildTextField(
              controller: descriptionController,
              hintText: "Contoh: Ganti oli, servis ringan, perbaikan rem, dll",
              maxLines: 4,
            ),

            height(32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF0A2463,
                  ), // Warna tombol diubah
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Buat Booking"),
              ),
            ),

            height(16),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2463).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0A2463).withOpacity(0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Color(0xFF0A2463), size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Informasi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Booking akan dikonfirmasi dalam 24 jam\n• Pastikan kendaraan dalam kondisi bisa dikendarai\n• Bawa surat-surat kendaraan saat datang",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGray,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.mediumGray.withOpacity(0.7)),
      ),
    );
  }

  Widget buildDateField() {
    return TextField(
      controller: bookingDateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Pilih tanggal booking",
        hintStyle: TextStyle(color: AppColors.mediumGray.withOpacity(0.7)),
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF0A2463)),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null) {
          bookingDateController.text =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        }
      },
    );
  }

  Widget buildVehicleDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedVehicleType,
      decoration: InputDecoration(
        hintText: "Pilih jenis kendaraan",
        hintStyle: TextStyle(color: AppColors.mediumGray.withOpacity(0.7)),
      ),
      items: vehicleTypes.map((String type) {
        return DropdownMenuItem<String>(value: type, child: Text(type));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedVehicleType = newValue;
          vehicleTypeController.text = newValue ?? "";
        });
      },
    );
  }

  SizedBox height(double height) => SizedBox(height: height);

  Future<void> submitBooking() async {
    final bookingDate = bookingDateController.text.trim();
    final vehicleType = vehicleTypeController.text.trim();
    final description = descriptionController.text.trim();

    if (bookingDate.isEmpty || vehicleType.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi"),
          backgroundColor: AppColors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ServiceApi.bookingService(
        bookingDate: bookingDate,
        vehicleType: vehicleType,
        description: description,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Booking berhasil dibuat"),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Clear form
        bookingDateController.clear();
        vehicleTypeController.clear();
        descriptionController.clear();
        setState(() {
          selectedVehicleType = null;
        });

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: AppColors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    bookingDateController.dispose();
    vehicleTypeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
