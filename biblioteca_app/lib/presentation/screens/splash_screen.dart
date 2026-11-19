import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../networking/dio_client.dart';

/// Entra primero (initialLocation). Prueba la conexion con GET /
/// y despues navega a Home con go (para no poder regresar al splash).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _estado = 'Conectando con la API...';

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final ok = await context.read<DioClient>().probarConexion();
    if (!mounted) return;
    setState(() => _estado = ok ? 'Conexión OK' : 'Sin conexión con la API');
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_library, size: 72),
            const SizedBox(height: 16),
            Text('Biblioteca ITT', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(_estado),
          ],
        ),
      ),
    );
  }
}
