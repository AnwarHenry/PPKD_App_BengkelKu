import 'package:aplikasi_bengkel_motor/models/service_model.dart';
import 'package:aplikasi_bengkel_motor/services/api/service_api.dart';
import 'package:aplikasi_bengkel_motor/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  List<ServiceData> historyServices = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadServiceHistory();
  }

  Future<void> loadServiceHistory() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      print("🔍 Loading service history...");
      final response = await ServiceApi.getServiceHistory();
      print("📊 History response: ${response.message}");
      print("📊 History data count: ${response.data?.length ?? 0}");

      if (mounted) {
        setState(() {
          historyServices = response.data ?? [];
          isLoading = false;
        });

        // If no history data, try loading from regular services with "Selesai" status
        if (historyServices.isEmpty) {
          print("📊 No history data, checking regular services...");
          _loadCompletedServicesAsHistory();
        }
      }
    } catch (e) {
      print("❌ History error: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = e.toString().replaceAll("Exception: ", "");
        });
      }
    }
  }

  // Fallback: Load services with status "Selesai" as history
  Future<void> _loadCompletedServicesAsHistory() async {
    try {
      print("🔍 Loading completed services as history...");
      final allServicesResponse = await ServiceApi.getAllServices();
      final completedServices =
          allServicesResponse.data
              ?.where((service) => service.status?.toLowerCase() == 'selesai')
              .toList() ??
          [];

      print("📊 Found ${completedServices.length} completed services");

      if (mounted) {
        setState(() {
          historyServices = completedServices;
        });
      }
    } catch (e) {
      print("❌ Fallback history error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A2463), Color(0xFF1E3A8A)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: AppColors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Riwayat Service",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Lihat riwayat service yang telah selesai",
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadServiceHistory,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.infoBlue),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: AppColors.redAccent),
            const SizedBox(height: 16),
            Text(
              "Error: $errorMessage",
              style: const TextStyle(color: AppColors.redAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadServiceHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.infoBlue,
              ),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (historyServices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_outlined, size: 64, color: AppColors.mediumGray),
            SizedBox(height: 16),
            Text(
              "Belum ada riwayat service",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Riwayat service akan muncul setelah service selesai",
              style: TextStyle(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyServices.length,
      itemBuilder: (context, index) {
        final service = historyServices[index];
        return _buildHistoryCard(service, index);
      },
    );
  }

  Widget _buildHistoryCard(ServiceData service, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.successGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.vehicleType ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.complaint ?? "-",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.successGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.successGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.status ?? "Selesai",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Divider
            Container(height: 1, color: AppColors.mediumGray.withOpacity(0.2)),

            const SizedBox(height: 12),

            // Details
            Row(
              children: [
                _buildDetailItem(
                  Icons.access_time,
                  "Tanggal Mulai",
                  _formatDate(service.createdAt),
                ),
                const SizedBox(width: 24),
                _buildDetailItem(
                  Icons.update,
                  "Selesai",
                  _formatDate(service.updatedAt),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _buildDetailItem(
                  Icons.tag,
                  "ID Service",
                  "#${service.id ?? 0}",
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showServiceDetail(service),
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text("Detail"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.infoBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color.fromARGB(255, 111, 161, 165)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 7, 67, 128),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showServiceDetail(ServiceData service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detail Service"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("ID Service", "#${service.id ?? 0}"),
              _buildDetailRow("Jenis Kendaraan", service.vehicleType ?? "-"),
              _buildDetailRow("Keluhan", service.complaint ?? "-"),
              _buildDetailRow("Status", service.status ?? "-"),
              _buildDetailRow("Tanggal Mulai", _formatDate(service.createdAt)),
              _buildDetailRow(
                "Tanggal Selesai",
                _formatDate(service.updatedAt),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "-";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}
