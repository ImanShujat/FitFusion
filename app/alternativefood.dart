import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AlternativesScreen extends StatefulWidget {
  final int userId;

  AlternativesScreen({required this.userId});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  Future<List<String>> fetchAlternatives() async {
    final response = await http.get(Uri.parse('http://192.168.132.169/fooddatabase/fetch_alternatives.php?user_id=${widget.userId}'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Alternatives')),
      body: FutureBuilder<List<String>>(
        future: fetchAlternatives(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final alternatives = snapshot.data!;
            return ListView.builder(
              itemCount: alternatives.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alternatives[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
