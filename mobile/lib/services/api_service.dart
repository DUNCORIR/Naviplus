// =============================
// File: lib/services/api_service.dart
// Description: Handles HTTP requests to backend for Naviplus using typed models.
// =============================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/models/building_model.dart';
import 'package:mobile/models/pld_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  /// Retrieves auth token from SharedPreferences.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  /// Fetches list of buildings and maps to Building objects.
  static Future<List<Building>> fetchBuildings() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/buildings/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Building.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load buildings');
    }
  }

  /// Fetches a single building's details as a Building object.
  static Future<Building> fetchBuildingDetails(int buildingId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/buildings/$buildingId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Building.fromJson(data);
    } else {
      throw Exception('Failed to fetch building details');
    }
  }

  /// Fetches PLDs for a given building and maps to PLD objects.
  static Future<List<PLD>> fetchPLDs(int buildingId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/plds/?building=$buildingId'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PLD.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load PLDs');
    }
  }

  /// Fetches navigation steps as plain list of strings.
  static Future<List<String>> fetchNavigationSteps({
    required int buildingId,
    required String start,
    required String end,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/navigate/?building=$buildingId&start=$start&end=$end');

    final response = await http.get(uri, headers: {'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['steps']);
    } else {
      throw Exception('Failed to fetch navigation steps');
    }
  }
}