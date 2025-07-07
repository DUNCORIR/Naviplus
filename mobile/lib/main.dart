// =============================
// File: lib/main.dart
// Description: Accessible welcome screen + route manager for Naviplus app
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Screens used throughout the app
import 'voice_command_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/login_screen.dart';
import 'screens/scan_building_screen.dart';
import 'screens/navigation_assistance_screen.dart';

void main() {
  runApp(const NaviplusApp());
}

/// The root widget of the Naviplus app.
/// Sets up theme and named route navigation.
class NaviplusApp extends StatelessWidget {
  const NaviplusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviplus App',
      debugShowCheckedModeBanner: false,

      // App-wide theme using a teal color seed
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),

      // Set the first screen to the WelcomeScreen
      home: const LoginScreen(),

      // Define all named routes used in the app
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/voice': (context) => const VoiceCommandScreen(),
        '/scan': (context) => const ScanBuildingScreen(),
        '/navigate': (context) => const NavigationAssistanceScreen(),
      },
    );
  }
}

/// This is the first screen shown when the app launches.
/// It welcomes the user via voice and prompts them to tap to proceed.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterTts _flutterTts = FlutterTts(); // Text-to-Speech instance

  @override
  void initState() {
    super.initState();
    _speakWelcome(); // Speak welcome message on load
  }

  /// Speaks a welcome instruction for visually impaired users
  Future<void> _speakWelcome() async {
    await _flutterTts.speak("Welcome to Naviplus. Tap anywhere to continue.");
  }

  /// Navigates to the main menu screen when user taps
  void _goToMenuScreen() {
    Navigator.pushNamed(context, '/menu');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToMenuScreen,
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