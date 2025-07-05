// ================================================
// Updated NavigationAssistanceScreen
// Now includes voice command parsing like:
// "Start from Entrance A to Lift 2"
// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/api_service.dart';
import 'dart:io'; // For platform check

class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts();
  late stt.SpeechToText _speech;

  String? _selectedBuilding;
  String? _selectedStart;
  String? _selectedEnd;

  List<Map<String, dynamic>> _buildings = [];
  List<String> _plds = [];
  List<String> _steps = [];

  bool _isLoading = false;
  bool _isListening = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadBuildings();
  }

  @override
  void dispose() {
    _tts.stop();
    _tts.dispose();
    super.dispose();
  }

  /// Fetches building list
  Future<void> _loadBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = data);
    } catch (_) {
      _speakAndSetError('Could not load buildings.');
    }
  }

  /// Fetches PLDs for selected building
  Future<void> _loadPLDs(String buildingId) async {
    try {
      final plds = await ApiService.fetchPLDs(buildingId);
      setState(() {
        _plds = plds;
        _selectedStart = null;
        _selectedEnd = null;
      });
    } catch (_) {
      _speakAndSetError('Failed to load locations for the selected building.');
    }
  }

  /// Trigger backend navigation route
  Future<void> _getNavigationSteps() async {
    if (_selectedBuilding == null || _selectedStart == null || _selectedEnd == null) {
      _speakAndSetError('Please select building, start, and end.');
      return;
    }

    setState(() {
      _isLoading = true;
      _steps = [];
      _errorMessage = null;
    });

    try {
      final steps = await ApiService.fetchNavigationSteps(
        buildingId: _selectedBuilding!,
        start: _selectedStart!,
        end: _selectedEnd!,
      );
      setState(() => _steps = steps);
      for (final step in steps) {
        await _tts.speak(step);
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (_) {
      _speakAndSetError('Navigation failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Utility: speaks and sets error message
  void _speakAndSetError(String msg) async {
    await _tts.speak(msg);
    setState(() => _errorMessage = msg);
  }

  /// Starts speech recognition and parses result
  Future<void> _startVoiceCommand() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      _speakAndSetError('Voice input only works on Android or iOS.');
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (s) => print("Speech status: $s"),
      onError: (e) => print("Speech error: $e"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        final command = result.recognizedWords.toLowerCase();
        print("Heard: $command");
        _handleVoiceCommand(command);
      });
    }
  }

  /// Stops voice input
  void _stopVoiceCommand() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  /// Parses natural language and sets start/end
  void _handleVoiceCommand(String input) {
    final regex = RegExp(r'start from (.+?) to (.+)');
    final match = regex.firstMatch(input);

    if (match != null && _plds.isNotEmpty) {
      final start = match.group(1)?.trim();
      final end = match.group(2)?.trim();

      final matchedStart = _plds.firstWhere(
        (p) => p.toLowerCase() == start?.toLowerCase(),
        orElse: () => '',
      );
      final matchedEnd = _plds.firstWhere(
        (p) => p.toLowerCase() == end?.toLowerCase(),
        orElse: () => '',
      );

      if (matchedStart.isNotEmpty && matchedEnd.isNotEmpty) {
        setState(() {
          _selectedStart = matchedStart;
          _selectedEnd = matchedEnd;
        });
        _tts.speak("Navigating from $matchedStart to $matchedEnd");
        _getNavigationSteps();
      } else {
        _speakAndSetError('Could not recognize one of the locations.');
      }
    } else if (input.contains("back") || input.contains("go back")) {
      Navigator.pop(context);
    } else {
      _speakAndSetError('Please say: start from X to Y.');
    }
  }

  /// Builds a dropdown field
  Widget _buildDropdown<T>({
    required String label,
    required T? selectedValue,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Assistance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.stop : Icons.mic),
            tooltip: "Voice command",
            onPressed: _isListening ? _stopVoiceCommand : _startVoiceCommand,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown<String>(
              label: "Building",
              selectedValue: _selectedBuilding,
              items: _buildings.map((b) => b['id'].toString()).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedBuilding = val);
                  _loadPLDs(val);
                }
              },
            ),
            if (_plds.isNotEmpty) ...[
              _buildDropdown<String>(
                label: "Start Location",
                selectedValue: _selectedStart,
                items: _plds,
                onChanged: (val) => setState(() => _selectedStart = val),
              ),
              _buildDropdown<String>(
                label: "End Location",
                selectedValue: _selectedEnd,
                items: _plds,
                onChanged: (val) => setState(() => _selectedEnd = val),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getNavigationSteps,
              child: const Text("Get Directions"),
            ),
            const SizedBox(height: 12),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_steps.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text("Repeat Instructions"),
                onPressed: _steps.isEmpty ? null : _getNavigationSteps,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.directions_walk),
                    title: Text(_steps[index]),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
