// =======================================================================
// File: lib/screens/voice_command_screen.dart
// Description: Accepts voice input to navigate to other screens with parsing
// =======================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'navigation_assistance_screen.dart';
import 'scan_building_screen.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = 'Tap the microphone and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

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

        // Navigate if user says "scan"
        if (command.contains('scan')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
          );
        }

        // Navigate to Navigation with voice command like "start from entrance to lift"
        else if (command.contains('navigate') ||
                 command.contains('start from') && command.contains('to')) {
          final RegExp regex = RegExp(r'start from (.+?) to (.+)');
          final match = regex.firstMatch(command);

          if (match != null) {
            final String from = match.group(1)?.trim() ?? '';
            final String to = match.group(2)?.trim() ?? '';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NavigationAssistanceScreen(
                  voiceStart: from,
                  voiceEnd: to,
                ),
              ),
            );
          } else {
            // fallback if format isn't matched
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavigationAssistanceScreen()),
            );
          }
        }
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Command')),
      body: GestureDetector(
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