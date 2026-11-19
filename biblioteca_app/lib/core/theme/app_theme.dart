import 'package:flutter/material.dart';

/// Un solo lugar para colores y tipografia.
/// Cambien el color semilla para personalizar su app.
class AppTheme {
  static const Color semilla = Color(0xFF1B396A); // azul TecNM

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: semilla,
    brightness: Brightness.light,
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: semilla,
    brightness: Brightness.dark,
  );
}
