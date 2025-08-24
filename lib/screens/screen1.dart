import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class LostFoundItem {
  final String title;
  final String description;
  final double mapX;
  final double mapY;
  final String markerColor;
  final DateTime createdAt;

  LostFoundItem({
    required this.title,
    required this.description,
    required this.mapX,
    required this.mapY,
    required this.markerColor,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'mapX': mapX,
      'mapY': mapY,
      'markerColor': markerColor,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LostFoundItem.fromMap(Map<String, dynamic> map) {
    return LostFoundItem(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      mapX: (map['mapX'] as num).toDouble(),
      mapY: (map['mapY'] as num).toDouble(),
      markerColor: map['markerColor'] ?? 'blue',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TransformationController _transformationController = TransformationController();
  List<LostFoundItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items') ?? '[]';
    final List<dynamic> decoded = jsonDecode(jsonString);
    setState(() {
      _items = decoded.map((e) => LostFoundItem.fromMap(e)).toList();
    });
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_items.map((e) => e.toMap()).toList());
    await prefs.setString('items', jsonString);
  }

  void _handleTap(BuildContext context, TapDownDetails details) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);

    final inverseMatrix = Matrix4.inverted(_transformationController.value);
    final transformedPos = MatrixUtils.transformPoint(inverseMatrix, localPosition);

    final result = await _showItemDialog(context);
    if (result != null) {
      final newItem = LostFoundItem(
        title: result['title']!,
        description: result['description']!,
        markerColor: result['color']!,
        mapX: transformedPos.dx,
        mapY: transformedPos.dy,
        createdAt: DateTime.now(),
      );
      setState(() {
        _items.add(newItem);
      });
      await _saveItems();
    }
  }

  Future<Map<String, String>?> _showItemDialog(BuildContext context,
      {LostFoundItem? existing}) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    String selectedColor = existing?.markerColor ?? 'blue';

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Enter Item Details' : 'Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedColor,
              items: ['blue', 'red', 'green', 'orange']
                  .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                  .toList(),
              onChanged: (value) => setState(() => selectedColor = value ?? 'blue'),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'description': descController.text,
                  'color': selectedColor,
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    await _saveItems();
  }

  void _editItem(int index) async {
    final item = _items[index];
    final result = await _showItemDialog(context, existing: item);
    if (result != null) {
      setState(() {
        _items[index] = LostFoundItem(
          title: result['title']!,
          description: result['description']!,
          markerColor: result['color']!,
          mapX: item.mapX,
          mapY: item.mapY,
          createdAt: item.createdAt,
        );
      });
      await _saveItems();
    }
  }

  void _exportToJson() {
    final jsonString = jsonEncode(_items.map((e) => e.toMap()).toList());
    Share.share(jsonString, subject: 'Lost & Found Data Export');
  }

  void _showItemDetails(LostFoundItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.description),
            const SizedBox(height: 10),
            Text('Added: ${_formatDateTime(item.createdAt)}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  Color _getMarkerColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dt.month - 1];
    final day = dt.day;
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    return '$month $day, $year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found (Upgraded)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _exportToJson,
            tooltip: 'Export to JSON',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) => _handleTap(context, details),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.7,
                    maxScale: 2.0,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/map.jpg',
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          fit: BoxFit.contain,
                        ),
                        for (int i = 0; i < _items.length; i++)
                          Positioned(
                            left: _items[i].mapX - 16,
                            top: _items[i].mapY - 32,
                            child: GestureDetector(
                              onTap: () => _showItemDetails(_items[i]),
                              child: Icon(Icons.location_on,
                                  color: _getMarkerColor(_items[i].markerColor), size: 28),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: _items.isEmpty
                ? const Center(child: Text('No items found'))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(
                    '${item.description}\nAdded: ${_formatDateTime(item.createdAt)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(index),
                  ),
                  onLongPress: () => _editItem(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
