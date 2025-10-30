import 'package:flutter/material.dart';

// GENDER ENUM
enum Gender { male, female }

// BMI Model and Utilities

// Define the BMI category data structure
class BmiCategory {
  final String label;
  final ColorSwatch<int> colorSwatch;
  final String emoji;
  final String description;


  BmiCategory(this.label, this.colorSwatch, this.emoji, this.description);
}

// Function to calculate BMI and determine the category
BmiCategory getBmiCategory(double bmi) {
  if (bmi < 18.5) {
    return BmiCategory(
        'Underweight',
        Colors.blue,
        '😔',
        'Being underweight can be a sign of poor nutrition, or it could indicate an underlying health issue. Focus on nutritious weight gain.'
    );
  } else if (bmi >= 18.5 && bmi < 25.0) {
    return BmiCategory(
        'Normal',
        Colors.green, // MaterialColor
        '😊',
        'Your BMI is healthy! Keep up the good work maintaining a balanced diet and regular physical activity.'
    );
  } else if (bmi >= 25.0 && bmi < 30.0) {
    return BmiCategory(
        'Overweight',
        Colors.orange, // MaterialColor
        '😟',
        'Being overweight may increase your risk of certain health conditions. Consider consulting a professional for dietary advice.'
    );
  } else {
    return BmiCategory(
        'Obese',
        Colors.red,
        '🥵',
        'Obesity significantly increases health risks. It is highly recommended to seek professional advice on sustained lifestyle changes.'
    );
  }
}

// General constants for the app
const Color primaryColor = Colors.deepPurpleAccent;
const Color accentColor = Colors.purple;
const double defaultHeightCm = 170.0;
const double defaultWeightKg = 60.0;
const int defaultAge = 25; // New default age

