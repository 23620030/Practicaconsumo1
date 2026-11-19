import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/libro_controller.dart';
import '../widgets/libro_form.dart';

/// Formulario que hace el PUT. Recibe el id desde la ruta /editar/:id
/// y toma el libro de la lista que ya tiene el controller.
class EditarLibroScreen extends StatelessWidget {
  const EditarLibroScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final c = context.read<LibroController>();
    final libro = c.buscarPorId(id);

    return Scaffold(
      appBar: AppBar(title: Text('Editar libro #$id')),
      body: libro == null
          ? const Center(child: Text('Libro no encontrado'))
          : LibroForm(
              inicial: libro,
              textoBoton: 'Actualizar (PUT)',
              onGuardar: c.actualizar,
            ),
    );
  }
}
