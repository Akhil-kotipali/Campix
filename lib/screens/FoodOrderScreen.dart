import 'package:flutter/material.dart';

class FoodOrderScreen extends StatefulWidget {
  const FoodOrderScreen({super.key});

  @override
  _FoodOrderScreenState createState() => _FoodOrderScreenState();
}

class _FoodOrderScreenState extends State<FoodOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Simulated order list (in-memory storage)
  final List<Map<String, dynamic>> _orders = [];

  // Form fields
  String name = '';
  String foodItem = '';
  int quantity = 1;
  TimeOfDay? pickupTime;

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
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Order Placed'),
          content: Text('Thank you, $name!\nYour order has been saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );

      _formKey.currentState!.reset();
      pickupTime = null;
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
    if (_orders.isEmpty) {
      return const Text('No orders yet.');
    }

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
      appBar: AppBar(title: const Text('Pre-Order Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Your Name'),
                      validator: (value) =>
                      value!.isEmpty ? 'Enter your name' : null,
                      onSaved: (value) => name = value!,
                    ),
                    // Food Item
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Food Item'),
                      validator: (value) =>
                      value!.isEmpty ? 'Enter food item' : null,
                      onSaved: (value) => foodItem = value!,
                    ),
                    // Quantity
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
                    const SizedBox(height: 16),
                    // Pickup Time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pickupTime == null
                                ? 'No pickup time selected'
                                : 'Pickup Time: ${pickupTime!.format(context)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _pickTime,
                          child: const Text('Pick Time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: const Text('Submit Order'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const Text('Submitted Orders:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildOrderList(),
            ],
          ),
        ),
      ),
    );
  }
}
