package mx.edu.tecnm.tlaxiaco.biblioteca.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Prueba de conexion: GET http://localhost:8080/
 * Si la app de Flutter recibe este texto, el puente funciona.
 */
@RestController
@CrossOrigin(origins = "*")
public class BienvenidaController {

    @GetMapping("/")
    public String bienvenida() {
        return "Bienvenido a la API de la Biblioteca ITT";
    }
}
