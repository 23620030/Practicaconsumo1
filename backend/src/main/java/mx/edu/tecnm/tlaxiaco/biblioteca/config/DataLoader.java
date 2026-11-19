package mx.edu.tecnm.tlaxiaco.biblioteca.config;

import java.util.List;

import mx.edu.tecnm.tlaxiaco.biblioteca.model.Libro;
import mx.edu.tecnm.tlaxiaco.biblioteca.repository.LibroRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Datos de prueba: si la tabla esta vacia, inserta 5 libros
 * para que el GET no devuelva [ ] vacio.
 */
@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner cargarDatos(LibroRepository repository) {
        return args -> {
            if (repository.count() == 0) {
                repository.saveAll(List.of(
                        new Libro("Cien años de soledad", "Gabriel García Márquez", 1967, true),
                        new Libro("Pedro Páramo", "Juan Rulfo", 1955, true),
                        new Libro("El laberinto de la soledad", "Octavio Paz", 1950, false),
                        new Libro("Clean Code", "Robert C. Martin", 2008, true),
                        new Libro("Flutter in Action", "Eric Windmill", 2020, true)
                ));
                System.out.println(">>> Datos de prueba cargados: 5 libros");
            }
        };
    }
}
