import 'package:flutter/material.dart';

class BuildingDetailsScreen extends StatelessWidget {
  final String name;
  final List<String> departments;
  final String timings;

  const BuildingDetailsScreen({
    super.key,
    required this.name,
    required this.departments,
    required this.timings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Departments:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...departments.map((dept) => Text('- $dept')).toList(),
            const SizedBox(height: 20),
            const Text('Timings:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(timings),
          ],
        ),
      ),
    );
  }
}
