// ==============================================
// File: lib/screens/scan_building_screen.dart
// Description: Displays list of buildings fetched from backend.
// Uses strongly-typed Building model.
// ==============================================

import 'package:flutter/material.dart';
import '../models/building_model.dart';
import '../services/api_service.dart';

/// Screen that displays a list of buildings fetched from the backend.
/// Can be extended to allow scanning or exploring building contents.
class ScanBuildingScreen extends StatefulWidget {
  const ScanBuildingScreen({super.key});

  @override
  State<ScanBuildingScreen> createState() => _ScanBuildingScreenState();
}

class _ScanBuildingScreenState extends State<ScanBuildingScreen> {
  late Future<List<Building>> _buildingsFuture;

  @override
  void initState() {
    super.initState();
    _buildingsFuture = ApiService.fetchBuildings(); // Fetch buildings on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Building")),
      body: FutureBuilder<List<Building>>(
        future: _buildingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the backend
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If the API call failed
            return Center(
              child: Text(
                'Failed to load buildings.\nPlease try again later.',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no buildings were found
            return const Center(
              child: Text('No buildings available.'),
            );
          }

          // If success, show list of buildings
          final buildings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              return Card(
                child: ListTile(
                  title: Text(building.name),
                  subtitle: Text('ID: ${building.id}'),
                  onTap: () {
                    // Placeholder: feedback or navigation
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