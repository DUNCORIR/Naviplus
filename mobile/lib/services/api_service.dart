// =============================
// File: lib/services/api_service.dart
// Description: Handles HTTP requests to backend for Naviplus
// =============================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for interacting with the Naviplus backend.
/// Includes methods for fetching buildings, PLDs, and navigation steps.
class ApiService {
  // Base URL for API endpoints — change this if backend address changes
  static const String baseUrl = 'http://localhost:8000/api';

  /// Retrieves the saved authentication token from SharedPreferences.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Make sure this matches login_screen.dart
  }

  /// Fetches all buildings the user has access to.
  /// Returns a list of building objects.
  static Future<List<Map<String, dynamic>>> fetchBuildings() async {
    final token = await _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/buildings/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load buildings: ${response.statusCode}');
    }
  }

  /// Fetches detailed data about a single building.
  static Future<Map<String, dynamic>> fetchBuildingDetails(int buildingId) async {
    final token = await _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/buildings/$buildingId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch building details: ${response.statusCode}');
    }
  }

  /// Fetches PLDs (points like entrances, lifts, stairs) for a given building.
  static Future<List<Map<String, dynamic>>> fetchPLDs(int buildingId) async {
    final token = await _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/plds/?building=$buildingId'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load PLDs: ${response.statusCode}');
    }
  }

  /// Retrieves navigation steps from one point to another inside a building.
  static Future<List<String>> fetchNavigationSteps({
    required int buildingId,
    required String start,
    required String end,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('User not authenticated');

    final uri = Uri.parse(
      '$baseUrl/navigate/?building=$buildingId&start=$start&end=$end',
    );

    final response = await http.get(uri, headers: {
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['steps']);
    } else {
      throw Exception('Failed to fetch navigation steps: ${response.statusCode}');
    }
  }
}