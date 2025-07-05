import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Screen that provides audio + text-based navigation assistance
/// to help visually impaired users move within buildings.
class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // Simulated navigation instructions (these can come from backend later)
  final List<String> _instructions = [
    "You are currently at the building entrance.",
    "Walk straight for 10 meters.",
    "Turn right towards the elevator.",
    "You have reached the elevator. Press the button for floor 2.",
  ];

  int _currentStep = 0; // Track current instruction

  @override
  void initState() {
    super.initState();
    _speakInstruction(); // Speak first instruction on load
  }

  /// Speaks the current instruction using TTS
  Future<void> _speakInstruction() async {
    await _flutterTts.speak(_instructions[_currentStep]);
  }

  /// Move to next instruction (if available)
  void _nextStep() {
    if (_currentStep < _instructions.length - 1) {
      setState(() {
        _currentStep++;
      });
      _speakInstruction();
    } else {
      _flutterTts.speak("You have completed the navigation.");
    }
  }

  /// Move back to previous instruction
  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _speakInstruction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display instruction visually for those who can read it
            Text(
              _instructions[_currentStep],
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Buttons to move forward/backward
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _prevStep,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}