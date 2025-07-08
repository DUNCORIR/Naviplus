// ======================================
// File: lib/screens/scan_building_screen.dart
// Description: Fetches and displays available buildings using Building model
// ======================================

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/building_model.dart';

/// This screen displays a list of buildings fetched from the backend.
/// Each building is shown in a card, and the user can tap on one
/// (future logic may drill down into floors, rooms, etc.).
class ScanBuildingScreen extends StatefulWidget {
  const ScanBuildingScreen({super.key});

  @override
  State<ScanBuildingScreen> createState() => _ScanBuildingScreenState();
}

class _ScanBuildingScreenState extends State<ScanBuildingScreen> {
  late Future<List<Building>> _buildingListFuture; // Async fetch of buildings

  @override
  void initState() {
    super.initState();
    _buildingListFuture = ApiService.fetchBuildings(); // Start fetch on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Building")),
      body: FutureBuilder<List<Building>>(
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
            // No buildings returned
            return const Center(
              child: Text('No buildings found.'),
            );
          }

          // Success: Show the building list
          final buildings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(building.name),
                  subtitle: Text('ID: ${building.id}'),
                  onTap: () {
                    // Placeholder: Tapping a building could navigate deeper
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${building.name}')),
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