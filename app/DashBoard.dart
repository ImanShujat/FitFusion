import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_1/Diary.dart';
import 'package:fyp_1/Profilescreen.dart';
import 'package:fyp_1/login.dart';
import 'findresipe.dart';
import 'DietPlan.dart';
import 'CountCalorie.dart';
import 'GoalSet.dart';
import 'ProgressTracking.dart';
import 'notifications.dart';
import 'package:http/http.dart' as http;
class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isSurveyCompleted = true; // Set survey completion status
  int currentPage = 0; // Track the current page index

  void onComplete() {
    print("Calorie counting completed!");
    setState(() {
      // Update the UI or perform additional actions here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green, // AppBar Color
          elevation: 5,
          title: Text(
            "DASHBOARD",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/bg1.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: FittedBox(
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      buildTapContainer(context),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  MyDrawerList(context),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: isSurveyCompleted
            ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: BottomAppBar(
            color: Colors.black45,
            child: Row(
              children: [
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.dashboard,
                    color: currentPage == 0
                        ? Color.fromRGBO(203, 73, 101, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPage = 0;
                    });
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.library_books_outlined,
                    color: currentPage == 1
                        ? Color.fromRGBO(203, 73, 101, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPage = 1;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> Plans()),
                    );
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: currentPage == 2
                        ? Color.fromRGBO(203, 73, 101, 1)
                        : Color.fromRGBO(40, 40, 40, 1),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPage = 2;
                    });
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ProfileScreen()),
                    );
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        )
            : null,
      ),
    );
  }

  Widget MyDrawerList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(
            context,
            "Dashboard",
            Icons.dashboard_outlined,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> Dashboard()),
                  );
            },
          ),
          menuItem(
            context,
            "Profile",
            Icons.settings_outlined,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ProfileScreen()),
                  );
            },
          ),
          menuItem(
            context,
            "Progress",
            Icons.autorenew_outlined,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ProgressTracking()),
                  );
            },
          ),
          menuItem(
            context,
            "Water Tracker",
            Icons.local_drink_outlined,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> WaterTrackerScreen()),
                  );
            },
          ),
          menuItem(
            context,
            "Sleep Tracker",
            Icons.nightlight_rounded,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> SleepTrackerScreen()),
                  );
            },
          ),
          menuItem(
            context,
            "Message",
            Icons.mail_outlined,
                () {

            },
          ),
          menuItem(
            context,
            "Notifications",
            Icons.notifications_active,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ReminderApp()),
                  );
            },
          ),
          menuItem(
            context,
            "Logout",
            Icons.help_center_outlined,
                () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> LoginPage()),
                  );
            },
          ),
          menuItem(
            context,
            "Feedback",
            Icons.feedback_outlined,
                () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> FeedbackScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.blueGrey[700]),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildTapContainer(BuildContext context) {
    return Column(
      children: [
        buildRow(
          context: context,
          icon1: Icons.restaurant_menu_outlined,
          text1: 'Diet Plan!',
          icon2: Icons.calculate_outlined,
          text2: 'Count Calorie!',
          onPressed1: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DietPlanScreen()),
            );
          },
          onPressed2: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Countcalorie(onComplete: onComplete)),
            );
          },
        ),
        buildRow(
          context: context,
          icon1: Icons.set_meal_outlined,
          text1: 'Set Goal!',
          icon2: Icons.manage_search,
          text2: 'Find Recipies!',
          onPressed1: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalSettingScreen()),
            );
          },
          onPressed2: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeListScreen()),
            );
          },
        ),
        buildRow(
          context: context,
          icon1: Icons.autorenew_outlined,
          text1: 'Progress_Track',
          icon2: Icons.notification_add_outlined,
          text2: 'Notifications!',
          onPressed1: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProgressTracking()),
            );
          },
          onPressed2: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReminderApp()),
            );
          },
        ),
      ],
    );
  }

  Widget buildRow({
    required BuildContext context,
    required IconData icon1,
    required String text1,
    required IconData icon2,
    required String text2,
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.redAccent,
                    Colors.green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 17),
                    blurRadius: 17,
                    spreadRadius: -2,
                  ),
                ],
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(icon1),
                      iconSize: 70,
                      onPressed: onPressed1,
                    ),
                    SizedBox(height: 8),
                    Text(
                      text1,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.redAccent,
                    Colors.green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 17),
                    blurRadius: 17,
                    spreadRadius: -2,
                  ),
                ],
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(icon2),
                      iconSize: 70,
                      onPressed: onPressed2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      text2,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget MyHeaderDrawer() {
  return Container(
    color: Colors.green,
    width: double.infinity,
    height: 200,
    padding: EdgeInsets.only(top: 20),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'images/diet.png', // Replace with your logo file path
            height: 100, // Adjust size of the logo
            width: 100, // Adjust size of the logo
          ),
          SizedBox(height: 10), // Add space between logo and text
          // Text
          Text(
            "FitFusion",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    ),
  );
}


Widget MyDrawerList(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 15),
    child: Column(
      children: [
        menuItem(
          context,
          "Dashboard",
          Icons.dashboard_outlined,
              () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        ),
        menuItem(
          context,
          "Feedback",
          Icons.feedback_outlined,
              () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
          },
        ),
        menuItem(
          context,
          "Progress",
          Icons.autorenew_outlined,
              () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressTracking()));
          },
        ),
      ],
    ),
  );
}

Widget menuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}


class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final PageController _pageController = PageController();

  final List<String> questions = [
    "How satisfied are you with the diet plan recommendations?",
    "Do you find the food items in the diet plan easy to access?",
    "How clear and understandable is the diet plan?",
    "Does the diet plan fit well with your lifestyle?",
    "Are the portion sizes appropriate for your needs?",
    "How likely are you to recommend this diet plan to others?",
    "Do you feel the diet plan helps you meet your health goals?",
    "How satisfied are you with the variety of food options in the diet plan?",
    "Do you think the calorie distribution is balanced?",
    "How likely are you to continue using this diet plan?",
  ];

  final Map<int, String> responses = {}; // Store user responses
  int currentPage = 0;

  // Function to submit feedback
  Future<void> _submitFeedback() async {
    if (responses.length < questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please answer all the questions.")),
      );
      return;
    }

    final url = Uri.parse("http://192.168.100.22/fooddatabase/feedback.php"); // Replace with actual server IP
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1, // Replace with actual user ID if available
        "feedback": responses.map((index, value) => MapEntry(questions[index], value)),
      }),
    );

    final result = jsonDecode(response.body);
    if (result['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for your feedback!")),
      );
      Navigator.pop(context); // Navigate back after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit feedback.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.green,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${index + 1}/${questions.length}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  questions[index],
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text("Very Satisfied"),
                      value: "Very Satisfied",
                      groupValue: responses[index],
                      onChanged: (value) {
                        setState(() {
                          responses[index] = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    RadioListTile<String>(
                      title: Text("Neutral"),
                      value: "Neutral",
                      groupValue: responses[index],
                      onChanged: (value) {
                        setState(() {
                          responses[index] = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    RadioListTile<String>(
                      title: Text("Not Satisfied"),
                      value: "Not Satisfied",
                      groupValue: responses[index],
                      onChanged: (value) {
                        setState(() {
                          responses[index] = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0
                  ? () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Previous",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: currentPage < questions.length - 1
                  ? () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
                  : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                currentPage < questions.length - 1 ? "Next" : "Submit",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



