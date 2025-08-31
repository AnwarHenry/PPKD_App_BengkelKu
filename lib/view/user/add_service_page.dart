import 'package:aplikasi_bengkel_motor/API/bengkel_API.dart';
import 'package:flutter/material.dart';

import 'history_page.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  String? selectedVehicle;
  final TextEditingController complaintController = TextEditingController();
  bool isLoading = false;

  Future<void> _submitService() async {
    if (selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih jenis kendaraan")),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await BengkelAPI.addService(
      selectedVehicle!,
      complaintController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service berhasil ditambahkan!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HistoryPage(historyList: [],)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan service")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Service")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedVehicle,
              items: const [
                DropdownMenuItem(
                  value: "Motor Bebek",
                  child: Text("Motor Bebek"),
                ),
                DropdownMenuItem(
                  value: "Motor Matic",
                  child: Text("Motor Matic"),
                ),
                DropdownMenuItem(
                  value: "Motor Sport",
                  child: Text("Motor Sport"),
                ),
                DropdownMenuItem(
                  value: "Motor Trail",
                  child: Text("Motor Trail"),
                ),
              ],
              hint: const Text("Pilih Jenis Kendaraan"),
              onChanged: (value) => setState(() => selectedVehicle = value),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: complaintController,
              decoration: const InputDecoration(
                labelText: "Problem Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _submitService,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Service"),
            ),
          ],
        ),
      ),
    );
  }
}
