import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;

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

  void generateSuggestions() async {
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

    try {
      final response = await http.get(Uri.parse
        ('http://10.0.2.2:80/Fitnessguide/get_tips.php?goal=$selectedGoal&activity=$activityLevel'));
      if (response.statusCode == 200) {
        final jsonResp = json.decode(response.body);
        if (jsonResp['tips'] != null && jsonResp['tips'].isNotEmpty) {
          setState(() {
            suggestions = jsonResp['tips'][0];
          });
        } else if (jsonResp['error'] != null) {
          setState(() {
            suggestions = jsonResp['error'];
          });
        } else {
          setState(() {
            suggestions = 'Unexpected response from the server.';
          });
        }
      } else {
        setState(() {
          suggestions = 'Error: Unable to fetch data from the server.';
        });
      }
    } catch (e) {
      setState(() {
        suggestions = 'Error: $e';
      });
    }
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
