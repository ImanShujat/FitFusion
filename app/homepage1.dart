import 'package:flutter/material.dart';
import 'package:fyp_1/survey.dart';
import 'package:fyp_1/welcomePage.dart';
import 'Diary.dart';
import 'DashBoard.dart';
import 'Profilescreen.dart';
import 'database.dart';

class homepage extends StatefulWidget {
  static final String id = "MyHomePage_id";

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int currentPage = 0;
  bool isSurveyCompleted = false; // Track whether the survey is completed
  bool showSplash = true; // Show Welcome Page initially

  @override
  void initState() {
    super.initState();

    // Timer to hide the welcome page after 10 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: buildContent(),
    );
  }

  Widget buildContent() {
    if (showSplash) {
      // Show Welcome Page if `showSplash` is true
      return WelcomePage();
    }

    return Scaffold(
      body: isSurveyCompleted
          ? (currentPage == 1
          ? Plans()
          : currentPage == 2
          ? ProfileScreen()
          : currentPage == 3
          ? SqfliteExampleScreen()
          : Dashboard())
          : Survey(
        onComplete: () {
          setState(() {
            isSurveyCompleted = true;
          });
        },
      ),

    );
  }
}
