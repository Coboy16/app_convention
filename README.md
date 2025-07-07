# Documentación Técnica Avanzada: App de Convenciones "Konecta"

## 1. Visión General y Filosofía del Proyecto

"Konecta" es una plataforma móvil de eventos construida con Flutter, diseñada para ser **escalable, mantenible y robusta**. La filosofía central del desarrollo se basó en la aplicación rigurosa de principios de software de alta calidad, como **Clean Architecture** y la **separación de responsabilidades (SoC)**, para crear una base de código que no solo cumple con los requisitos funcionales, sino que también está preparada para el crecimiento futuro y la fácil incorporación de nuevos desarrolladores.

**Puntos Clave para Reclutadores:**

- **Arquitectura Orientada a la Escalabilidad:** La elección de Clean Architecture no es accidental. Permite que la lógica de negocio (`Domain`) sea completamente independiente de la UI (`Presentation`) y de las fuentes de datos (`Data`), facilitando las pruebas unitarias, la reutilización de código y la capacidad de cambiar tecnologías (ej. migrar de Firebase a otro backend) con un impacto mínimo.
- **Gestión de Estado Predecible:** Se utiliza el patrón **BLoC** para un flujo de datos unidireccional y predecible. Esto elimina los problemas de estado inconsistente y hace que la depuración sea significativamente más sencilla.
- **Código Desacoplado:** Mediante el uso de **GetIt** como localizador de servicios, se evita el acoplamiento fuerte entre clases. Esto es crucial para las pruebas, ya que permite inyectar dependencias y mocks con facilidad.

---

## 2. Arquitectura Detallada: Clean Architecture en la Práctica

La estructura del proyecto se organiza por _features_ (ej. `auth`, `profile`, `posts`), y cada feature implementa las tres capas de Clean Architecture.

### a. Capa de Dominio (El Cerebro de la Aplicación)

Esta es la capa más importante y está libre de cualquier dependencia externa (sin `flutter`, sin `firebase`).

- **Entities (`/domain/entities`):**

  - Son modelos de negocio puros. Por ejemplo, `PostEntity` define qué es un "Post" para la aplicación, sin preocuparse de cómo se almacena en Firestore.
  - **Decisión de Diseño:** Se utiliza `Equatable` para simplificar las comparaciones de objetos, lo cual es vital para que BLoC detecte cambios de estado de manera eficiente.

- **Repositories (Contratos - `/domain/repositories`):**

  - Definen interfaces abstractas que establecen un "contrato" sobre las operaciones de datos. Por ejemplo, `PostRepository` define `Future<Either<Failure, List<PostEntity>>> getFeedPosts()`.
  - **Decisión de Diseño:** El uso de `Either<Failure, Success>` del paquete `dartz` es una práctica de programación funcional que permite un manejo de errores explícito y robusto, eliminando la necesidad de bloques `try-catch` en la capa de presentación y forzando al desarrollador a manejar tanto el caso de éxito como el de fallo.

- **Use Cases (Lógica de Negocio - `/domain/usecases`):**
  - Cada caso de uso representa una única acción del sistema (ej. `CreatePostUseCase`). Esto sigue el **Principio de Responsabilidad Única (SRP)**.
  - **Decisión de Diseño:** Encapsular la lógica en casos de uso hace que el `BLoC` sea más limpio y legible. El BLoC solo orquesta la llamada al caso de uso, sin contener lógica de negocio compleja.

### b. Capa de Datos (El Puente con el Mundo Exterior)

Esta capa implementa los contratos del dominio y se encarga de la comunicación con Firebase.

- **Models (`/data/models`):**

  - Extienden las `Entities` del dominio y añaden la lógica de serialización/deserialización (ej. `fromFirestore`, `toMap`). Esto mantiene la lógica de conversión de datos aislada en esta capa.
  - **Decisión de Diseño:** Separar `Model` de `Entity` es crucial. Si el esquema de Firestore cambia, solo se modifica el `Model` en la capa de datos, y la capa de dominio y presentación permanecen intactas.

- **DataSources (`/data/datasources`):**

  - Son las únicas clases que tienen conocimiento directo de Firebase (`cloud_firestore`, `firebase_storage`). Realizan las operaciones CRUD.
  - **Decisión de Diseño:** Si se produce un error en una llamada a Firebase, el `DataSource` lanza una `ServerException` específica. Esto permite que el `Repository` la capture y la transforme en un `ServerFailure` del dominio.

- **Repositories (Implementaciones - `/data/repositories`):**
  - Implementan las interfaces del dominio. Su rol principal es coordinar los `DataSources` y gestionar la lógica de conectividad.
  - **Decisión de Diseño:** Antes de cada llamada a la red, se utiliza `InternetConnectionChecker` para verificar la conexión. Si no hay conexión, se devuelve un `ConnectionFailure` sin intentar la llamada, mejorando la experiencia del usuario y ahorrando recursos.

### c. Capa de Presentación (La Cara Visible)

Esta capa se encarga de mostrar la UI y manejar las interacciones del usuario.

- **BLoCs (`/presentation/bloc`):**

  - Son el intermediario entre la UI y el dominio. No contienen lógica de negocio; su única responsabilidad es recibir eventos, llamar a los `Use Cases` y emitir nuevos estados.
  - **Decisión de Diseño:** Para interacciones como dar "like", el BLoC implementa una **actualización optimista**. Primero, emite un nuevo estado con el cambio aplicado en la UI localmente para una respuesta instantánea. Luego, en segundo plano, llama al caso de uso para persistir el cambio en el backend. Esto proporciona una experiencia de usuario fluida y rápida.

- **Screens y Widgets (`/presentation/screens` y `/presentation/widgets`):**
  - Son "tontos" en el sentido de que no contienen lógica. Su única función es renderizar el estado actual proporcionado por el BLoC y enviar eventos al BLoC en respuesta a las interacciones del usuario.
  - **Decisión de Diseño:** Se utilizan `BlocBuilder` para reconstruir la UI y `BlocListener` para acciones que no reconstruyen la UI (como mostrar un `SnackBar` o navegar). Para manejar ambos, se usa `BlocConsumer`. Esto optimiza el rendimiento al evitar reconstrucciones innecesarias.
  - **UI de Esqueleto (Skeleton UI):** Cuando se cargan datos (ej. el feed de posts), en lugar de mostrar un simple `CircularProgressIndicator`, se renderiza un `PostItemSkeleton`. Esto mejora la **Percepción de Rendimiento** por parte del usuario, ya que la estructura de la página es visible de inmediato.

---

## 3. Puntos Técnicos Destacados

### a. Manejo de Dependencias y Estructura Modular

El proyecto está organizado por _features_, lo que lo hace altamente modular. El archivo `service_locator.dart` está estructurado con funciones de inicialización por feature (`_initAuth`, `_initProfile`, `_initPosts`), demostrando una gestión de dependencias organizada que escala bien en equipos grandes y proyectos complejos.

```dart
// lib/shared/services/service_locator.dart

// ...
Future<void> initializeDependencies() async {
  // ... registro de dependencias externas ...

  // INICIALIZACIÓN POR FEATURE CON ORDEN LÓGICO
  // Se asegura que las dependencias se registren antes de ser requeridas.
  _initAuth();
  _initPosts();   // Se inicializa ANTES que Profile porque PostsBloc (en Profile) depende de sus use cases.
  _initProfile();
}
// ...
```

### b. Gestión de Errores Robusta y Explícita

El uso de `Either` en toda la aplicación, desde el `Repository` hasta el `BLoC`, asegura que los errores nunca pasen desapercibidos.

```dart
// Ejemplo en un BLoC
final result = await getFeedPostsUseCase();

result.fold(
  (failure) => emit(FeedError(message: failure.message)), // Caso de error manejado explícitamente
  (posts) => emit(FeedLoaded(posts: posts)), // Caso de éxito
);
```

### c. Optimización de la Experiencia de Usuario (UX)

- **Actualizaciones Optimistas:** Al dar "like", la UI se actualiza instantáneamente, sin esperar la confirmación del servidor.
- **Manejo de Conectividad:** La app verifica la conexión antes de realizar llamadas a la red, mostrando mensajes de error claros al usuario.
- **Skeleton UI:** Se muestran esqueletos de la UI mientras se cargan los datos, mejorando la percepción de velocidad.

### d. Modelo de Datos Eficiente en Firestore

El modelo de datos está diseñado para ser eficiente y escalable:

- **Subcolecciones:** Los comentarios se almacenan en una subcolección dentro de cada post, lo que permite cargar un post sin necesidad de cargar todos sus comentarios, optimizando las lecturas.
- **Contadores Denormalizados:** Se mantiene un campo `commentsCount` en el documento del post. Este se actualiza mediante una **transacción de Firestore** cada vez que se añade o elimina un comentario, evitando la necesidad de contar todos los documentos de la subcolección en el cliente.
- **Arrays para Likes y Vistas:** Los `likes` en los posts y las `viewedBy` en las historias se gestionan con `FieldValue.arrayUnion`, una operación atómica y eficiente de Firestore.

---

## 4. Conclusión

"Konecta" no es solo una aplicación funcional, sino una demostración de cómo construir software móvil de alta calidad utilizando las mejores prácticas de la industria. La arquitectura limpia, la gestión de estado predecible y las decisiones de diseño enfocadas en la experiencia del usuario y la escalabilidad hacen de este proyecto una base sólida y profesional, lista para ser llevada a producción y evolucionar con nuevas funcionalidades.
