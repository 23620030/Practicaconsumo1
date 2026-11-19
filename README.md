# Práctica 3: Consumo de una API Spring Boot desde Flutter — Biblioteca ITT

**Tecnológico Nacional de México · Instituto Tecnológico de Tlaxiaco**
Desarrollo de Aplicaciones Móviles · Ingeniería en Sistemas Computacionales

| Modalidad | Duración | Valor | Material |
|---|---|---|---|
| Parejas | ____ minutos | ____ puntos | Computadora con Flutter, Java 17+, VS Code y este repositorio |

**Integrantes:** 1. ______________________  2. ______________________

---

## Objetivo

Completar el CRUD de una app en Flutter que consume una API REST hecha en Spring Boot. La app ya **lee** libros (GET) y **registra** libros nuevos (POST). Ustedes van a programar **editar (PUT)** y **eliminar (DELETE)** en las capas service, repository y controller, respetando la estructura de carpetas.

## Relación con lo que ya saben

En la Pokédex mínima la app pedía datos a PokéAPI con `http` y los convertía con `fromJson`. Aquí la idea es la misma (pedir, recibir JSON y mostrarlo), pero:

- la API es **nuestra** (Spring Boot en el puerto **8080**),
- usamos **dio** para las peticiones, **provider** para el estado y **go_router** para la navegación,
- cada paso vive en **su propia carpeta**: vista → controller → repository → service → networking → API.

```
 App Flutter                                              Servidor
┌──────────┐   ┌────────────┐   ┌────────────┐   ┌─────────┐   ┌────────────┐      ┌──────────────┐
│ screens/ │ → │controllers/│ → │repository/ │ → │services/│ → │networking/ │ ───▶ │ Spring Boot  │
│  Vista   │   │  Estado    │   │JSON→modelo │   │  Rutas  │   │ Dio :8080  │ JSON │  + H2/MySQL  │
└──────────┘   └────────────┘   └────────────┘   └─────────┘   └────────────┘ ◀─── └──────────────┘
```

> **Regla de oro:** la vista nunca llama a la API directamente. Un archivo, una responsabilidad. El backend no se toca.

---

## La API (ya está lista, solo se lee)

Base: `http://localhost:8080`

| Método | Ruta | Qué hace | Body | Respuesta | En Flutter |
|---|---|---|---|---|---|
| GET | `/` | Bienvenida (prueba de conexión) | — | 200 texto | ✅ Hecho |
| GET | `/api/libros` | Lista todos los libros | — | 200 + lista JSON | ✅ Hecho |
| GET | `/api/libros/{id}` | Un libro | — | 200 / 404 | ⭐ Reto |
| POST | `/api/libros` | Crea un libro | JSON | 201 + libro / 400 | ✅ Hecho |
| PUT | `/api/libros/{id}` | Actualiza un libro | JSON | 200 + libro / 400 / 404 | 📝 **TODO** |
| DELETE | `/api/libros/{id}` | Elimina un libro | — | 204 / 404 | 📝 **TODO** |

Así responde `GET /api/libros`:

```json
[
  { "id": 1, "titulo": "Cien años de soledad", "autor": "Gabriel García Márquez", "anio": 1967, "disponible": true },
  { "id": 2, "titulo": "Pedro Páramo", "autor": "Juan Rulfo", "anio": 1955, "disponible": true }
]
```

| Java (`Libro.java`) | Dart (`libro.dart`) |
|---|---|
| `Long id` | `int? id` |
| `String titulo`, `String autor` | `String` |
| `Integer anio` | `int` |
| `Boolean disponible` | `bool` |

---

## Estructura del repositorio

```
PracticaConsumo/
├── README.md                         ← esta guía
├── backend/                          ← API Spring Boot (NO se modifica)
│   ├── pom.xml
│   ├── Biblioteca_API.postman_collection.json   ← las 6 peticiones para importar en Postman
│   └── src/main/
│       ├── java/mx/edu/tecnm/tlaxiaco/biblioteca/
│       │   ├── BibliotecaApiApplication.java
│       │   ├── controller/  LibroController.java · BienvenidaController.java
│       │   ├── service/     LibroService.java
│       │   ├── repository/  LibroRepository.java
│       │   ├── model/       Libro.java
│       │   └── config/      CorsConfig.java · DataLoader.java
│       └── resources/application.properties
└── biblioteca_app/                   ← App Flutter (aquí trabajan)
    ├── pubspec.yaml
    └── lib/
        ├── core/
        │   ├── constants/api_config.dart     URL base según la plataforma
        │   └── theme/app_theme.dart          colores (Material 3)
        ├── networking/dio_client.dart        Dio, timeouts, logs, prueba de conexión
        ├── services/libro_service.dart       rutas de cada endpoint        ← TODO 1
        ├── domain/
        │   ├── models/libro.dart             fromJson / toJson
        │   └── repository/libro_repository.dart  JSON → Libro          ← TODO 2
        ├── presentation/
        │   ├── controllers/libro_controller.dart estado (loading/error) ← TODO 3
        │   ├── screens/  splash · home · nuevo_libro · editar_libro
        │   └── widgets/  libro_tile.dart · libro_form.dart
        ├── routes/app_router.dart            go_router
        └── main.dart
```

### ¿Qué archivo se modifica?

| Archivo | Qué contiene | ¿Se modifica? |
|---|---|---|
| `lib/main.dart` | Arma la cadena networking → service → repository → controller | No |
| `lib/core/constants/api_config.dart` | URL base | Solo si usan celular físico |
| `lib/services/libro_service.dart` | GET y POST hechos; PUT y DELETE vacíos | **Sí, TODO 1** |
| `lib/domain/repository/libro_repository.dart` | GET y POST hechos; PUT y DELETE vacíos | **Sí, TODO 2** |
| `lib/presentation/controllers/libro_controller.dart` | `cargar()` y `crear()` hechos | **Sí, TODO 3** |
| `lib/presentation/screens/*`, `widgets/*` | Vistas; los botones Editar y Eliminar ya están conectados | No |
| `backend/**` | La API | **No** |

---

## Requisitos previos

- Flutter 3.22 o superior (`flutter --version`)
- Java JDK 17 o superior (`java -version`)
- VS Code con las extensiones: **Flutter**, **Extension Pack for Java** y **Spring Boot Extension Pack** (VS Code las recomienda solas al abrir el repositorio)
- **Postman** instalado (https://www.postman.com/downloads/) para probar los endpoints
- Opcional: Maven (`mvn -v`). Si no lo tienen, la API se corre con el botón **Run** de VS Code.

---

## Instrucciones

### Paso 1. Clonar el repositorio

1. Abran una terminal en la carpeta donde guardan sus proyectos y ejecuten:
   ```bash
   git clone https://github.com/23620030/PracticaConsumo.git
   cd PracticaConsumo
   code .
   ```
2. Si VS Code pregunta si confían en los autores, elijan **Sí**. Instalen las extensiones recomendadas si las sugiere.

### Paso 2. Levantar la API Spring Boot

3. Abran `backend/src/main/java/mx/edu/tecnm/tlaxiaco/biblioteca/BibliotecaApiApplication.java`.
4. Esperen a que la extensión de Java termine de descargar dependencias (barra inferior) y presionen **Run** arriba del método `main`.
   *Alternativa con Maven:* `cd backend` y luego `mvn spring-boot:run`.
5. En la consola debe aparecer `Tomcat started on port 8080` y `>>> Datos de prueba cargados: 5 libros`.
6. Abran en el navegador `http://localhost:8080/api/libros`. Deben ver el JSON con 5 libros.

> La base de datos es **H2 en memoria**: no hay que instalar nada y se reinicia cada vez que se levanta la API. Si quieren MySQL, lean los comentarios de `application.properties`.

### Paso 3. Probar los endpoints antes de programar

7. Abran Postman y elijan **Import** (arriba a la izquierda). Seleccionen el archivo `backend/Biblioteca_API.postman_collection.json`. Aparecerá la colección **Biblioteca ITT - API** con las 6 peticiones listas; la variable `{{base}}` ya vale `http://localhost:8080`.
   *Si prefieren armarlas a mano:* elijan el método, escriban la URL completa y, en POST y PUT, vayan a **Body → raw → JSON** y peguen el JSON:
   ```
   PUT http://localhost:8080/api/libros/1
   Body (raw, JSON):
   { "titulo": "Cien años de soledad", "autor": "Gabriel García Márquez", "anio": 1967, "disponible": false }
   ```
8. Presionen **Send** en cada una de **las 6 peticiones** y anoten el código de estado de cada una. En particular, comprueben que:
   - `PUT /api/libros/1` responde **200** con el libro cambiado,
   - `DELETE /api/libros/2` responde **204** sin cuerpo,
   - repetir el mismo DELETE responde **404**.

> Diagnóstico rápido: si funciona en Postman y falla en Flutter, el problema está en la app (URL, permisos o CORS), no en la API.

### Paso 4. Preparar la app Flutter

9. En una **segunda terminal** (la API debe seguir corriendo):
   ```bash
   cd biblioteca_app
   flutter create . --platforms=web,android,windows
   flutter pub get
   ```
   `flutter create .` solo genera las carpetas de plataforma (android, web, windows); **no** sobrescribe `lib/` ni `pubspec.yaml`.
10. **Solo si usan emulador Android o celular:** abran `android/app/src/main/AndroidManifest.xml` y agreguen dentro de la etiqueta `<application ...>` el atributo:
    ```xml
    android:usesCleartextTraffic="true"
    ```
    y antes de `<application>` la línea:
    ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```
11. **Solo si usan celular físico:** en `lib/core/constants/api_config.dart` escriban la IP de su PC (`ipconfig`) en `ipCelularFisico`. La PC y el celular deben estar en la misma red wifi.

### Paso 5. Ejecutar y comprobar GET y POST

12. Ejecuten la app (recomendado en Chrome, es lo más rápido):
    ```bash
    flutter run -d chrome
    ```
13. El splash debe decir **Conexión OK** y en la consola debe aparecer `Conexion OK -> 200: Bienvenido a la API...`. **Si no aparece, no sigan**: revisen la tabla de Problemas frecuentes.
14. En Home deben ver los 5 libros (**GET**). Toquen **Nuevo (POST)**, registren un libro y comprueben que aparece en la lista.
15. Toquen el ícono ✏️ de un libro y presionen **Actualizar (PUT)**, o el ícono 🗑️. Debe aparecer el mensaje `TODO 3a...` o `TODO 3b...`: eso es lo que ustedes van a completar.

### Paso 6. TODO 1: el service (las rutas)

En `lib/services/libro_service.dart` completen `actualizar` y `eliminar`. Pistas:

16. La ruta lleva el id: `'${ApiConfig.libros}/$id'` (es el `@PathVariable` de Spring Boot).
17. **PUT:** `await dio.put(ruta, data: body)` y regresen `res.data as Map<String, dynamic>`.
18. **DELETE:** `await dio.delete(ruta)`. Spring Boot responde 204, así que no hay JSON que regresar.
19. Guíense con `getLibros()` y `crear()`, que están arriba en el mismo archivo.

### Paso 7. TODO 2: el repository (JSON → modelo)

En `lib/domain/repository/libro_repository.dart` completen `actualizar` y `eliminar`. Pistas:

20. **PUT:** llamen a `service.actualizar(libro.id!, libro.toJson())` y conviertan la respuesta con `Libro.fromJson(data)`.
21. **DELETE:** solo llamen a `service.eliminar(id)`.

### Paso 8. TODO 3: el controller (estado para la vista)

En `lib/presentation/controllers/libro_controller.dart` completen `actualizar` y `eliminar`. Pistas:

22. Copien la forma de `crear()`: dentro de un `try`, llamen al repository, después `await cargar()` para recargar la lista, y regresen `null` (éxito).
23. Atrapen `DioException` y regresen `_mensaje(e)`; para cualquier otro error regresen `'$e'`.
24. Borren las líneas `return 'TODO 3a...'` y `return 'TODO 3b...'`.

### Paso 9. Probar

25. Guarden y presionen `r` en la terminal de Flutter (hot reload) o `R` (hot restart).
26. Editen un libro: cambien el título y marquen **No disponible**. Al guardar, la lista debe mostrar el cambio.
27. Eliminen un libro y confirmen. Debe desaparecer de la lista y salir el mensaje **Libro eliminado**.
28. Abran `http://localhost:8080/api/libros` en el navegador y comprueben que la API también tiene los cambios.
29. Revisen la consola de Flutter: el `LogInterceptor` debe mostrar `PUT .../api/libros/1` con código 200 y `DELETE ...` con código 204.
30. Tomen capturas de: la lista antes, el formulario de edición, la lista después de editar y la lista después de eliminar.

---

## Reto opcional (puntos extra)

Agreguen una pantalla de **detalle** que consuma `GET /api/libros/{id}`:

- Service: `getLibro(int id)` con `dio.get('${ApiConfig.libros}/$id')`.
- Repository: `getLibro(int id)` que regrese `Libro.fromJson(...)`.
- Ruta nueva en `app_router.dart`: `/libro/:id`.
- En `libro_tile.dart`, agreguen `onTap: () => context.push('/libro/${libro.id}')`.
- Si la API responde 404, muestren **"El libro no existe"** en lugar de que la app se cierre.

## Entregable

- Las 4 capturas del paso 30 y una captura de la consola con las peticiones PUT y DELETE.
- Los archivos `libro_service.dart`, `libro_repository.dart` y `libro_controller.dart`.
- Se entregan al terminar la práctica por el medio que indique el equipo expositor.

## Evaluación

| Criterio | Puntos |
|---|---|
| La API corre y la app muestra **Conexión OK** | 10 |
| TODO 1: service con PUT y DELETE correctos | 25 |
| TODO 2: repository con PUT y DELETE correctos | 20 |
| TODO 3: controller con manejo de errores y recarga de la lista | 25 |
| Capturas de edición y eliminación funcionando | 20 |
| **Total** | **100** |
| Reto opcional: detalle con GET por id | +10 |

---

## Problemas frecuentes

| Problema | Qué revisar |
|---|---|
| `Sin conexión con la API (connectionError)` | Que la API esté corriendo (paso 5) y que la URL base sea la correcta para su plataforma: Chrome → `localhost`, emulador → `10.0.2.2`, celular → IP de la PC. |
| `Cleartext HTTP traffic not permitted` | Falta `android:usesCleartextTraffic="true"` en el `AndroidManifest.xml` (paso 10). |
| Error de **CORS** en la consola de Chrome | La API ya trae `CorsConfig`; revisen que no hayan modificado el backend y que la API esté arriba. |
| `Port 8080 was already in use` | Hay otra API abierta. Ciérrenla o detengan el proceso que usa el 8080. |
| El PUT responde **400** | Título o autor vacíos: la API los valida. |
| El PUT o DELETE responde **404** | El id no existe (recuerden que H2 se reinicia al levantar la API). Recarguen la lista. |
| `type 'Null' is not a subtype of type 'String'` | Una clave del `fromJson` no se llama igual que el atributo de Java. |
| Siguen saliendo los mensajes `TODO 3a/3b` | No borraron el `return 'TODO...'` del controller, o falta hacer hot restart (`R`). |
| `UnimplementedError: TODO 1a/1b/2a/2b` | Falta completar ese método en el service o en el repository. |
| VS Code no muestra el botón **Run** en Java | Instalen *Extension Pack for Java* y esperen a que termine de cargar el proyecto. |
| La app tarda mucho en compilar | Ejecuten en Chrome: es más rápido que el emulador. |
