import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Grocerylist.dart';
import 'fooditems.dart';

class DietPlanScreen extends StatefulWidget {

  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  List<dynamic> foodItems = [];
  List<List<dynamic>> filteredCombinations = [];
  String calorieInput = "";
  String selectedGoal = 'Gain';
  String allergyInput = "";
  bool isLoading = false;

  final List<String> goals = ['Gain', 'Lose'];
  final String url = 'http://192.168.100.22/fooddatabase/db.php'; // Update to your IP

  final _formKey = GlobalKey<FormState>(); // Key for the form to manage validation

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          foodItems = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load food items, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching food items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load food items. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterFoodItemsByCalories() {
    if (_formKey.currentState!.validate()) {
      final int desiredCalories = int.tryParse(calorieInput) ?? 0;
      final List<String> allergyList = allergyInput.toLowerCase().split(',').map((e) => e.trim()).toList();

      setState(() {
        filteredCombinations = [];
        for (int i = 0; i < foodItems.length; i++) {
          for (int j = i + 1; j < foodItems.length; j++) {
            for (int k = j + 1; k < foodItems.length; k++) {
              int totalCalories =
                  (int.tryParse(foodItems[i]['calories'].toString()) ?? 0) +
                      (int.tryParse(foodItems[j]['calories'].toString()) ?? 0) +
                      (int.tryParse(foodItems[k]['calories'].toString()) ?? 0);

              // Filter by goal and calories
              bool calorieMatch = (selectedGoal == 'Gain' && totalCalories >= desiredCalories) ||
                  (selectedGoal == 'Lose' && totalCalories <= desiredCalories);

              // Filter by allergies (check if any ingredient contains any allergy)
              bool allergyMatch = true;
              for (var food in [foodItems[i], foodItems[j], foodItems[k]]) {
                String ingredients = food['ingredients']?.toLowerCase() ?? '';
                for (String allergy in allergyList) {
                  if (ingredients.contains(allergy)) {
                    allergyMatch = false;
                    break;
                  }
                }
              }

              // Only add the combination if both calorie and allergy conditions match
              if (calorieMatch && allergyMatch) {
                filteredCombinations.add([foodItems[i], foodItems[j], foodItems[k]]);
              }
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Diet Plan by Calories'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroceryList()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedFoodItemsScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input field for calorie input
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter daily calorie intake',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    calorieInput = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a calorie amount';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Dropdown for Gain or Lose
              DropdownButtonFormField<String>(
                value: selectedGoal,
                decoration: InputDecoration(
                  labelText: 'Select Goal',
                  border: OutlineInputBorder(),
                ),
                items: goals.map((goal) {
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(goal),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGoal = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Input field for allergies
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter allergies (comma separated)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    allergyInput = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter allergies';
                  } else if (RegExp(r'^[0-9]').hasMatch(value)) {
                    return 'Please enter valid allergy text (no numbers)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Button to filter food items
              Center(
                child: ElevatedButton(
                  onPressed: filterFoodItemsByCalories,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor: Colors.green, // Button background color
                  ),
                  child: Text('Generate Diet Plan'),
                ),
              ),
              SizedBox(height: 16),

              // Show filtered combinations
              Expanded(
                child: filteredCombinations.isNotEmpty
                    ? ListView.builder(
                  itemCount: filteredCombinations.length,
                  itemBuilder: (context, index) {
                    final combination = filteredCombinations[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          '${combination[0]['name']} (Breakfast), ${combination[1]['name']} (Lunch), ${combination[2]['name']} (Dinner)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Total Calories: ${(int.tryParse(combination[0]['calories'].toString()) ?? 0) + (int.tryParse(combination[1]['calories'].toString()) ?? 0) + (int.tryParse(combination[2]['calories'].toString()) ?? 0)}',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodItemDetailScreen(foodItem: combination),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
                    : Center(child: Text('No combinations match your selection')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedFoodItemsScreen extends StatelessWidget {
  final List<dynamic> selectedFoodItems;

  SelectedFoodItemsScreen({required this.selectedFoodItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selected Food Items')),
      body: ListView.builder(
        itemCount: selectedFoodItems.length,
        itemBuilder: (context, index) {
          final item = selectedFoodItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Calories: ${item['calories']}'),
          );
        },
      ),
    );
  }
}
