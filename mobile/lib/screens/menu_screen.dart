// ===============================
// File: lib/screens/menu_screen.dart
// Description: Main menu screen with navigation to different features + Logout
// ===============================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/scan_building_screen.dart';
import 'package:mobile/screens/navigation_assistance_screen.dart';
import 'package:mobile/screens/login_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// Logs out by clearing the auth token and redirecting to login screen.
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    // Navigate to login and clear history
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
      appBar: AppBar(
        title: const Text('Naviplus Menu'),
      ),
      body: ListView(
        children: [
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

          const Divider(),
          _buildMenuItem(
            'Logout',
            Icons.logout,
            _logout,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// Helper method to build a ListTile menu item with optional text color
  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}