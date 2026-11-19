package mx.edu.tecnm.tlaxiaco.biblioteca.service;

import java.util.List;
import java.util.Optional;

import mx.edu.tecnm.tlaxiaco.biblioteca.model.Libro;
import mx.edu.tecnm.tlaxiaco.biblioteca.repository.LibroRepository;
import org.springframework.stereotype.Service;

/**
 * Reglas y validaciones de la API.
 */
@Service
public class LibroService {

    private final LibroRepository repository;

    public LibroService(LibroRepository repository) {
        this.repository = repository;
    }

    public List<Libro> listar() {
        return repository.findAll();
    }

    public Optional<Libro> obtener(Long id) {
        return repository.findById(id);
    }

    public Libro guardar(Libro libro) {
        libro.setId(null); // el id lo genera la base de datos
        if (libro.getDisponible() == null) {
            libro.setDisponible(true);
        }
        return repository.save(libro);
    }

    public Optional<Libro> actualizar(Long id, Libro cambios) {
        return repository.findById(id).map(actual -> {
            actual.setTitulo(cambios.getTitulo());
            actual.setAutor(cambios.getAutor());
            actual.setAnio(cambios.getAnio());
            actual.setDisponible(cambios.getDisponible() != null ? cambios.getDisponible() : actual.getDisponible());
            return repository.save(actual);
        });
    }

    public boolean eliminar(Long id) {
        if (!repository.existsById(id)) {
            return false;
        }
        repository.deleteById(id);
        return true;
    }

    /** Regla de negocio: titulo y autor son obligatorios. */
    public boolean esValido(Libro libro) {
        return libro.getTitulo() != null && !libro.getTitulo().isBlank()
                && libro.getAutor() != null && !libro.getAutor().isBlank();
    }
}
