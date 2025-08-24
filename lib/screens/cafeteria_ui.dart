import 'package:flutter/material.dart';

enum QueueLevel { low, medium, high }

// ============ HOME SCREEN ============
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafeteria App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/queue-status');
              },
              child: const Text('View Queue Status'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/preorder-food');
              },
              child: const Text('Pre-order Food'),
            ),


          ],
        ),
      ),
    );
  }
}

// ============ QUEUE STATUS SCREEN ============
class QueueStatusScreen extends StatefulWidget {
  final QueueLevel currentLevel;

  const QueueStatusScreen({super.key, required this.currentLevel});

  @override
  State<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  late QueueLevel selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: QueueLevel.values.map((level) {
            return Card(
              color: selectedLevel == level ? getColor(level).withOpacity(0.3) : null,
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
      ),
    );
  }
}

// ============ PRE-ORDER SCREEN ============
class PreOrderScreen extends StatefulWidget {
  const PreOrderScreen({super.key});

  @override
  State<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> foodMenu = [
    {'name': 'Burger', 'price': 5.99},
    {'name': 'Pizza', 'price': 8.49},
    {'name': 'Salad', 'price': 4.50},
    {'name': 'Coffee', 'price': 2.00},
    {'name': 'Sandwich', 'price': 3.75},
  ];

  String? selectedFoodItem;
  double selectedFoodPrice = 0.0;
  int quantity = 1;
  String name = '';
  TimeOfDay? pickupTime;
  final List<Map<String, dynamic>> _orders = [];

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

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newOrder = {
        'name': name,
        'foodItem': selectedFoodItem,
        'quantity': quantity,
        'pickupTime': pickupTime?.format(context) ?? 'Not selected',
        'totalPrice': selectedFoodPrice * quantity,
      };

      setState(() {
        _orders.add(newOrder);
        _formKey.currentState!.reset();
        pickupTime = null;
        selectedFoodItem = null;
        selectedFoodPrice = 0.0;
        quantity = 1;
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

  Widget _buildOrderList() {
    if (_orders.isEmpty) return const Text('No orders yet.');

    return Column(
      children: _orders.map((order) {
        return ListTile(
          title: Text('${order['foodItem']} x${order['quantity']}'),
          subtitle: Text('Pickup: ${order['pickupTime']} - ${order['name']}'),
          trailing: Text('\$${order['totalPrice'].toStringAsFixed(2)}'),
        );
      }).toList(),
    );
  }

  double get totalAmount => selectedFoodPrice * quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-order Food')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Your Name'),
                    validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter your name' : null,
                    onSaved: (value) => name = value!,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Food Item'),
                    value: selectedFoodItem,
                    items: foodMenu.map((food) {
                      return DropdownMenuItem<String>(
                        value: food['name'],
                        child: Text('${food['name']} (\$${food['price'].toStringAsFixed(2)})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFoodItem = value;
                        selectedFoodPrice =
                        foodMenu.firstWhere((food) => food['name'] == value)['price'];
                      });
                    },
                    validator: (value) => value == null ? 'Select a food item' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter quantity';
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed <= 0) return 'Enter valid number';
                      return null;
                    },
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        setState(() {
                          quantity = parsed;
                        });
                      }
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
                  Text('Total: \$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Submit Order'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Submitted Orders:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildOrderList(),
          ],
        ),
      ),
    );
  }
}

// ============ MAIN FUNCTION ============
void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
