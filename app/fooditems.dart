import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodItemDetailScreen extends StatefulWidget {
  final List<dynamic> foodItem;

  FoodItemDetailScreen({required this.foodItem});

  @override
  State<FoodItemDetailScreen> createState() => _FoodItemDetailScreenState();
}

class _FoodItemDetailScreenState extends State<FoodItemDetailScreen> {
  Set<int> selectedItems = {}; // Track selected food items
  Map<int, bool> showRecipe = {}; // To toggle the visibility of recipe details

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList('selectedFoodItems') ?? [];
    setState(() {
      selectedItems = savedItems.map((id) => int.parse(id)).toSet();
    });
  }

  Future<void> _saveSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedFoodItems', selectedItems.map((id) => id.toString()).toList());
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
            pw.Text(
            'Selected Food Items',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          ...widget.foodItem
              .where((item) => selectedItems.contains(int.parse(item['id']))).map((item) => pw.Container(
          margin: pw.EdgeInsets.only(bottom: 10),
          padding: pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
          pw.Text('Category: ${item['category']}',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text('Name: ${item['name']}', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Calories: ${item['calories']} kcal', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Protein: ${item['protein']} g', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Fat: ${item['fat']} g', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Carbs: ${item['carbs']} g', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Fiber: ${item['fiber']} g', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Serving Size: ${item['serving_size']}', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Description: ${item['description']}', style: pw.TextStyle(fontSize: 16)),
          ],
          ),
          )
          ),
          ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _saveAndOpenPdf() async {
    try {
      final pdfData = await _generatePdf();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/selected_food_items.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      OpenFile.open(filePath);
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Food Item Combination'),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: widget.foodItem.map((item) {
                  int id = int.parse(item['id']);
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedItems.contains(id),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedItems.add(id);
                                } else {
                                  selectedItems.remove(id);
                                }
                                _saveSelectedItems();
                              });
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${item['category']}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Divider(),
                                Text('Name: ${item['name']}', style: TextStyle(fontSize: 16)),
                                Text('Calories: ${item['calories']} kcal', style: TextStyle(fontSize: 16)),
                                Text('Protein: ${item['protein']} g', style: TextStyle(fontSize: 16)),
                                Text('Fat: ${item['fat']} g', style: TextStyle(fontSize: 16)),
                                Text('Carbs: ${item['carbs']} g', style: TextStyle(fontSize: 16)),
                                Text('Fiber: ${item['fiber']} g', style: TextStyle(fontSize: 16)),
                                Text('Serving Size: ${item['serving_size']}', style: TextStyle(fontSize: 16)),
                                Text('Description: ${item['description']}', style: TextStyle(fontSize: 16)),

                                // DropdownButton to toggle recipe details
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green, // Background color
                                    borderRadius: BorderRadius.circular(8), // Rounded corners
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12), // Padding inside the button
                                  child: DropdownButton<String>(
                                    value: showRecipe[id] == true ? 'Hide Recipe' : 'Show Recipe',
                                    items: ['Show Recipe', 'Hide Recipe'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.white), // Text color
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        showRecipe[id] = newValue == 'Show Recipe';
                                      });
                                    },
                                    underline: SizedBox(), // Removes the default underline
                                    dropdownColor: Colors.green, // Dropdown background color
                                  ),
                                ),


                                // Show recipe details when "Show Recipe" is selected
                                if (showRecipe[id] == true) ...[
                                  Text('Ingredients: ${item['ingredients']}', style: TextStyle(fontSize: 16)),
                                  Text('Instruction: ${item['instruction']}', style: TextStyle(fontSize: 16)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (selectedItems.isNotEmpty) {
                      await _saveAndOpenPdf();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No food item selected!')),
                      );
                    }
                  },
                  child: Text('Download PDF'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (widget.foodItem.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecipeScreen(
                            foodItemId: int.parse(widget.foodItem[0]["id"]),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No food item available')),
                      );
                    }
                  },
                  child: Text('Add Your Recipe'),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SavedFoodItemsScreen extends StatelessWidget {
  Future<List<String>> _loadSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('selectedFoodItems') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
          title: Text('Saved Food Items')),
      body: FutureBuilder<List<String>>(
        future: _loadSavedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final savedItems = snapshot.data ?? [];
          return ListView.builder(
            itemCount: savedItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Food Item ID: ${savedItems[index]}'),
              );
            },
          );
        },
      ),
    );
  }
}







class AddRecipeScreen extends StatefulWidget {
  final int foodItemId;

  AddRecipeScreen({required this.foodItemId});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _servingSizeController = TextEditingController();

  bool _isSubmitting = false;

  // Function to save the recipe
  Future<void> saveRecipe() async {
    setState(() {
      _isSubmitting = true;
    });

    // Replace 'your-server-url' with the actual server URL
    final url = Uri.parse('http://192.168.231.169/fooddatabase/user_recipes.php');
    final response = await http.post(
      url,
      body: {
        'user_id': '1',  // Replace with actual user ID
        'food_item_id': widget.foodItemId.toString(),
        'title': _titleController.text,
        'ingredients': _ingredientsController.text,
        'steps': _stepsController.text,
        'serving_size': _servingSizeController.text,
      },
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe added successfully!')),
        );
        Navigator.pop(context); // Go back to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add recipe: ${responseBody['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Recipe Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients'),
                validator: (value) => value!.isEmpty ? 'Please enter ingredients' : null,
                maxLines: 3,
              ),
              TextFormField(
                controller: _stepsController,
                decoration: InputDecoration(labelText: 'Steps'),
                validator: (value) => value!.isEmpty ? 'Please enter steps' : null,
                maxLines: 5,
              ),
              TextFormField(
                controller: _servingSizeController,
                decoration: InputDecoration(labelText: 'Serving Size'),
                validator: (value) => value!.isEmpty ? 'Please enter a serving size' : null,
              ),
              SizedBox(height: 20),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveRecipe();
                  }
                },
                child: Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DiseaseSelectionScreen extends StatefulWidget {
  final int userId;

  DiseaseSelectionScreen({required this.userId});

  @override
  _DiseaseSelectionScreenState createState() => _DiseaseSelectionScreenState();
}

class _DiseaseSelectionScreenState extends State<DiseaseSelectionScreen> {
  List<dynamic> diseases = [];
  List<int> selectedDiseases = [];

  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    final response = await http.get(Uri.parse('http://192.168.73.169/fooddatabase/fetch_diseases.php'));
    if (response.statusCode == 200) {
      setState(() {
        diseases = json.decode(response.body);
      });
    }
  }

  Future<void> saveUserDiseases() async {
    final response = await http.post(
      Uri.parse('http://192.168.73.169/fooddatabase/add_user_diseases.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': widget.userId,
        'disease_ids': selectedDiseases,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Diseases saved successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Diseases'),
      ),
      body: ListView(
        children: diseases.map((disease) {
          return CheckboxListTile(
            title: Text(disease['name']),
            value: selectedDiseases.contains(disease['id']),
            onChanged: (bool? selected) {
              setState(() {
                if (selected == true) {
                  selectedDiseases.add(disease['id']);
                } else {
                  selectedDiseases.remove(disease['id']);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveUserDiseases,
        child: Icon(Icons.save),
      ),
    );
  }
}
