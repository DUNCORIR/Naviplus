// ======================================
// File: lib/screens/scan_building_screen.dart
// Description: Fetches and displays available buildings for scanning
// ======================================

import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Displays a list of buildings retrieved from the backend.
/// Users can select a building to proceed (future logic can navigate deeper).
class ScanBuildingScreen extends StatefulWidget {
  const ScanBuildingScreen({super.key});

  @override
  State<ScanBuildingScreen> createState() => _ScanBuildingScreenState();
}

class _ScanBuildingScreenState extends State<ScanBuildingScreen> {
  late Future<List<dynamic>> _buildingListFuture;

  @override
  void initState() {
    super.initState();
    _buildingListFuture = ApiService.fetchBuildings(); // Start API fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Building")),
      body: FutureBuilder<List<dynamic>>(
        future: _buildingListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while waiting
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if API fails
            return Center(
              child: Text(
                'Failed to load buildings.\nPlease try again later.',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No buildings found
            return const Center(
              child: Text('No buildings found.'),
            );
          }

          // Success: Show list of buildings
          final buildings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              return Card(
                child: ListTile(
                  title: Text(building['name'] ?? 'Unnamed Building'),
                  subtitle: Text('ID: ${building['id']}'),
                  onTap: () {
                    // Future logic: navigate to floors or amenities
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${building['name']}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}