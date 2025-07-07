// =============================
// File: lib/screens/navigation_assistance_screen.dart
// Description: Allows users to request navigation between points in a building
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts(); // Text-to-speech instance

  List<Map<String, dynamic>> _buildings = []; // List of building data
  List<Map<String, dynamic>> _plds = [];       // List of PLDs (Physical Location Descriptors)

  int? _selectedBuilding; // Currently selected building ID
  String? _selectedStart; // Selected start location name
  String? _selectedEnd;   // Selected destination name

  String _instructions = ''; // Navigation result text
  bool _isLoading = false;   // Whether API call is in progress

  @override
  void initState() {
    super.initState();
    _fetchBuildings(); // Load buildings on init
  }

  /// Loads buildings from backend and caches last used ones
  Future<void> _fetchBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = List<Map<String, dynamic>>.from(data));

      // Try loading previous selections from local storage
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedBuilding = prefs.getInt('last_building');
        _selectedStart = prefs.getString('last_start');
        _selectedEnd = prefs.getString('last_end');
      });

      if (_selectedBuilding != null) {
        await _fetchPLDs(_selectedBuilding!);
      }
    } catch (e) {
      _speakAndSetError('Failed to load buildings.');
    }
  }

  /// Loads PLDs for selected building
  Future<void> _fetchPLDs(int buildingId) async {
    try {
      final plds = await ApiService.fetchPLDs(buildingId);
      setState(() => _plds = List<Map<String, dynamic>>.from(plds));
    } catch (e) {
      _speakAndSetError('Failed to load locations for this building.');
    }
  }

  /// Fetches directions between selected locations
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

      // Save selection to cache
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('last_building', _selectedBuilding!);
      prefs.setString('last_start', _selectedStart!);
      prefs.setString('last_end', _selectedEnd!);
    } catch (e) {
      _speakAndSetError('Failed to fetch directions.');
    }
    setState(() => _isLoading = false);
  }

  /// Helper to announce error via TTS and UI
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
                    value: b['id'] as int,
                    child: Text(b['name']),
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
                    value: p['name'] as String,
                    child: Text(p['name']),
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
                    value: p['name'] as String,
                    child: Text(p['name']),
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
    _tts.stop();
    super.dispose();
  }
}