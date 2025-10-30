import 'package:flutter/material.dart';
import 'constant.dart';

class ResultDetailScreen extends StatelessWidget {
  final double bmiResult;

  const ResultDetailScreen({super.key, required this.bmiResult, required double heightCm, required double weightKg, required int age});

  @override
  Widget build(BuildContext context) {
    final BmiCategory category = getBmiCategory(bmiResult);

    // Access the ColorSwatch property directly
    final ColorSwatch<int> colorSwatch = category.colorSwatch;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Result Details'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(

                  colors: [
                    colorSwatch[500] ?? Colors.white,
                    colorSwatch[800] ?? Colors.black
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your BMI Score',
                    style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bmiResult.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(offset: Offset(2, 2), blurRadius: 4.0, color: Colors.black26)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Category: ${category.label} ${category.emoji}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 30, color: Colors.white54),
                  Text(
                    category.description,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text('Go Back', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
