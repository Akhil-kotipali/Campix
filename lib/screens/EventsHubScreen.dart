import 'package:flutter/material.dart';

class EventsHubScreen extends StatefulWidget {
  const EventsHubScreen({super.key});

  @override
  State<EventsHubScreen> createState() => _EventsHubScreenState();
}

class _EventsHubScreenState extends State<EventsHubScreen> {
  // Sample event list
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Clean-Up Drive',
      'date': '2025-09-01',
      'description': 'Join us in keeping the campus clean!',
      'rsvped': false,
    },
    {
      'title': 'Tech Talk: AI & Future',
      'date': '2025-09-05',
      'description': 'Hear experts talk about AI trends.',
      'rsvped': false,
    },
    {
      'title': 'Cultural Fest',
      'date': '2025-09-10',
      'description': 'Enjoy music, dance, and food.',
      'rsvped': false,
    },
  ];

  void _toggleRSVP(int index) {
    setState(() {
      _events[index]['rsvped'] = !_events[index]['rsvped'];
    });

    final status = _events[index]['rsvped'] ? 'registered' : 'cancelled';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have $status for "${_events[index]['title']}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events Hub'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(event['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${event['date']}'),
                  const SizedBox(height: 4),
                  Text(event['description']),
                ],
              ),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () => _toggleRSVP(index),
                child: Text(event['rsvped'] ? 'Cancel' : 'RSVP'),
              ),
            ),
          );
        },
      ),
    );
  }
}
