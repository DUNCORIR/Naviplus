// =============================
// File: lib/main.dart
// Description: Accessible welcome screen for visually impaired users
// =============================

import 'package:flutter/material.dart';

void main() {
  runApp(const NaviPlusApp());
}

class NaviPlusApp extends StatelessWidget {
  const NaviPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviplus Assist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main background layout
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          // Vertically stacked content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message
              Text(
                'Welcome to Naviplus',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Short description for the user
              Text(
                'Tap below to begin navigation or scan a building.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // CTA: Start Scanning
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to Scan Building screen
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Building'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              // CTA: Navigation Help
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to Navigation Assistance screen
                },
                icon: const Icon(Icons.navigation),
                label: const Text('Navigation Assistance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}