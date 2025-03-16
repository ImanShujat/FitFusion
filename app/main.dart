import 'package:flutter/material.dart';
import 'Splashscreen.dart'; // Import your splash screen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        // Your app's theme
      ),
      home: SplashScreen(), // Set splash screen as the initial route
    );
  }
}
