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
  // Base URL for API endpoints (change if your server address changes)
  static const String baseUrl = 'http://localhost:8000/api';

  /// Helper method to retrieve the stored authentication token.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// Fetches a list of all buildings from the backend.
  /// Returns a list of maps representing each building.
  static Future<List<Map<String, dynamic>>> fetchBuildings() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/buildings/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load buildings');
    }
  }

  /// Fetches detailed information about a specific building.
  ///
  /// [buildingId] is the integer ID of the building to query.
  /// Returns a map containing building details.
  static Future<Map<String, dynamic>> fetchBuildingDetails(int buildingId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/buildings/$buildingId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch building details');
    }
  }

  /// Fetches a list of PLDs (Physical Location Descriptors) for a specific building.
  ///
  /// [buildingId] is the ID of the building to get PLDs for.
  /// Returns a list of maps, each representing a PLD.
  static Future<List<Map<String, dynamic>>> fetchPLDs(int buildingId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/plds/?building=$buildingId'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load PLDs');
    }
  }

  /// Fetches navigation steps from one location to another within a building.
  ///
  /// [buildingId] is the ID of the building.
  /// [start] and [end] are PLD names or keys (e.g., "entrance", "lift").
  /// Returns a list of step-by-step direction strings.
  static Future<List<String>> fetchNavigationSteps({
    required int buildingId,
    required String start,
    required String end,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse(
      '$baseUrl/navigate/?building=$buildingId&start=$start&end=$end',
    );

    final response = await http.get(uri, headers: {'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['steps']);
    } else {
      throw Exception('Failed to fetch navigation steps');
    }
  }
}