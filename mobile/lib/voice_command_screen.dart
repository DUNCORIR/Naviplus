import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'screens/scan_building_screen.dart'; // <-- New import for ScanBuildingScreen
import 'dart:io'; // For platform checks

/// This screen allows users to give voice commands,
/// which are transcribed and optionally used for navigation.
class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false; // Whether mic is currently active
  String _spokenText = 'Tap the microphone and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize speech engine
  }

  /// Starts listening for voice input and updates [_spokenText] with results.
  /// Navigates to ScanBuildingScreen if user mentions "scan".
  void _startListening() async {
    // Avoid running unsupported plugin on Linux/WSL
    if (!(Platform.isAndroid || Platform.isIOS)) {
      setState(() {
        _spokenText = 'Voice input only works on Android/iOS devices.';
      });
      return;
    }

    // Initialize the plugin and check if it's ready
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          // Capture and show the spoken words
          setState(() {
            _spokenText = result.recognizedWords;
          });

          // Example: if user says "scan", navigate to ScanBuildingScreen
          if (result.recognizedWords.toLowerCase().contains('scan')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
            );
          }
        },
      );
    }
  }

  /// Stops the current listening session
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Command')),
      body: GestureDetector(
        // Tapping the screen toggles listening on/off
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
      // Floating mic button (toggles speech recognition)
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: _isListening ? 'Stop' : 'Start Listening',
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}
