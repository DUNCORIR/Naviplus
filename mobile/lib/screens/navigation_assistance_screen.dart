// =============================
// File: lib/screens/navigation_assistance_screen.dart
// Description: Allows users to request navigation between two PLDs inside a building.
// Uses Building and PLD models instead of raw Maps.
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/building_model.dart';
import '../models/pld_model.dart';

class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts(); // Text-to-speech instance

  // List of buildings and PLDs fetched from backend
  List<Building> _buildings = [];
  List<PLD> _plds = [];

  // User selections
  int? _selectedBuilding;
  String? _selectedStart;
  String? _selectedEnd;

  // Resulting navigation instructions (spoken and displayed)
  String _instructions = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBuildings(); // Load buildings on screen load
  }

  /// Fetches list of buildings and loads last-used state from preferences
  Future<void> _fetchBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = data);

      // Load previous selections (if any)
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedBuilding = prefs.getInt('last_building');
        _selectedStart = prefs.getString('last_start');
        _selectedEnd = prefs.getString('last_end');
      });

      // If building previously selected, preload its PLDs
      if (_selectedBuilding != null) {
        await _fetchPLDs(_selectedBuilding!);
      }
    } catch (e) {
      _speakAndSetError('Failed to load buildings.');
    }
  }

  /// Fetches PLDs for the selected building
  Future<void> _fetchPLDs(int buildingId) async {
    try {
      final plds = await ApiService.fetchPLDs(buildingId);
      setState(() => _plds = plds);
    } catch (e) {
      _speakAndSetError('Failed to load locations for this building.');
    }
  }

  /// Gets navigation steps and announces them
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

      final text = steps.join(". ");
      setState(() => _instructions = text);
      await _tts.speak(text);

      // Cache the selection
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('last_building', _selectedBuilding!);
      prefs.setString('last_start', _selectedStart!);
      prefs.setString('last_end', _selectedEnd!);
    } catch (e) {
      _speakAndSetError('Failed to fetch directions.');
    }
    setState(() => _isLoading = false);
  }

  /// Speaks error and updates UI
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
                items: _buildings.map<DropdownMenuItem<int>>((b) {
                  return DropdownMenuItem<int>(
                    value: b.id,
                    child: Text(b.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBuilding = value;
                    _selectedStart = null;
                    _selectedEnd = null;
                  });
                  _fetchPLDs(value!);
                },
              ),

              const SizedBox(height: 20),
              const Text('Start Location:'),
              DropdownButton<String>(
                value: _selectedStart,
                hint: const Text('Choose start'),
                isExpanded: true,
                items: _plds.map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem<String>(
                    value: p.name,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStart = value),
              ),

              const SizedBox(height: 20),
              const Text('Destination:'),
              DropdownButton<String>(
                value: _selectedEnd,
                hint: const Text('Choose destination'),
                isExpanded: true,
                items: _plds.map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem<String>(
                    value: p.name,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedEnd = value),
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
    _tts.stop(); // Stop TTS when screen is closed
    super.dispose();
  }
}