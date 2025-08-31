import 'package:flutter/material.dart';

import 'history_detail_page.dart';

// Contoh model (ambil dari API)
class ServiceHistory {
  final String id;
  final String bookingDate;
  final String vehicleType;
  final String description;
  // final double cost;
  // final String status;

  ServiceHistory({
    required this.id,
    required this.bookingDate,
    required this.vehicleType,
    required this.description,
    // required this.cost,
    // required this.status,
  });
}

class HistoryPage extends StatelessWidget {
  final List<ServiceHistory> historyList;

  const HistoryPage({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3866),
        elevation: 0,
        title: const Text(
          "Riwayat Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item.vehicleType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF0B3866),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("Tanggal: ${item.bookingDate}"),
                  Text("Keluhan: ${item.description}"),
                  // Text("Biaya: Rp${item.cost.toStringAsFixed(0)}"),
                  const SizedBox(height: 6),
                  // Chip(
                  //   label: Text(
                  //     item.status,
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  //   backgroundColor: item.status == "Selesai"
                  //       ? Colors.green
                  //       : Colors.orange,
                  // ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF0B3866),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryDetailPage(service: item, id: index),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
