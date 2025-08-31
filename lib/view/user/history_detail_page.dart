import 'package:aplikasi_bengkel_motor/API/bengkel_API.dart';
import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:aplikasi_bengkel_motor/view/user/history_page.dart';
import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  final int id;
  const HistoryDetailPage({super.key, required this.id, required ServiceHistory service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Service")),
      body: FutureBuilder<ServiceModel>(
        future: BengkelAPI.getDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Detail tidak ditemukan"));
          }

          final service = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jenis Kendaraan: ${service.vehicleType}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Deskripsi: ${service.complaint}"),
                const SizedBox(height: 10),
                Text("Tanggal: ${service.createdAt}"),
                if (service.imageUrl != null) ...[
                  const SizedBox(height: 20),
                  Image.network(service.imageUrl!),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
