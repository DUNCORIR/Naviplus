// ==============================
// File: lib/models/pld_model.dart
// Description: Defines the PLD (Physical Location Descriptor) model.
// ==============================

class PLD {
  final int id;
  final String name;

  PLD({required this.id, required this.name});

  /// Factory constructor to parse JSON into a PLD object
  factory PLD.fromJson(Map<String, dynamic> json) {
    return PLD(
      id: json['id'],
      name: json['name'],
    );
  }

  /// Converts PLD object to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'PLD(id: $id, name: $name)';
}