import 'package:flutter/material.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> {
  final Map<String, int> _points = {
    'Alice': 40,
    'Bob': 25,
    'Charlie': 15,
    'David': 30,
  };

  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _redeemController = TextEditingController();

  void _awardPoints() {
    final name = _studentController.text.trim();
    final points = int.tryParse(_pointsController.text);

    if (name.isEmpty || points == null || points <= 0) return;

    setState(() {
      _points[name] = (_points[name] ?? 0) + points;
      _studentController.clear();
      _pointsController.clear();
    });
  }

  void _redeemPoints() {
    final name = _studentController.text.trim();
    final redeem = int.tryParse(_redeemController.text);

    if (name.isEmpty || redeem == null || redeem <= 0) return;

    if ((_points[name] ?? 0) >= redeem) {
      setState(() {
        _points[name] = _points[name]! - redeem;
        _redeemController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name redeemed $redeem points!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name does not have enough points.')),
      );
    }
  }

  List<MapEntry<String, int>> _getSortedLeaderboard() {
    final entries = _points.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = _getSortedLeaderboard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification & Points'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Award Points',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _studentController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Points to Award'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _awardPoints,
              child: const Text('Award Points'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Redeem Points',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _redeemController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Points to Redeem'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _redeemPoints,
              child: const Text('Redeem'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Leaderboard',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Column(
              children: leaderboard.map((entry) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(entry.value.toString()),
                  ),
                  title: Text(entry.key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
