package mx.edu.tecnm.tlaxiaco.biblioteca.repository;

import mx.edu.tecnm.tlaxiaco.biblioteca.model.Libro;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Consultas a la base de datos. JpaRepository ya trae
 * findAll, findById, save, deleteById, existsById, count...
 *
 * OJO: este repository es del SERVIDOR, no es el de Flutter.
 */
public interface LibroRepository extends JpaRepository<Libro, Long> {
}
