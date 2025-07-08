// ================================================
// File: lib/screens/menu_screen.dart
// Description: Main menu with access to key features
//              Includes logout and route to map view
// ================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'scan_building_screen.dart';
import 'navigation_assistance_screen.dart';
import 'voice_command_screen.dart';
import 'map_screen.dart';
import 'login_screen.dart';

/// Main navigation menu for the Naviplus app
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// Logs the user out by clearing token and redirecting to login
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naviplus Menu')),
      body: ListView(
        children: [
          _buildMenuItem(
            title: 'Scan Building',
            icon: Icons.camera_alt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanBuildingScreen()),
            ),
          ),
          _buildMenuItem(
            title: 'Navigation Assistance',
            icon: Icons.navigation,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavigationAssistanceScreen()),
            ),
          ),
          _buildMenuItem(
            title: 'Voice Commands',
            icon: Icons.mic,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VoiceCommandScreen()),
            ),
          ),
          _buildMenuItem(
            title: 'Map View',
            icon: Icons.map,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            ),
          ),

          const Divider(),
          _buildMenuItem(
            title: 'Logout',
            icon: Icons.logout,
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  /// Helper to create consistent ListTile buttons
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}