import 'package:flutter/material.dart';

void main() {
  runApp(MentalZenApp());
}

class MentalZenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Zen',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Zen'),
      ),
      body: Center(
        child: Text(
          'Welcome to Mental Zen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}