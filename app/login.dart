import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_1/signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage1.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to save login credentials using SharedPreferences
  Future<void> saveLoginCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);
  }

  // Function to check if the user is already logged in
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String savedEmail = prefs.getString('email') ?? '';
      String savedPassword = prefs.getString('password') ?? '';

      // Auto-login if credentials are available
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      login(context, isAutoLogin: true); // Trigger login if credentials are found
    }
  }

  // Modified login function to handle both online and offline login
  Future login(BuildContext context, {bool isAutoLogin = false}) async {
    // If it's an auto login, just skip the server request
    if (isAutoLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => homepage(),
        ),
      );
      return;
    }

    // Check internet connection first and attempt online login
    try {
      var url = "http://192.168.100.22/flutter_login/login.php"; // Replace with your actual server URL
      var response = await http.post(Uri.parse(url), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          // Save login credentials locally for offline login
          await saveLoginCredentials(emailController.text, passwordController.text);

          // Navigate to homepage after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homepage(),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: data['msg'] ?? 'User not found. Invalid credentials.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Server error. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // If the server is unavailable, try offline login
      bool isOfflineLoginSuccessful = await tryOfflineLogin();
      if (isOfflineLoginSuccessful) {
        Fluttertoast.showToast(
          msg: "Offline login successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homepage(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Login failed. Check your internet connection or try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    }
  }

  // Function to try offline login using SharedPreferences
  Future<bool> tryOfflineLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String savedEmail = prefs.getString('email') ?? '';
      String savedPassword = prefs.getString('password') ?? '';

      // Compare the entered credentials with the saved ones
      if (emailController.text == savedEmail && passwordController.text == savedPassword) {
        return true;
      }
    }
    return false;
  }

  // Email validation to ensure special characters are included
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular expression to check if the email contains special characters
    RegExp regex = RegExp(r'[@!#$%^&*(),.?":{}|<>]');
    if (!regex.hasMatch(value)) {
      return 'Email must contain at least one special character';
    }
    return null;
  }

  // Password validation to ensure it's at least 6 characters long
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Check if the user is already logged in when the page loads
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg1.png'), // Replace 'background_image.jpg' with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                        ),
                        validator: validateEmail,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                        ),
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(context);
                          }
                        },
                        child: Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text("Don't have an account? Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
