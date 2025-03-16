import 'package:flutter/material.dart';

class Countcalorie extends StatefulWidget {
  final Function onComplete;
  const Countcalorie({Key? key, required this.onComplete}) : super(key: key);

  @override
  _CountcalorieState createState() => _CountcalorieState();
}

class _CountcalorieState extends State<Countcalorie> {
  final _pageController = PageController();
  final Map<String, String> _answers = {
    'age': '',
    'weight': '',
    'height': '',
    'gender': '',
  };

  int _currentPage = 0;
  String _bmiMessage = '';
  double _calories = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Count Calories"),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildAgePage(),
                _buildGenderPage(),
                _buildHeightPage(),
                _buildWeightPage(),
                _buildResultPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgePage() {
    return _buildQuestionPage(
      question: 'What is your age?',
      options: ['Under 18', '18-25', '26-35', '36-45', '46-60', 'Above 60'],
      answerKey: 'age',
    );
  }

  Widget _buildGenderPage() {
    return _buildQuestionPage(
      question: 'What is your gender?',
      options: ['Male', 'Female', 'Other'],
      answerKey: 'gender',
    );
  }

  Widget _buildHeightPage() {
    return _buildQuestionPage(
      question: 'What is your height?',
      options: ['< 150 cm', '150-160 cm', '160-170 cm', '170-180 cm', '180-190 cm', '> 190 cm'],
      answerKey: 'height',
    );
  }

  Widget _buildWeightPage() {
    return _buildQuestionPage(
      question: 'What is your weight?',
      options: ['< 50 kg', '50-60 kg', '60-70 kg', '70-80 kg', '80-90 kg', '> 90 kg'],
      answerKey: 'weight',
      isLastPage: true,
    );
  }

  Widget _buildResultPage() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your BMI Result',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            _bmiMessage,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Estimated Calories: ${_calories.toStringAsFixed(2)} kcal/day',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onComplete();
            },
            child: Text('Complete'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Reset the survey state and navigate back to the first page
              setState(() {
                _answers['age'] = '';
                _answers['weight'] = '';
                _answers['height'] = '';
                _answers['gender'] = '';
                _bmiMessage = '';
                _calories = 0.0;
              });
              _pageController.jumpToPage(0); // Navigate back to the first page
            },
            child: Text('Reattempt'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  void _calculateBMIAndCalories() {
    try {
      double height = _parseHeight(_answers['height']!);
      double weight = _parseWeight(_answers['weight']!);
      int age = _parseAge(_answers['age']!);
      String gender = _answers['gender']!;

      if (height > 0 && weight > 0) {
        double bmi = weight / (height * height); // BMI = weight(kg) / height(m)^2
        _bmiMessage = _getBmiMessage(bmi);
        _calories = _calculateCalories(weight, height, age, gender);
      } else {
        _bmiMessage = 'Invalid height or weight';
        _calories = 0.0;
      }
    } catch (e) {
      _bmiMessage = 'Error calculating BMI or calories. Please check your inputs.';
      _calories = 0.0;
    }
  }

  double _parseHeight(String heightStr) {
    switch (heightStr) {
      case '< 150 cm':
        return 1.45; // meters
      case '150-160 cm':
        return 1.55;
      case '160-170 cm':
        return 1.65;
      case '170-180 cm':
        return 1.75;
      case '180-190 cm':
        return 1.85;
      case '> 190 cm':
        return 1.95;
      default:
        throw FormatException('Invalid height');
    }
  }

  double _parseWeight(String weightStr) {
    switch (weightStr) {
      case '< 50 kg':
        return 45.0;
      case '50-60 kg':
        return 55.0;
      case '60-70 kg':
        return 65.0;
      case '70-80 kg':
        return 75.0;
      case '80-90 kg':
        return 85.0;
      case '> 90 kg':
        return 95.0;
      default:
        throw FormatException('Invalid weight');
    }
  }

  int _parseAge(String ageStr) {
    switch (ageStr) {
      case 'Under 18':
        return 16;
      case '18-25':
        return 22;
      case '26-35':
        return 30;
      case '36-45':
        return 40;
      case '46-60':
        return 55;
      case 'Above 60':
        return 65;
      default:
        throw FormatException('Invalid age');
    }
  }

  String _getBmiMessage(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi >= 18.5 && bmi < 24.9) return 'Normal weight';
    if (bmi >= 25 && bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  double _calculateCalories(double weight, double height, int age, String gender) {
    // BMR formula (Mifflin-St Jeor Equation)
    if (gender == 'Male') {
      return 10 * weight + 6.25 * height * 100 - 5 * age + 5; // BMR in kcal/day
    } else if (gender == 'Female') {
      return 10 * weight + 6.25 * height * 100 - 5 * age - 161; // BMR in kcal/day
    } else {
      return 0.0; // For 'Other' gender, calories calculation is not defined
    }
  }


  Widget _buildQuestionPage({
    required String question,
    required List<String> options,
    required String answerKey,
    bool isLastPage = false,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('images/bg3.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...options.map((option) {
                return ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: _answers[answerKey],
                    onChanged: (value) {
                      setState(() {
                        _answers[answerKey] = value!;
                      });
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_answers[answerKey] == null || _answers[answerKey]!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please choose one option"),
                      ),
                    );
                    return;
                  }

                  if (isLastPage) {
                    _calculateBMIAndCalories();
                  }
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: Text(isLastPage ? 'Submit' : 'Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Helper functions: _parseHeight, _parseWeight, _parseAge, _calculateCalories, _getBmiMessage
}
