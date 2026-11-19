package mx.edu.tecnm.tlaxiaco.biblioteca;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Punto de entrada de la API.
 * En VS Code: abre este archivo y presiona "Run" sobre el metodo main.
 * En consola: mvn spring-boot:run
 */
@SpringBootApplication
public class BibliotecaApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(BibliotecaApiApplication.class, args);
    }
}
