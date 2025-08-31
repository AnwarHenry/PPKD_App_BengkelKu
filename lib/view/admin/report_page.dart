import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("User ${index + 1}"),
              subtitle: const Text("Service: Ganti oli"),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text("Update Status"),
              ),
            ),
          );
        },
      ),
    );
  }
}
