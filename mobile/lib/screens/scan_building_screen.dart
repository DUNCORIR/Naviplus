import 'package:flutter/material.dart';

/// This screen allows users to initiate a building scan process.
/// Currently a placeholder, it will eventually connect to sensors or backend
/// to detect user's location in the building and guide them accordingly.
class ScanBuildingScreen extends StatelessWidget {
  const ScanBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar with screen title
      appBar: AppBar(
        title: const Text('Scan Building'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Center content vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading/title
            const Text(
              'Scan Building Mode',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Subheading or instructions
            const Text(
              'This feature will allow you to scan your current location '
              'in the building and get guidance.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // "Start Scan" button (currently non-functional)
            ElevatedButton.icon(
              onPressed: () {
                // Show a temporary message while scan functionality is pending
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Scanning not implemented yet')),
                );
              },
              icon: const Icon(Icons.camera_alt), // Icon beside button text
              label: const Text('Start Scan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
