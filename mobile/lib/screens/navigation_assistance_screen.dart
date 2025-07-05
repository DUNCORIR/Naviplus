import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/api_service.dart';

/// This screen allows users to input building/start/end
/// and receive both visual and voice directions.
class NavigationAssistanceScreen extends StatefulWidget {
  const NavigationAssistanceScreen({super.key});

  @override
  State<NavigationAssistanceScreen> createState() => _NavigationAssistanceScreenState();
}

class _NavigationAssistanceScreenState extends State<NavigationAssistanceScreen> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final FlutterTts _tts = FlutterTts(); // Text-to-speech engine

  bool _isLoading = false;
  String? _errorMessage;
  List<String> _steps = [];

  /// Uses TTS to read out the directions
  Future<void> _speakDirections(List<String> steps) async {
    for (final step in steps) {
      await _tts.speak(step);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  /// Fetch directions from backend and announce them
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
      await _speakDirections(steps); // Speak the steps out loud
    } catch (e) {
      setState(() => _errorMessage = 'Failed to fetch directions.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Builds a reusable text input field
  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField("Building ID", _buildingController),
            _buildInputField("Start Point", _startController),
            _buildInputField("End Point", _endController),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : _getNavigationSteps,
              child: const Text("Get Directions"),
            ),

            const SizedBox(height: 16),

            if (_isLoading)
              const CircularProgressIndicator(),

            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            if (_steps.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                "Directions:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Repeat TTS button
              ElevatedButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text("Repeat Directions"),
                onPressed: () => _speakDirections(_steps),
              ),

              const SizedBox(height: 8),

              // List spoken steps on screen
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.directions_walk),
                    title: Text(_steps[index]),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}