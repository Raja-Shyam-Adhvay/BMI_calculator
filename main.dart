import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'constant.dart'; // Import constants

void main() {
  runApp(const BmiCalculatorApp());
}

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use primary color from constants
          primaryColor: primaryColor.shade900,
          scaffoldBackgroundColor: primaryColor.shade900,
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
          // Define the AppBar theme to ensure consistency
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor.shade900,
            elevation: 0,
          )
      ),
      home: const HomeScreen(),
    );
  }
}

extension on Color {
  get shade900 => null;
}



