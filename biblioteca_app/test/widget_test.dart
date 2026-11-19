import 'package:biblioteca_app/domain/models/libro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson lee el JSON de Spring Boot', () {
    final libro = Libro.fromJson({
      'id': 1,
      'titulo': 'Pedro Páramo',
      'autor': 'Juan Rulfo',
      'anio': 1955,
      'disponible': true,
    });
    expect(libro.id, 1);
    expect(libro.titulo, 'Pedro Páramo');
    expect(libro.anio, 1955);
  });

  test('toJson no envía el id', () {
    const libro = Libro(id: 9, titulo: 'A', autor: 'B', anio: 2000, disponible: false);
    expect(libro.toJson().containsKey('id'), false);
  });
}
