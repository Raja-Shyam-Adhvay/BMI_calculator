import 'package:flutter/material.dart';
import 'constant.dart';
import 'secondscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // State variables initialized with constants
  double _heightCm = defaultHeightCm;
  double _weightKg = defaultWeightKg;
  int _age = defaultAge; // New state variable for age
  Gender _gender = Gender.male; // New state variable for gender
  double _bmi = 0.0;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _calculateBmi();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //BMI Calculation Logic
  void _calculateBmi() {
    final double heightMeters = _heightCm / 100.0;
    final double calculatedBmi = _weightKg / (heightMeters * heightMeters);

    setState(() {
      _bmi = calculatedBmi;
      _animationController.forward(from: 0.0);
    });
  }

  //Reset Function
  void _resetValues() {
    setState(() {
      _heightCm = defaultHeightCm;
      _weightKg = defaultWeightKg;
      _age = defaultAge;
      _gender = Gender.male;
      _calculateBmi();
    });
  }

  //UI Builder for the Result Card Content
  Widget _buildResultContent(BmiCategory category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display Gender
        Text(
          _gender == Gender.male ? 'MALE' : 'FEMALE',
          style: const TextStyle(fontSize: 18, color: Colors.white54, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          'Your BMI is:',
          style: TextStyle(fontSize: 20, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        Text(
          _bmi.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Text(
              '${category.label} (Tap for details)',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final BmiCategory currentCategory = getBmiCategory(_bmi);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BMI Calculator"),
        titleTextStyle: const TextStyle(
            fontWeight:FontWeight.bold,
            fontSize: 30, color: Colors.white),

        backgroundColor: primaryColor ?? primaryColor,
      ),
      // FIX: Use index access [900] with fallback
      backgroundColor: primaryColor ?? primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Gender Selection Row (2/13 height)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _gender = Gender.male),
                      child: ReusableCard(
                        color: _gender == Gender.male ? accentColor ?? accentColor : accentColor,
                        cardChild: _GenderCardContent(
                          icon: Icons.male,
                          label: 'MALE',
                          isSelected: _gender == Gender.male,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _gender = Gender.female),
                      child: ReusableCard(
                        color: _gender == Gender.female ? accentColor ?? accentColor : accentColor,
                        cardChild: _GenderCardContent(
                          icon: Icons.female,
                          label: 'FEMALE',
                          isSelected: _gender == Gender.female,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: ReusableCard(
                color: accentColor,
                cardChild: _InputSliderContent(
                  title: 'HEIGHT',
                  unit: 'cm',
                  value: _heightCm,
                  min: 100.0,
                  max: 220.0,
                  color: primaryColor,
                  onChanged: (newValue) {
                    setState(() => _heightCm = newValue);
                    _calculateBmi();
                  },
                ),
              ),
            ),


            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // AGE Input with Buttons
                  Expanded(
                    child: ReusableCard(
                      color: accentColor,
                      cardChild: _InputButtonCard(
                        title: 'AGE',
                        value: _age,
                        unit: 'yrs',
                        onIncrement: () {
                          setState(() => _age = _age < 100 ? _age + 1 : 100);
                          _calculateBmi();
                        },
                        onDecrement: () {
                          setState(() => _age = _age > 1 ? _age - 1 : 1);
                          _calculateBmi();
                        },
                      ),
                    ),
                  ),
                  // WEIGHT Input with Buttons
                  Expanded(
                    child: ReusableCard(
                      color: accentColor,
                      cardChild: _InputButtonCard(
                        title: 'WEIGHT',
                        value: _weightKg.toInt(),
                        unit: 'kg',
                        onIncrement: () {
                          setState(() {
                            _weightKg = _weightKg < 150.0 ? _weightKg + 1.0 : 150.0;
                          });
                          _calculateBmi();
                        },
                        onDecrement: () {
                          setState(() {
                            _weightKg = _weightKg > 30.0 ? _weightKg - 1.0 : 30.0;
                          });
                          _calculateBmi();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. BMI Result Card (4/13 height)
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  // PASSING ALL INPUT PARAMETERS TO THE DETAIL SCREEN
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultDetailScreen(
                        bmiResult: _bmi,
                        heightCm: _heightCm, // Pass height
                        weightKg: _weightKg, // Pass weight
                        age: _age,           // Pass age
                      ),
                    ),
                  );
                },
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: ReusableCard(
                    // FIX: Error 2 Fix: The index access on 'accentColor' was removed
                    // because the compiler sees it as a simple Color, not a ColorSwatch.
                    color: currentCategory.colorSwatch[500] ?? accentColor,
                    cardChild: _buildResultContent(currentCategory),
                  ),
                ),
              ),
            ),

            // 5. Reset Button (Container)
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // FIX: Use index access [700] with fallback
                color: Colors.red[700] ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: _resetValues,
                borderRadius: BorderRadius.circular(10),
                child: const Center(
                  child: Text(
                    'RESET VALUES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Reusable Card widget provided by the user
class ReusableCard extends StatelessWidget{
  const ReusableCard({super.key, required this.color, required this.cardChild});

  final Color color;
  final Widget cardChild;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: cardChild,
    );
  }
}

// --- GENDER SELECTION ---
class _GenderCardContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _GenderCardContent({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50.0, color: isSelected ? Colors.white : Colors.white70),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
              fontSize: 18, // Increased size for better visibility
              fontWeight: FontWeight.w800, // Increased boldness
              color: isSelected ? Colors.white : Colors.white70
          ),
        ),
      ],
    );
  }
}

//  BUTTON-BASED INPUT (for Age/Weight)
class _InputButtonCard extends StatelessWidget {
  final String title;
  final int value;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _InputButtonCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 4), // Added a small gap
            Text(
              unit,
              // ENHANCEMENT: Increased size and boldness for readability
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundIconButton(
              icon: Icons.remove,
              onPressed: onDecrement,
            ),
            const SizedBox(width: 10),
            _RoundIconButton(
              icon: Icons.add,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

// Helper widget for the circular + / - buttons
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
        width: 44.0,
        height: 44.0,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E), // Dark button color
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}

//SLIDER INPUT
class _InputSliderContent extends StatelessWidget {
  final String title;
  final String unit;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color color;

  const _InputSliderContent({
    required this.title,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          activeColor: Colors.white,
          inactiveColor: Colors.white.withOpacity(0.3),
          onChanged: onChanged,
        ),
      ],
    );
  }
}