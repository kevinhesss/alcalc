import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkFormPage extends StatefulWidget {
  @override
  _DrinkFormPageState createState() => _DrinkFormPageState();
}

class _DrinkFormPageState extends State<DrinkFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abvController = TextEditingController();
  final TextEditingController _containerSizeController = TextEditingController();

  Future<void> _submitDrink() async {
    final String name = _nameController.text;
    final String abv = _abvController.text;
    final String containerSize = _containerSizeController.text;

    if (name.isNotEmpty && abv.isNotEmpty && containerSize.isNotEmpty) {
      try {
        // Add a new document to the "Suggestions" collection
        await FirebaseFirestore.instance.collection('Suggestions').add({
          'name': name,
          'abv': double.tryParse(abv) ?? 0.0, // Convert ABV to float
          'container_size': containerSize,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Drink submitted successfully!')),
        );

        // Clear the text fields
        _nameController.clear();
        _abvController.clear();
        _containerSizeController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit drink: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a New Drink'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Drink Name'),
            ),
            TextField(
              controller: _abvController,
              decoration: InputDecoration(labelText: 'ABV (in %)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _containerSizeController,
              decoration: InputDecoration(labelText: 'Container Size (e.g., 12 oz, 500 ml)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDrink,
              child: Text('Submit Drink'),
            ),
            SizedBox(height: 20), // Adds space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // This will take you back to the previous page (Main page)
              },
              child: Text('Back to Main Page'),
            ),
          ],
        ),
      ),
    );
  }
}
