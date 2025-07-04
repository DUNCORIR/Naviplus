// =============================
// File: lib/main.dart
// Description: Accessible welcome screen for visually impaired users
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const NaviplusApp());
}

class NaviplusApp extends StatelessWidget {
  const NaviplusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviplus Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakWelcomeMessage();
  }

  // Function to speak the welcome message using flutter_tts
  Future<void> _speakWelcomeMessage() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("Welcome to Naviplus. Swipe right to scan building or swipe left for navigation assistance.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Naviplus',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'A voice-assisted navigation tool for the visually impaired.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => flutterTts.speak("Scanning buildings not yet implemented."),
                child: const Text('Scan Building'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => flutterTts.speak("Navigation assistance not yet implemented."),
                child: const Text('Navigation Assistance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
