// =======================================================================
// File: lib/screens/voice_command_screen.dart
// Description: Listens to voice commands, announces screen transitions,
//              and supports smart parsing (e.g., "start from X to Y").
// =======================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import 'scan_building_screen.dart';
import 'navigation_assistance_screen.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;

  bool _isListening = false;
  String _spokenText = 'Tap the microphone and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
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

      _speech.listen(onResult: (result) async {
        final command = result.recognizedWords.toLowerCase();
        setState(() => _spokenText = result.recognizedWords);

        // === Direct keyword-based navigation ===
        if (command.contains('scan')) {
          await _tts.speak('Opening Scan Building screen');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
          );
          return;
        }

        if (command.contains('navigate')) {
          await _tts.speak('Opening Navigation Assistance screen');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NavigationAssistanceScreen()),
          );
          return;
        }

        // === Smart parsing: "start from entrance to lift" ===
        final parsed = _parseRouteCommand(command);
        if (parsed != null) {
          final start = parsed['start'];
          final end = parsed['end'];
          await _tts.speak('Navigating from $start to $end');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NavigationAssistanceScreen(
                initialStart: start,
                initialEnd: end,
              ),
            ),
          );
        }
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  /// Parses voice command like: "start from entrance to lift"
  /// Returns { start: 'entrance', end: 'lift' }
  Map<String, String>? _parseRouteCommand(String input) {
    final pattern = RegExp(r'(from|start from)\s+(\w[\w\s]*)\s+to\s+(\w[\w\s]*)');
    final match = pattern.firstMatch(input);
    if (match != null && match.groupCount == 3) {
      return {
        'start': match.group(2)!.trim(),
        'end': match.group(3)!.trim(),
      };
    }
    return null;
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
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