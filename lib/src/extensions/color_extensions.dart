
import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Color objesinden, Hex string (örneğin '#FF00FF' veya 'FF00FF') değeri oluşturur.
  String colorToHex() {
    var digit8 = toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${digit8.substring(2)}';
  }
}

extension HexStringToColor on String {
  /// Hex string (örneğin '#FF00FF' veya 'FF00FF') değerinden Color objesi oluşturur.
  Color toColor() {
    String hex = toUpperCase().replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Eğer alfa yoksa tam opak yap
    }
    if (hex.length != 8) {
      throw FormatException("Hex string must be 6 or 8 characters long.");
    }
    final intColor = int.parse(hex, radix: 16);
    return Color(intColor);
  }
}
