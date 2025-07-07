// ===============================
// File: lib/screens/menu_screen.dart
// Description: Main menu screen with navigation to different features
// ===============================

import 'package:flutter/material.dart';
import 'package:mobile/screens/scan_building_screen.dart';
import 'package:mobile/screens/navigation_assistance_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naviplus Menu'),
      ),
      body: ListView(
        children: [
          // Reusable list items for different features
          _buildMenuItem(
            'Scan Building',
            Icons.camera_alt,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
            ),
          ),
          _buildMenuItem(
            'Navigation Assistance',
            Icons.navigation,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavigationAssistanceScreen()),
            ),
          ),
          _buildMenuItem(
            'Voice Commands',
            Icons.mic,
            () => Navigator.pushNamed(context, '/voice'),
          ),
        ],
      ),
    );
  }

  /// Helper method to build menu entries with icon, label, and navigation
  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}