import 'package:flutter/material.dart';
import 'BuildingDetailsScreen.dart';
import 'package:campix/screens/building_details_screen.dart'; // We’ll create this next

class CampusNavigationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> buildings = [
    {
      'name': 'Engineering Block',
      'departments': ['Mechanical', 'Electrical', 'Civil'],
      'timings': '8:00 AM - 6:00 PM'
    },
    {
      'name': 'Science Block',
      'departments': ['Physics', 'Chemistry', 'Biology'],
      'timings': '9:00 AM - 5:00 PM'
    },
    {
      'name': 'Library',
      'departments': ['Archives', 'Digital Library'],
      'timings': '8:00 AM - 8:00 PM'
    },
    {
      'name': 'Admin Office',
      'departments': ['Admissions', 'Finance', 'Exams'],
      'timings': '9:00 AM - 4:00 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Navigation'),
      ),
      body: ListView.builder(
        itemCount: buildings.length,
        itemBuilder: (context, index) {
          final building = buildings[index];
          return ListTile(
            title: Text(building['name']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuildingDetailsScreen(
                    name: building['name'],
                    departments: List<String>.from(building['departments']),
                    timings: building['timings'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
