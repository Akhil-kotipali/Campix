import 'package:flutter/material.dart';

enum QueueLevel { low, medium, high }

class QueueStatusScreen extends StatefulWidget {
  final QueueLevel currentLevel;

  const QueueStatusScreen({super.key, required this.currentLevel});

  @override
  State<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  // Queue level tracking
  late QueueLevel selectedLevel;

  // Food order form fields
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String foodItem = '';
  int quantity = 1;
  TimeOfDay? pickupTime;
  final List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

  // Queue level helpers
  Color getColor(QueueLevel level) {
    switch (level) {
      case QueueLevel.low:
        return Colors.green;
      case QueueLevel.medium:
        return Colors.yellow;
      case QueueLevel.high:
        return Colors.red;
    }
  }

  String getLabel(QueueLevel level) {
    switch (level) {
      case QueueLevel.low:
        return 'Low (Green)';
      case QueueLevel.medium:
        return 'Medium (Yellow)';
      case QueueLevel.high:
        return 'High (Red)';
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newOrder = {
        'name': name,
        'foodItem': foodItem,
        'quantity': quantity,
        'pickupTime': pickupTime?.format(context) ?? 'Not selected',
      };

      setState(() {
        _orders.add(newOrder);
        _formKey.currentState!.reset();
        pickupTime = null;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Order Placed'),
          content: Text('Thanks, $name! Your order is saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        pickupTime = picked;
      });
    }
  }

  Widget _buildOrderList() {
    if (_orders.isEmpty) return const Text('No orders yet.');

    return Column(
      children: _orders.map((order) {
        return ListTile(
          title: Text('${order['foodItem']} x${order['quantity']}'),
          subtitle: Text('Pickup: ${order['pickupTime']} - ${order['name']}'),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafeteria Queue & Orders')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== QUEUE TRACKER SECTION =====
            const Text(
              'Queue Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: QueueLevel.values.map((level) {
                return Card(
                  color: selectedLevel == level
                      ? getColor(level).withOpacity(0.3)
                      : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getColor(level),
                    ),
                    title: Text(getLabel(level)),
                    trailing: Radio<QueueLevel>(
                      value: level,
                      groupValue: selectedLevel,
                      onChanged: (QueueLevel? value) {
                        setState(() {
                          selectedLevel = value!;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ===== PRE-ORDER FORM SECTION =====
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Pre-order Food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Your Name'),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter your name' : null,
                    onSaved: (value) => name = value!,
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Food Item'),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter food item' : null,
                    onSaved: (value) => foodItem = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter quantity';
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed <= 0) return 'Enter valid number';
                      return null;
                    },
                    onSaved: (value) => quantity = int.parse(value!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pickupTime == null
                              ? 'No pickup time selected'
                              : 'Pickup: ${pickupTime!.format(context)}',
                        ),
                      ),
                      TextButton(
                        onPressed: _pickTime,
                        child: const Text('Pick Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Submit Order'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== ORDER LIST =====
            const Divider(),
            const Text(
              'Submitted Orders:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildOrderList(),
          ],
        ),
      ),
  );}}