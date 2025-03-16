import 'package:flutter/material.dart';

class SelectedFoodItemsScreen extends StatelessWidget {
  final List<dynamic> selectedFoodItems;

  SelectedFoodItemsScreen({required this.selectedFoodItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Food Items'),
        backgroundColor: Colors.green,
      ),
      body: selectedFoodItems.isNotEmpty
          ? ListView.builder(
        itemCount: selectedFoodItems.length,
        itemBuilder: (context, index) {
          final item = selectedFoodItems[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                item['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${item['category']}'),
                  Text('Calories: ${item['calories']}'),
                  Text('Protein: ${item['protein']}g, Fat: ${item['fat']}g, Carbs: ${item['carbs']}g'),
                ],
              ),
            ),
          );
        },
      )
          : Center(child: Text('No selected items')),
    );
  }
}
