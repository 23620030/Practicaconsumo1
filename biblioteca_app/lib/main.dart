import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'domain/repository/libro_repository.dart';
import 'networking/dio_client.dart';
import 'presentation/controllers/libro_controller.dart';
import 'routes/app_router.dart';
import 'services/libro_service.dart';

void main() {
  // Se arma la cadena: Networking -> Service -> Repository -> Controller
  final dioClient = DioClient();
  final service = LibroService(dioClient.dio);
  final repository = LibroRepository(service);

  runApp(
    MultiProvider(
      providers: [
        Provider<DioClient>.value(value: dioClient),
        ChangeNotifierProvider(
          create: (_) => LibroController(repository)..cargar(),
        ),
      ],
      child: const BibliotecaApp(),
    ),
  );
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Biblioteca ITT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
