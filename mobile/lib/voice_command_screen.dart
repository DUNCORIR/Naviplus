// =======================================================================
// File: lib/screens/voice_command_screen.dart
// Description: Allows user to speak voice commands that navigate to
//              other screens (scan or navigation) using speech_to_text.
// =======================================================================

import 'dart:io'; // Platform check (for speech plugin compatibility)
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Screens navigated via voice command
import 'scan_building_screen.dart';
import 'navigation_assistance_screen.dart';

/// Screen that listens to user voice input and navigates based on keywords.
class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late stt.SpeechToText _speech;         // Speech recognition plugin instance
  bool _isListening = false;             // Whether microphone is active
  String _spokenText =
      'Tap the microphone and start speaking'; // Transcribed output

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize plugin
  }

  /// Starts listening and transcribes voice.
  /// Navigates to different screens based on spoken keywords.
  void _startListening() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      setState(() {
        _spokenText = 'Voice input only works on Android or iOS.';
      });
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(onResult: (result) {
        final command = result.recognizedWords.toLowerCase();

        setState(() {
          _spokenText = result.recognizedWords;
        });

        // Navigate to "Scan Building" if "scan" is said
        if (command.contains('scan')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
          );
        }

        // Navigate to "Navigation Assistance" if "navigate" is said
        else if (command.contains('navigate')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NavigationAssistanceScreen()),
          );
        }
      });
    }
  }

  /// Stops the microphone session
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Command')),
      body: GestureDetector(
        // Tapping toggles between listening/not listening
        onTap: _isListening ? _stopListening : _startListening,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              _spokenText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: _isListening ? 'Stop' : 'Start Listening',
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}