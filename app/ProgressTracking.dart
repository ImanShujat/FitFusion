import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressTracking extends StatefulWidget {
  @override
  _ProgressTrackingState createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  final TextEditingController dailyCaloriesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final List<Map<String, dynamic>> meals = [];
  List<double> weightHistory = [];

  int totalCalories = 0;
  int totalConsumedCalories = 0;
  int dailyCalorieGoal = 0;
  double progress = 0.0;
  double currentWeight = 0.0;
  double previousWeight = 0.0;
  String weightStatus = "No data yet";

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  // Load saved progress from SharedPreferences
  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyCalorieGoal = prefs.getInt('dailyCalorieGoal') ?? 0;
      currentWeight = prefs.getDouble('currentWeight') ?? 0.0;
      previousWeight = prefs.getDouble('previousWeight') ?? 0.0;
      weightHistory = prefs.getStringList('weightHistory')?.map((e) => double.parse(e)).toList() ?? [];
      updateWeightStatus();
    });
  }

  // Save progress to SharedPreferences
  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyCalorieGoal', dailyCalorieGoal);
    prefs.setDouble('currentWeight', currentWeight);
    prefs.setDouble('previousWeight', previousWeight);
    prefs.setStringList('weightHistory', weightHistory.map((e) => e.toString()).toList());
  }

  // Set Daily Calorie Goal
  void handleSetDailyCalories() {
    if (dailyCaloriesController.text.isEmpty) {
      showMessage('Please enter daily calories');
      return;
    }

    int calories = int.tryParse(dailyCaloriesController.text) ?? 0;
    setState(() {
      dailyCalorieGoal = calories;
    });

    addMeals();
    saveProgress();
    dailyCaloriesController.clear();
  }

  // Add Meals
  void addMeals() {
    setState(() {
      int mealCalories = dailyCalorieGoal ~/ 4;
      meals.clear();
      meals.addAll([
        {'name': 'Breakfast', 'calories': mealCalories, 'status': 'Not Consumed'},
        {'name': 'Lunch', 'calories': mealCalories, 'status': 'Not Consumed'},
        {'name': 'Dinner', 'calories': mealCalories, 'status': 'Not Consumed'},
        {'name': 'Snacks', 'calories': mealCalories, 'status': 'Not Consumed'},
      ]);
      totalCalories = dailyCalorieGoal;
      progress = totalConsumedCalories / dailyCalorieGoal;
    });
  }

  // Mark meal as consumed
  void markAsConsumed(int index) {
    setState(() {
      var calories = meals[index]['calories'];
      if (calories != null && calories is int) {
        meals[index]['status'] = 'Consumed';
        totalConsumedCalories += calories;
        progress = totalConsumedCalories / dailyCalorieGoal;
      }
    });
  }

  // Handle weight input
  void handleWeightInput() {
    if (weightController.text.isEmpty) {
      showMessage('Please enter your weight');
      return;
    }

    double newWeight = double.tryParse(weightController.text) ?? 0.0;

    setState(() {
      previousWeight = currentWeight;
      currentWeight = newWeight;
      weightHistory.add(newWeight);

      if (weightHistory.length > 7) {
        weightHistory.removeAt(0); // Keep only last 7 days
      }

      updateWeightStatus();
    });

    saveProgress();
    weightController.clear();
  }

  // Update weight status
  void updateWeightStatus() {
    if (previousWeight == 0.0 || currentWeight == 0.0) {
      weightStatus = "No data yet";
      return;
    }

    if (currentWeight > previousWeight) {
      weightStatus = "You gained weight";
    } else if (currentWeight < previousWeight) {
      weightStatus = "You lost weight";
    } else {
      weightStatus = "Your weight is stable";
    }
  }

  // Show message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Weekly Progress Chart
  Widget buildChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weightHistory.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen], // Kam az kam 2 colors dena zaroori hai
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie & Weight Tracker"), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Daily Calories Input
            TextField(
              controller: dailyCaloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Daily Calorie Goal', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: handleSetDailyCalories, child: Text("Set Daily Calories")),

            // Weight Input
            SizedBox(height: 20),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Today’s Weight (kg)', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: handleWeightInput, child: Text("Track Weight")),

            // Weight Status
            SizedBox(height: 20),
            Text("Weight Status: $weightStatus", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Weekly Progress Graph
            SizedBox(height: 20),
            Text("Weekly Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(height: 200, child: buildChart()),

            // Achievements & Meals List
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${meals[index]['name']} - ${meals[index]['calories']} calories'),
                    subtitle: Text('Status: ${meals[index]['status']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => markAsConsumed(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
