import 'package:dio/dio.dart';

import '../core/constants/api_config.dart';

/// Cliente Dio con URL base, timeouts, headers JSON y logs.
/// Es el UNICO archivo que sabe a que servidor se conecta la app.
class DioClient {
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Muestra en la consola cada peticion y su respuesta.
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  late final Dio dio;

  /// Prueba de conexion con GET / (BienvenidaController).
  Future<bool> probarConexion() async {
    try {
      final res = await dio.get('/');
      print('Conexion OK -> ${res.statusCode}: ${res.data}');
      return res.statusCode == 200;
    } on DioException catch (e) {
      print('Sin conexion con la API: ${e.message}');
      return false;
    }
  }
}
