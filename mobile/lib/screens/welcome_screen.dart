import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakWelcome();
  }

  Future<void> _speakWelcome() async {
    await _flutterTts.speak("Welcome to Naviplus. Tap anywhere to continue.");
  }

  void _goToMenuScreen() {
    Navigator.pushNamed(context, '/menu');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToMenuScreen,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            'Welcome to Naviplus\nTap anywhere',
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}