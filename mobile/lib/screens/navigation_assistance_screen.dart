// =============================
// File: lib/screens/navigation_assistance_screen.dart
// Description: UI for selecting start/end points and getting directions
// =============================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

/// Screen that provides step-by-step directions inside a building.
/// Visually impaired users can use dropdowns or voice commands.
class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts();

  // Selected values for dropdowns
  int? _selectedBuilding;
  String? _startLocation;
  String? _endLocation;

  // Data sources
  List<Map<String, dynamic>> _buildings = [];
  List<Map<String, dynamic>> _plds = [];
  List<String> _steps = [];

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBuildings();
    _loadLastRoute();
  }

  /// Text-to-speech helper
  Future<void> _speak(String message) async {
    await _tts.speak(message);
  }

  /// Load saved recent route from shared preferences
  Future<void> _loadLastRoute() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _startLocation = prefs.getString('last_start');
      _endLocation = prefs.getString('last_end');
    });
  }

  /// Save recent route for reuse
  Future<void> _saveRoute(String start, String end) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_start', start);
    await prefs.setString('last_end', end);
  }

  /// Fetch available buildings from backend
  Future<void> _fetchBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = data);
    } catch (e) {
      setState(() => _error = 'Failed to load buildings');
      _speak('Failed to load buildings');
    }
  }

  /// Fetch PLDs for the selected building
  Future<void> _fetchPLDs(int buildingId) async {
    try {
      final plds = await ApiService.fetchPLDs(buildingId);
      setState(() => _plds = plds);
    } catch (e) {
      setState(() => _error = 'Failed to load locations');
      _speak('Failed to load locations');
    }
  }

  /// Handle changes in building dropdown
  void _onBuildingSelected(int? buildingId) {
    setState(() {
      _selectedBuilding = buildingId;
      _startLocation = null;
      _endLocation = null;
      _plds = [];
    });

    if (buildingId != null) {
      _fetchPLDs(buildingId);
    }
  }

  /// Request directions from backend
  Future<void> _getDirections() async {
    if (_selectedBuilding == null || _startLocation == null || _endLocation == null) {
      _speak('Please select building, start and end');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _steps = [];
    });

    try {
      final steps = await ApiService.fetchNavigationSteps(
        buildingId: _selectedBuilding!,
        start: _startLocation!,
        end: _endLocation!,
      );

      setState(() => _steps = steps);
      _speak("Here are your directions: ${steps.join(", ")}");
      _saveRoute(_startLocation!, _endLocation!);
    } catch (e) {
      setState(() => _error = 'Failed to get directions');
      _speak('Failed to get directions');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Widget builder for dropdowns
  DropdownButton<String> _buildDropdown({
    required String hint,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      hint: Text(hint),
      value: value,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
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
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Building Dropdown
                  DropdownButton<int>(
                    hint: const Text('Select Building'),
                    value: _selectedBuilding,
                    isExpanded: true,
                    items: _buildings.map((b) {
                      return DropdownMenuItem(
                        value: b['id'],
                        child: Text(b['name'] ?? 'Building ${b['id']}'),
                      );
                    }).toList(),
                    onChanged: _onBuildingSelected,
                  ),

                  const SizedBox(height: 10),

                  // Start Location Dropdown
                  if (_plds.isNotEmpty)
                    _buildDropdown(
                      hint: 'Start Location',
                      value: _startLocation,
                      options: _plds.map((p) => p['name'] as String).toList(),
                      onChanged: (val) => setState(() => _startLocation = val),
                    ),

                  const SizedBox(height: 10),

                  // End Location Dropdown
                  if (_plds.isNotEmpty)
                    _buildDropdown(
                      hint: 'End Location',
                      value: _endLocation,
                      options: _plds.map((p) => p['name'] as String).toList(),
                      onChanged: (val) => setState(() => _endLocation = val),
                    ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _getDirections,
                    child: const Text('Get Directions'),
                  ),

                  const SizedBox(height: 20),

                  if (_steps.isNotEmpty) ...[
                    const Text('Directions:', style: TextStyle(fontWeight: FontWeight.bold)),
                    for (final step in _steps) Text('- $step'),
                  ],

                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
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