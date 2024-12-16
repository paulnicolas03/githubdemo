import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Fitness Guide',
      home: FitnessGuidePage(),
    );
  }
}

class FitnessGuidePage extends StatefulWidget {
  @override
  _FitnessGuidePageState createState() => _FitnessGuidePageState();
}

class _FitnessGuidePageState extends State<FitnessGuidePage> {
  TextEditingController weightController = TextEditingController();
  String selectedGoal = 'Lose Weight';
  String activityLevel = 'Sedentary';
  String suggestions = '';

  List loseWeightTips = [
    'Reduce calorie intake by 500-700 calories daily. Start with light walks or yoga.',
    'Balance your meals with 40% protein. Engage in cardio like jogging or cycling.',
    'Focus on strength training and HIIT workouts. Maintain a calorie deficit.'
  ];

  List buildMuscleTips = [
    'Increase protein intake to 1.6g per kg body weight. Start with basic weightlifting.',
    'Consume balanced meals with carbs and protein. Engage in progressive strength training.',
    'Increase calorie intake by 10-15%. Focus on compound exercises and rest well.'
  ];

  List stayFitTips = [
    'Walk for 30 minutes daily. Avoid processed food and stay hydrated.',
    'Add variety to your workouts. Include a mix of cardio and light strength training.',
    'Challenge yourself with new fitness goals like running a marathon or trying new sports.'
  ];

  void generateSuggestions() {
    String weightInput = weightController.text;
    double weight = 0;

    if (weightInput.isEmpty) {
      setState(() {
        suggestions = 'Please enter your weight.';
      });
      return;
    }

    try {
      weight = double.parse(weightInput);
    } catch (e) {
      setState(() {
        suggestions = 'Please enter a valid weight.';
      });
      return;
    }

    if (weight <= 0) {
      setState(() {
        suggestions = 'Please enter a valid weight.';
      });
      return;
    }

    int activityIndex = ['Sedentary', 'Moderate', 'Active'].indexOf(activityLevel);
    if (activityIndex == -1) {
      setState(() {
        suggestions = 'No tips available for the selected options.';
      });
      return;
    }

    switch (selectedGoal) {
      case 'Lose Weight':
        suggestions = loseWeightTips[activityIndex];
        break;
      case 'Build Muscle':
        suggestions = buildMuscleTips[activityIndex];
        break;
      case 'Stay Fit':
        suggestions = stayFitTips[activityIndex];
        break;
      default:
        suggestions = 'No tips available for the selected options.';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Fitness Guide'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton(
              value: selectedGoal,
              items: ['Lose Weight', 'Build Muscle', 'Stay Fit'].map((goal) {
                return DropdownMenuItem(value: goal, child: Text(goal));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedGoal = value;
                  });
                }
              },
            ),
            DropdownButton(
              value: activityLevel,
              items: ['Sedentary', 'Moderate', 'Active'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    activityLevel = value;
                  });
                }
              },
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter your weight (kg)'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: generateSuggestions,
              child: Text('Get Tips'),
            ),
            SizedBox(height: 20),
            Text(
              'Suggestions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              suggestions,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}