import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';  // Import the Lottie package

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _showAnimation = false; // Control when to show the animation

  @override
  void initState() {
    super.initState();

    // Timer to show the animation after 1 seconds and navigate after 5 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showAnimation = true; // Show the Lottie animation after 1 seconds
      });
    });

    Timer(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Survey'); // Navigate to next page after 10 seconds
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        ),
        child: Stack( // Stack to layer background and animation
          children: [
            // Content on top of the image and animation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display the text first
                  Text(
                    'Welcome to FitFusion!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your fitness journey starts here.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Stay active, stay healthy!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Let\'s make fitness a habit!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),

                  // Display the Lottie animation after the delay
                  if (_showAnimation)
                    Lottie.asset(
                      'images/lotieAnimation.json',  // Path to your Lottie animation
                      width: 250,  // Set width of the animation
                      height: 250,  // Set height of the animation
                      fit: BoxFit.cover, // Ensure animation fits properly
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
