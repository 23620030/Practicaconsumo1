package mx.edu.tecnm.tlaxiaco.biblioteca.controller;

import java.util.List;

import mx.edu.tecnm.tlaxiaco.biblioteca.model.Libro;
import mx.edu.tecnm.tlaxiaco.biblioteca.service.LibroService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Endpoints del CRUD de libros.
 * Ruta = prefijo de @RequestMapping + lo que diga cada @...Mapping.
 *
 *   GET    /api/libros        -> lista de libros            (200)
 *   GET    /api/libros/{id}   -> un libro                   (200 / 404)
 *   POST   /api/libros        -> crea un libro              (201 / 400)
 *   PUT    /api/libros/{id}   -> actualiza un libro         (200 / 400 / 404)
 *   DELETE /api/libros/{id}   -> elimina un libro           (204 / 404)
 *
 * La API YA tiene los 5 endpoints. En Flutter solo estan consumidos GET y POST;
 * PUT y DELETE los consumen ustedes en la practica.
 */
@RestController
@RequestMapping("/api/libros")
@CrossOrigin(origins = "*")
public class LibroController {

    private final LibroService service;

    public LibroController(LibroService service) {
        this.service = service;
    }

    @GetMapping
    public List<Libro> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Libro> obtener(@PathVariable Long id) {
        return service.obtener(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Libro> crear(@RequestBody Libro libro) {
        if (!service.esValido(libro)) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(service.guardar(libro));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Libro> actualizar(@PathVariable Long id, @RequestBody Libro libro) {
        if (!service.esValido(libro)) {
            return ResponseEntity.badRequest().build();
        }
        return service.actualizar(id, libro)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        return service.eliminar(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
