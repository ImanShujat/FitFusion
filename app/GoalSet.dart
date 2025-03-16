import 'package:flutter/material.dart';

class GoalSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Goal'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is your primary fitness goal?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            GoalOptionCard(
              icon: Icons.fitness_center,
              title: 'Lose Weight',
              description:
              'Follow a calorie deficit diet and track your workouts to lose weight effectively.',
              onTap: () {
                navigateToCategorySelection(
                  context,
                  'Lose Weight',
                );
              },
            ),
            GoalOptionCard(
              icon: Icons.health_and_safety,
              title: 'Gain Weight',
              description:
              'Consume more calories and track protein intake to build muscle mass.',
              onTap: () {
                navigateToCategorySelection(
                  context,
                  'Gain Weight',
                );
              },
            ),
            GoalOptionCard(
              icon: Icons.directions_run,
              title: 'Stay Fit',
              description:
              'Maintain a balanced diet and daily workouts to keep yourself active and fit.',
              onTap: () {
                navigateToCategorySelection(
                  context,
                  'Stay Fit',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCategorySelection(BuildContext context, String goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(goal: goal),
      ),
    );
  }
}

class GoalOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const GoalOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelectionScreen extends StatefulWidget {
  final String goal;

  CategorySelectionScreen({required this.goal});

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedDietType;
  String? selectedActivityLevel;
  String? selectedFitnessGoal;

  final List<String> dietTypes = [
    'Low Carb Diet',
    'High Protein Diet',
    'Balanced Diet',
    'Vegan Diet',
  ];

  final List<String> activityLevels = [
    'Sedentary (Little to no exercise)',
    'Lightly Active (1-3 times/week)',
    'Active (4-5 times/week)',
    'Very Active (Daily intense exercise)',
  ];

  final List<String> fitnessGoals = [
    'Lose Weight',
    'Gain Weight',
    'Stay Fit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.goal} - Choose Preferences'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Fitness Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedFitnessGoal,
              hint: Text('Choose Fitness Goal'),
              onChanged: (value) {
                setState(() {
                  selectedFitnessGoal = value!;
                });
              },
              items: fitnessGoals.map((goal) {
                return DropdownMenuItem(
                  value: goal,
                  child: Text(goal),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Diet Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedDietType,
              hint: Text('Choose Diet Type'),
              onChanged: (value) {
                setState(() {
                  selectedDietType = value!;
                });
              },
              items: dietTypes.map((diet) {
                return DropdownMenuItem(
                  value: diet,
                  child: Text(diet),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Activity Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedActivityLevel,
              hint: Text('Choose Activity Level'),
              onChanged: (value) {
                setState(() {
                  selectedActivityLevel = value!;
                });
              },
              items: activityLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (selectedDietType != null &&
                    selectedActivityLevel != null &&
                    selectedFitnessGoal != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurveyResultScreen(
                        goal: widget.goal,
                        fitnessGoal: selectedFitnessGoal!,
                        dietType: selectedDietType!,
                        activityLevel: selectedActivityLevel!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select all options')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyResultScreen extends StatelessWidget {
  final String goal;
  final String fitnessGoal;
  final String dietType;
  final String activityLevel;

  SurveyResultScreen({
    required this.goal,
    required this.fitnessGoal,
    required this.dietType,
    required this.activityLevel,
  });

  String calculateCalories(String fitnessGoal, String activityLevel) {
    int baseCalories = 2000;

    if (fitnessGoal == 'Lose Weight') baseCalories -= 500;
    if (fitnessGoal == 'Gain Weight') baseCalories += 500;

    if (activityLevel == 'Sedentary (Little to no exercise)') {
      baseCalories -= 200;
    } else if (activityLevel == 'Active (4-5 times/week)') {
      baseCalories += 200;
    } else if (activityLevel == 'Very Active (Daily intense exercise)') {
      baseCalories += 400;
    }

    return baseCalories.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String recommendedCalories =
    calculateCalories(fitnessGoal, activityLevel);

    return Scaffold(
      appBar: AppBar(
        title: Text('$goal Plan'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Your Selected Goal: $goal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Fitness Goal: $fitnessGoal',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Diet Type: $dietType',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Activity Level: $activityLevel',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Recommended Daily Calories: $recommendedCalories kcal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
