import 'package:flutter/material.dart';

import 'history_page.dart';

class DashboardPage extends StatelessWidget {
  final String username;
  const DashboardPage({super.key, required this.username});
  static const id = "/dashboard_page";

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> history = [
      {
        "service": "Ganti Oli",
        "date": "25 Agustus 2025",
        "status": "Selesai",
        "vehicle": "Supra X 125",
        "cost": "Rp 150.000",
        "desc": "Oli mesin habis, perlu ganti oli baru",
      },
      {
        "service": "Servis Rutin",
        "date": "20 Juli 2025",
        "status": "Selesai",
        "vehicle": "Vario 150",
        "cost": "Rp 300.000",
        "desc": "Perawatan berkala",
      },
      {
        "service": "Ganti Ban",
        "date": "15 Juni 2025",
        "status": "Pending",
        "vehicle": "NMax 155",
        "cost": "Rp 500.000",
        "desc": "Ban belakang tipis, menunggu stok ban baru",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3866),
        elevation: 0,
        title: const Text(
          "Dashboard BengkelKu",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header User Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B3866), Color(0xFF0B3866)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang,",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status Order Terbaru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status Order Terbaru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tampilkan data paling baru
                  Text(
                    history[0]["vehicle"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Service: ${history[0]["service"]!}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "Tanggal: ${history[0]["date"]!}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "Biaya: ${history[0]["cost"]!}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(
                        history[0]["status"]!,
                        style: TextStyle(
                          color: history[0]["status"] == "Selesai"
                              ? Colors.green
                              : Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(historyList: [],),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B3866),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const Text(
                        "Lihat Riwayat",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Riwayat Service Singkat
            const Text(
              "Riwayat Service",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tidak pakai gambar/icon lagi, hanya teks
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item["vehicle"]} - ${item["service"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tanggal: ${item["date"]!}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "Biaya: ${item["cost"]!}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              "Catatan: ${item["desc"]!}",
                              style: const TextStyle(color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item["status"]!,
                        style: TextStyle(
                          color: item["status"] == "Selesai"
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
