// =============================================
// File: lib/screens/navigation_assistance_screen.dart
// Description: Provides navigation assistance by allowing
// users to select a building, start, and end locations.
// Supports voice-injected start/end + TTS instructions.
// =============================================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/building_model.dart';
import '../models/pld_model.dart';
import '../services/api_service.dart';

class NavigationAssistanceScreen extends StatefulWidget {
  final String? voiceStart;
  final String? voiceEnd;

  const NavigationAssistanceScreen({
    super.key,
    this.voiceStart,
    this.voiceEnd,
  });

  @override
  State<NavigationAssistanceScreen> createState() =>
      _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts(); // For reading directions aloud

  List<Building> _buildings = []; // Loaded buildings
  List<PLD> _plds = [];           // PLDs within selected building

  int? _selectedBuilding;         // Selected building ID
  String? _selectedStart;         // Starting PLD
  String? _selectedEnd;           // Destination PLD

  String _instructions = '';      // Instructions or errors
  bool _isLoading = false;        // Loading state

  @override
  void initState() {
    super.initState();
    _fetchBuildings();
  }

  /// Fetch building list and previously selected inputs
  Future<void> _fetchBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = data);

      final prefs = await SharedPreferences.getInstance();
      _selectedBuilding = prefs.getInt('last_building');
      _selectedStart = widget.voiceStart ?? prefs.getString('last_start');
      _selectedEnd = widget.voiceEnd ?? prefs.getString('last_end');

      if (_selectedBuilding != null) {
        await _fetchPLDs(_selectedBuilding!);
      }
    } catch (_) {
      _speakAndSetError('Failed to load buildings.');
    }
  }

  /// Fetch PLDs for selected building
  Future<void> _fetchPLDs(int buildingId) async {
    try {
      final plds = await ApiService.fetchPLDs(buildingId);
      setState(() => _plds = plds);
    } catch (_) {
      _speakAndSetError('Failed to load locations.');
    }
  }

  /// Fetch navigation instructions from API
  Future<void> _getNavigationSteps() async {
    if (_selectedBuilding == null || _selectedStart == null || _selectedEnd == null) {
      _speakAndSetError('Please select building, start, and destination.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final steps = await ApiService.fetchNavigationSteps(
        buildingId: _selectedBuilding!,
        start: _selectedStart!,
        end: _selectedEnd!,
      );

      final instructionText = steps.join('. ');
      setState(() => _instructions = instructionText);
      await _tts.speak(instructionText);

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('last_building', _selectedBuilding!);
      prefs.setString('last_start', _selectedStart!);
      prefs.setString('last_end', _selectedEnd!);
    } catch (_) {
      _speakAndSetError('Failed to fetch directions.');
    }
    setState(() => _isLoading = false);
  }

  /// Speak and show an error
  void _speakAndSetError(String message) {
    _tts.speak(message);
    setState(() => _instructions = message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Assistance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Building:'),
              DropdownButton<int>(
                value: _selectedBuilding,
                hint: const Text('Choose a building'),
                isExpanded: true,
                items: _buildings.map((b) {
                  return DropdownMenuItem<int>(
                    value: b.id,
                    child: Text(b.name),
                  );
                }).toList(),
                onChanged: (val) async {
                  setState(() {
                    _selectedBuilding = val;
                    _selectedStart = null;
                    _selectedEnd = null;
                    _plds = [];
                  });
                  await _fetchPLDs(val!);
                },
              ),

              const SizedBox(height: 20),
              const Text('Start Location:'),
              DropdownButton<String>(
                value: _selectedStart,
                hint: const Text('Choose start'),
                isExpanded: true,
                items: _plds.map((p) {
                  return DropdownMenuItem<String>(
                    value: p.name,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStart = val),
              ),

              const SizedBox(height: 20),
              const Text('Destination:'),
              DropdownButton<String>(
                value: _selectedEnd,
                hint: const Text('Choose destination'),
                isExpanded: true,
                items: _plds.map((p) {
                  return DropdownMenuItem<String>(
                    value: p.name,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedEnd = val),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _getNavigationSteps,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Get Directions'),
              ),

              const SizedBox(height: 30),
              Text(
                _instructions,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}