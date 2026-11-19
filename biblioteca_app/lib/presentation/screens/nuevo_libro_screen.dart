import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/libro_controller.dart';
import '../widgets/libro_form.dart';

/// Formulario que hace el POST.
class NuevoLibroScreen extends StatelessWidget {
  const NuevoLibroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.read<LibroController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo libro')),
      body: LibroForm(
        textoBoton: 'Guardar (POST)',
        onGuardar: c.crear,
      ),
    );
  }
}
