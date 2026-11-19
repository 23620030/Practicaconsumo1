import 'package:flutter/foundation.dart';

/// URL base de la API Spring Boot.
///
/// - Chrome / Windows / iOS  -> http://localhost:8080
/// - Emulador Android        -> http://10.0.2.2:8080 (alias del localhost de la PC)
/// - Celular fisico          -> IP de la PC (ipconfig), ej. http://192.168.1.75:8080
class ApiConfig {
  /// Si usan celular fisico, escriban aqui la IP de su PC, ej. '192.168.1.75'.
  static const String? ipCelularFisico = null;

  static const int puerto = 8080;

  static String get baseUrl {
    if (ipCelularFisico != null) return 'http://$ipCelularFisico:$puerto';
    if (kIsWeb) return 'http://localhost:$puerto';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$puerto';
    }
    return 'http://localhost:$puerto';
  }

  // Rutas de los endpoints (las mismas del @RequestMapping de Spring Boot)
  static const String libros = '/api/libros';
}
