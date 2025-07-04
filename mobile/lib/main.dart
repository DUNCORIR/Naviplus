// =============================
// File: lib/main.dart
// Description: Accessible welcome screen for visually impaired users
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'voice_command_screen.dart';
void main() {
  runApp(const NaviplusApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviplus Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const WelcomeScreen(),
    );
  }
}

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

  void _goToVoiceCommandScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VoiceCommandScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToVoiceCommandScreen,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Welcome to Naviplus\nTap anywhere',
            style: const TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}