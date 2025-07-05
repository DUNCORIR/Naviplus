// ======================================
// File: lib/screens/navigation_assistance_screen.dart
// Description: Allows user to request navigation steps between PLDs
// ======================================

import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// This screen lets users pick building/start/end points and fetch indoor directions.
/// Results are displayed in an accessible format.
class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  List<String> _steps = [];

  /// Fetches navigation steps by calling the backend API
  Future<void> _getNavigationSteps() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _steps = [];
    });

    try {
      final steps = await ApiService.fetchNavigationSteps(
        buildingId: _buildingController.text,
        start: _startController.text,
        end: _endController.text,
      );
      setState(() => _steps = steps);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to fetch directions.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Builds a text field for inputting parameters
  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User inputs for navigation
            _buildInputField("Building ID", _buildingController),
            _buildInputField("Start Point", _startController),
            _buildInputField("End Point", _endController),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : _getNavigationSteps,
              child: const Text("Get Directions"),
            ),

            const SizedBox(height: 16),

            // Show loading or error
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            // Show navigation results
            if (_steps.isNotEmpty) ...[
              const Text(
                "Directions:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._steps.map((step) => ListTile(
                    leading: const Icon(Icons.navigation),
                    title: Text(step),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}