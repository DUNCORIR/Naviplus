import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// This screen acts as the main menu of the Naviplus app.
/// It provides three accessible options for the user:
/// 1. Voice Command
/// 2. Scan Building
/// 3. Navigation Assistance
///
/// Voice instructions are spoken aloud using TTS (flutter_tts).
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FlutterTts _tts = FlutterTts(); // Text-to-Speech instance

  @override
  void initState() {
    super.initState();
    _speakIntro(); // Speak menu options aloud on screen load
  }

  /// Speaks the intro message when the menu screen opens
  Future<void> _speakIntro() async {
    await _tts.speak(
      "Welcome to Naviplus. Please choose an option: "
      "Voice Command, Scan Building, or Navigation Assistance.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Menu")),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Option 1: Voice Command
          _buildMenuItem(
            title: "Voice Command",
            onTap: () => Navigator.pushNamed(context, '/voice
