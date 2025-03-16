import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'DashBoard.dart';
import 'DietPlan.dart';

class Survey extends StatefulWidget {
  final Function onComplete;

  Survey({required this.onComplete});

  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _genderController = TextEditingController();

  Map<String, dynamic>? surveyData;

  @override
  void initState() {
    super.initState();
    _loadSurveyData();
  }

  _loadSurveyData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('surveyData');
    if (savedData != null) {
      setState(() {
        surveyData = json.decode(savedData);
      });
    } else {
      setState(() {
        surveyData = null;
      });
    }
  }

  Future<Map<String, dynamic>> getSurveyData(int age, double weightKg, double heightCm, String gender) async {
    final requestBody = {
      "age": age,
      "weight_kg": weightKg,
      "height_cm": heightCm,
      "gender": gender,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.22:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load survey data');
      }
    } catch (e) {
      print('Error in HTTP request: $e');
      rethrow;
    }
  }

  void fetchSurveyData() async {
    if (_formKey.currentState!.validate()) {
      int age = int.parse(_ageController.text);
      double weightKg = double.parse(_weightController.text);
      double heightCm = double.parse(_heightController.text);
      String gender = _genderController.text;

      try {
        final result = await getSurveyData(age, weightKg, heightCm, gender);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('surveyData', json.encode(result));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyResultScreen(
              surveyData: result,
              onNext: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              onRetake: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('surveyData');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Survey(onComplete: widget.onComplete),
                  ),
                );
              },
            ),
          ),
        );
      } catch (e) {
        print('Error fetching survey data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: Text('Survey'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/c1.jpeg',  // Update this with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the image
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: surveyData == null
                  ? SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter age';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid integer for age';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number for weight';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height (cm)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter height';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number for height';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(
                          labelText: 'Gender (M/F)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter gender';
                          }
                          if (value != 'M' && value != 'F') {
                            return 'Please enter either "M" for male or "F" for female';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchSurveyData,
                        child: Text('Submit Survey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SurveyResultScreen(
                surveyData: surveyData!,
                onNext: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                onRetake: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('surveyData');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Survey(onComplete: widget.onComplete),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class SurveyResultScreen extends StatelessWidget {
  final Map<String, dynamic> surveyData;
  final VoidCallback onNext;
  final VoidCallback onRetake;

  SurveyResultScreen({
    required this.surveyData,
    required this.onNext,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text('Survey Result'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/c1.jpeg', // Update this with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the image
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.white, width: 1), // Table border
                    columnWidths: const {
                      0: FlexColumnWidth(2), // First column width
                      1: FlexColumnWidth(3), // Second column width
                    },
                    children: [
                      _buildTableRow('BMI', '${surveyData['BMI']}'),
                      _buildTableRow('BMR', '${surveyData['BMR']}'),
                      _buildTableRow('Activity Level', '${surveyData['activity_level']}'),
                      _buildTableRow('Label', '${surveyData['label']}'),
                      _buildTableRow('Prediction', '${surveyData['prediction']} kcal/day'),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onNext,
                    child: Text('Go to Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onRetake,
                    child: Text('Retake Survey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DietPlanScreen()),
                      );
                    },
                    child: Text('Generate DietPlan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create a table row
  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
