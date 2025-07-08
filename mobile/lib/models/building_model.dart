// ==============================
// File: lib/models/building_model.dart
// Description: Defines the Building model used in API responses.
// ==============================

class Building {
  final int id;
  final String name;

  Building({required this.id, required this.name});

  /// Factory constructor to parse JSON into a Building object
  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
    );
  }

  /// Converts Building object to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Building(id: $id, name: $name)';
}