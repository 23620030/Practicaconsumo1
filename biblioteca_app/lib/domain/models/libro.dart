/// Espejo de la clase Libro.java de Spring Boot.
///
///   Java Long    -> Dart int
///   Java String  -> Dart String
///   Java Integer -> Dart int
///   Java Boolean -> Dart bool
///
/// Las claves del JSON se llaman igual que los atributos de Java.
class Libro {
  final int? id; // null cuando el libro aun no existe en la API
  final String titulo;
  final String autor;
  final int anio;
  final bool disponible;

  const Libro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.anio,
    required this.disponible,
  });

  /// JSON -> Libro (se usa al LEER: GET)
  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
        id: json['id'] as int?,
        titulo: json['titulo'] as String,
        autor: json['autor'] as String,
        anio: (json['anio'] as num?)?.toInt() ?? 0,
        disponible: json['disponible'] as bool? ?? true,
      );

  /// Libro -> JSON (se usa al ENVIAR: POST y PUT). El id no se envia en el body.
  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'autor': autor,
        'anio': anio,
        'disponible': disponible,
      };

  /// Copia del libro con algunos campos cambiados (util para editar).
  Libro copyWith({String? titulo, String? autor, int? anio, bool? disponible}) =>
      Libro(
        id: id,
        titulo: titulo ?? this.titulo,
        autor: autor ?? this.autor,
        anio: anio ?? this.anio,
        disponible: disponible ?? this.disponible,
      );
}
