import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  List<Map<String, dynamic>> listings = [];

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('marketplaceListings');
    if (data != null) {
      setState(() {
        listings = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveListings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('marketplaceListings', json.encode(listings));
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String contact = '';
    String category = 'Books';
    String price = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Listing'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => title = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => description = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price (Rs)'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => price = val ?? '0',
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Books', 'Electronics', 'Services', 'Others']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => category = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Contact Info'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => contact = val!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                setState(() {
                  listings.add({
                    'title': title,
                    'description': description,
                    'price': price,
                    'category': category,
                    'contact': contact,
                  });
                });
                _saveListings();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Marketplace')),
      body: listings.isEmpty
          ? const Center(child: Text('No items yet. Tap + to add.'))
          : ListView.builder(
        itemCount: listings.length,
        itemBuilder: (_, index) {
          final item = listings[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(item['title']),
              subtitle: Text('${item['description']}\nRs. ${item['price']} | ${item['category']}'),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Contact Seller'),
                      content: Text(item['contact']),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
