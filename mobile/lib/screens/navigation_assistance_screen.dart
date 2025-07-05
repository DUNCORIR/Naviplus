// ================================================
// File: lib/screens/navigation_assistance_screen.dart
// Description: Voice-friendly indoor navigation screen with dynamic dropdowns
// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/api_service.dart';

class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final FlutterTts _tts = FlutterTts();

  String? _selectedBuilding;
  String? _selectedStart;
  String? _selectedEnd;

  List<Map<String, dynamic>> _buildings = []; // List of {id, name}
  List<String> _plds = [];                    // Names of PLDs in selected building
  List<String> _steps = [];

  bool _isLoading = false;
  String? _errorMessage;

  /// Fetches list of buildings on screen load
  Future<void> _loadBuildings() async {
    try {
      final data = await ApiService.fetchBuildings();
      setState(() => _buildings = data);
    } catch (_) {
      _speakAndSetError('Could not load buildings.');
    }
  }

  /// Fetch PLDs when a building is selected
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

  /// Speak and display error message
  void _speakAndSetError(String message) async {
    await _tts.speak(message);
    setState(() => _errorMessage = message);
  }

  /// Fetch directions and speak them
  Future<void> _getNavigationSteps() async {
    if (_selectedBuilding == null || _selectedStart == null || _selectedEnd == null) {
      _speakAndSetError('Please select building, start, and end.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _steps = [];
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
      _speakAndSetError('Failed to retrieve directions.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Repeats voice instructions
  Future<void> _repeatInstructions() async {
    for (final step in _steps) {
      await _tts.speak(step);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  @override
  void dispose() {
    _tts.stop();
    _tts.dispose();
    super.dispose();
  }

  /// Dropdown builder
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Assistance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button support
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                onPressed: _repeatInstructions,
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