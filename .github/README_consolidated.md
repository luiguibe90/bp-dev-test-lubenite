> **IMPORTANTE**: 
> 1. Todos los archivos `.feature` DEBEN crearse en la ruta `src/test/java/com/marvel/features/[nombre_microservicio]/`.
> 2. Todos los archivos de datos JSON DEBEN ubicarse en `src/test/resources/data/[nombre_microservicio]/`.

---

## Objetivo

Crear escenarios `.feature` con enfoque senior: estandarizado, limpio, escalable y mantenible.

### Fuentes de entrada y estrategias de generación

- **Si la entrada es una colección Postman:** Se usarán sus requests y ejemplos de respuesta para generar los JSON necesarios en `src/test/resources/data` y construir los escenarios para cada caso de uso.

> **Nota sobre archivos .feature:** El nombre del archivo `.feature` debe estar en formato camelCase y ser descriptivo de la funcionalidad que se está automatizando. Por ejemplo, `obtenerTodosPersonajes.feature`, `crearNuevoPersonaje.feature`, `eliminarPersonaje.feature`, `actualizarPersonaje.feature`. Asegúrate de que el nombre refleje claramente el propósito de las pruebas contenidas en el archivo.

## Plantilla estándar de Feature

```gherkin
@REQ_[HISTORIA-ID] @HU[ID-SIN-PREFIJO] @descripcion_historia @nombre_microservicio @Agente2 @E2 @iniciativa_descripcion
Feature: [HISTORIA-ID] Nombre de la funcionalidad (microservicio para...)
  Background:
    * url port_nombre_microservicio
    * path '/ruta/a/endpoint'
    * def generarHeaders =
      """
      function() {
        return {
          "X-Guid": "88212f38-cc02-4083-a763-8cc09a933840",
          "X-Flow": "onboard",
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers    @id:1 @tag_descriptivo @resultado_esperado
  Scenario: T-API-[HISTORIA-ID]-CA01-Descripción acción resultado código - karate
    * def jsonData = read('classpath:data/microservicio/datos_request.json')
    And request jsonData
    When method POST
    Then status 200
    # And match response != null
    # And match response.data != null

    Examples:
      | read('classpath:data/microservicio/datos_ejemplo.json') |
```

> **Importante:** Todos los features DEBEN incluir los siguientes tags en la primera línea:
> - `@REQ_[HISTORIA-ID]`: Número de la historia de usuario (ej: @REQ_BTPMCDP-118)
> - `@HU[ID-SIN-PREFIJO]`: ID de la historia de usuario sin prefijo (ej: @HU118)
> - `@descripcion_historia`: Descripción breve de la historia de usuario en snake_case (ej: @account_creation_savings)
> - `@nombre_microservicio`: Nombre del microservicio con guion bajo (ej: @tre_msa_savings_account). Si el nombre original contiene guiones, debe convertirse a guiones bajos.
> - `@Agente2 @E2`: Tags fijos que deben ir siempre
> - `@iniciativa_descripcion`: Descripción corta de la iniciativa en snake_case (ej: @iniciativa_cuentas)
>
> Donde `[HISTORIA-ID]` debe ser reemplazado con el ID real de la historia de usuario que estás automatizando (ej: BTPMCDP-118).

---


## JSON de ejemplo (`src/test/resources/data/usuarios/usuarios_validos.json`)

```json
[
  {
    "nombre": "Marco Clavijo",
    "email": "marco@test.com",
    "rol": "admin"
  },
  {
    "nombre": "Erick Torres",
    "email": "etorres@test.com",
    "rol": "usuario"
  }
]
```


## Buenas prácticas de código limpio

- Reutiliza `Background` para `baseUrl`, autenticación y headers comunes.
- Divide escenarios por criterio de aceptación (no más de uno por escenario).
- Centraliza y reutiliza datos de prueba en `src/test/resources/data/...`.
- No hardcodees valores repetitivos (usar `karate-config.js` o archivos JSON).
- Usa `Scenario Outline` cuando haya múltiples combinaciones de datos.
- Agrupa features por proyecto en `src/test/java/com/pichincha/features`.
- **Cada feature debe tener los tags obligatorios**: `@REQ_[HISTORIA-ID] @funcionalidad @nombre_microservicio @Agente2 @E2`
- **Los escenarios deben tener el formato**: `T-API-[HISTORIA-ID]-CAXX-Descripción acción resultado código - karate`
- **Cada feature debe incluir por defecto al menos estos escenarios**:
  - Escenario para errores de validación (HTTP status 400)
  - Escenario para errores internos del servidor (HTTP status 500)
- **Solicita siempre el ID de la historia de usuario** antes de comenzar a crear un feature, para poder incluirlo correctamente en todos los lugares necesarios.
- **Gestión de variables de entorno**:
  - Las URL de los microservicios DEBEN definirse en `karate-config.js` con el formato `port_nombre_microservicio`
  - Nunca usar URLs hardcodeadas en los features, siempre usar las variables definidas en `karate-config.js`
  - Al empezar un nuevo proyecto, verificar si el microservicio ya está definido en `karate-config.js` y añadirlo si no lo está
  - Usar siempre snake_case (guiones bajos) para los nombres de microservicios, independientemente de su nombre original

---

# . Validaciones estándar recomendadas

| Tipo de validación | Ejemplo                                           |
|--------------------|---------------------------------------------------|
| Status             | `Then status 201`                                 |
| Campo presente     | `# And match response.id != null`                 |
| Error específico   | `Then status 409`<br>`# And match response.message == 'Ya existe'` |
| Esquema JSON       | `# And match response == karate.read('schema.json')`|
| Múltiples validaciones | `# And match response.status == 200`<br>`# And match response.data != null` |

> **Importante:** Todas las validaciones de tipo `match` deben estar comentadas en la plantilla inicial como sugerencias. Para cada escenario, se deben incluir exactamente 2 matchers comentados que sean específicos para ese caso. El desarrollador debe descomentarlas según sus necesidades específicas y puede añadir validaciones adicionales si lo requiere.

---

**IMPORTANTE sobre las variables de microservicios:**
> 
> 1. **Convención de nombres:** Todas las variables de URL de microservicios deben seguir el formato `port_nombre_microservicio` donde:
>    - El prefijo `port_` es obligatorio para todos los microservicios
>    - `nombre_microservicio` debe estar en snake_case (usar guiones bajos en lugar de guiones)

---

## . Formato estándar para escenarios

### Ejemplo completo basado en la Historia de Usuario BTPMCDP-118

> **Nota:** BTPMCDP-118 es un ejemplo de ID de historia de usuario. Siempre solicita al usuario el ID real de la historia que se está automatizando.

```gherkin
@REQ_BTPMCDP-118 @HU118 @account_creation_savings @tre_msa_savings_account @Agente2 @E2 @iniciativa_cuentas
Feature: BTPMCDP-118 Crear cuenta exitosamente (microservicio transversal para crear cuentas)
  Background:
    * url port_tre_msa_savings_account
    * path '/api/v1/retail/savings-account/SavingsAccount/Initiate'
    * def generarHeaders =
      """
      function() {
        return {
          "X-Guid": "88212f38-cc02-4083-a763-8cc09a933840",
          "X-Flow": "onboard",
          "X-Process": "transaccional",
          "x-request-id": "db8172fc-01e1-47e4-beaf-6791db628363",
          "x-session": "0163e87a-699b-4ff9-8116-91193b583def",
          "x-agency": "223",
          "x-channel": "02",
          "X-Application": "02",
          "X-Medium": "020200",
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers
  @id:1 @crearCuentaKyc @solicitudExitosa200
  Scenario: T-API-BTPMCDP-118-CA01-Crear cuenta exitosamente 201 - karate
    * def jsonData = read('classpath:data/tre_msa_savings_account/request_creation_account.json')
    * def result = call read('classpath:com/pichincha/features/utility/generar_compliance_id.feature@generar_compliance_id')
    * set jsonData.savingsAccountFacility.customerReference.complianceId = result.response.regulatoryComplianceId    
    And request jsonData
    When method POST
    Then status 200
    # And match response != null
    # And match response.accountId != null
  @id:2 @crearCuentaKyc @errorValidacion400
  Scenario: T-API-BTPMCDP-118-CA02-Crear cuenta con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/tre_msa_savings_account/request_creation_account.json')
    * set jsonData.savingsAccountFacility.customerReference.customerId = null    
    And request jsonData
    When method POST
    Then status 400
    # And match response.message contains 'Error de validación'
    # And match response.status == 400
  @id:3 @crearCuentaKyc @errorServicio500
  Scenario: T-API-BTPMCDP-118-CA03-Crear cuenta con error interno 500 - karate
    * def jsonData = read('classpath:data/tre_msa_savings_account/request_creation_account.json')
    * set jsonData.savingsAccountFacility.customerReference.customerId = '9999999999'
    And request jsonData
    When method POST
    Then status 400
    # And match response.status == 400
    # And match response.message contains 'Error interno del servidor'
```

> **Nota:** Siempre considera añadir más escenarios para cubrir casos adicionales como validaciones de campos, límites de caracteres y casos de seguridad.

### Elementos obligatorios a considerar:

1. **Primera línea con tags obligatorios**:
   ```
   @REQ_[HISTORIA-ID] @HU[ID-SIN-PREFIJO] @descripcion_historia @nombre_microservicio @Agente2 @E2 @iniciativa_descripcion
   ```
   _Donde [HISTORIA-ID] debe ser reemplazado con el ID real de la historia de usuario (ej: BTPMCDP-118)_

   **Ejemplo real**: 
   ```
   @REQ_BTPMCDP-416 @HU416 @account_detail_hash_mask_account @onb_msa_bs_rt_account_detail @Agente2 @E2 @iniciativa_detalle_cuenta
   ```

   **Explicación de cada tag**:
   - `@REQ_BTPMCDP-416`: ID completo de la historia de usuario con su prefijo
   - `@HU416`: ID numérico de la historia sin prefijo
   - `@account_detail_hash_mask_account`: Descripción funcional de la historia en snake_case
   - `@onb_msa_bs_rt_account_detail`: Nombre del microservicio en snake_case
   - `@Agente2 @E2`: Tags fijos obligatorios
   - `@iniciativa_detalle_cuenta`: Descripción corta de la iniciativa relacionada

2. **Formato del Feature**:
   ```
   Feature: [HISTORIA-ID] Nombre descriptivo (microservicio para...)
   ```
   _Incluye el ID de la historia al inicio del título del Feature_

3. **Formato de escenarios**:
   ```
   Scenario: T-API-[HISTORIA-ID]-CAXX-Descripción acción resultado código - karate
   ```
   _Donde XX es el número secuencial del caso de aceptación_

   **Nota sobre escenarios obligatorios**: Por defecto, todo feature debe incluir al menos estos escenarios:
   - Escenario exitoso (status 200/201)
   - Escenario de error de validación (status 400)
   - Escenario de error interno del servidor (status 500)

4. **Tags de escenario**:
   ```
   @id:X @funcionalidad @resultadoEsperado
   ```
   _X debe ser un número secuencial_

5. **Rutas de archivos JSON**:
   ```
   classpath:data/nombre_microservicio/archivo.json
   ```
   _Siempre usa la ruta completa desde la raíz classpath. Los archivos JSON deben estar ubicados en `src/test/resources/data/nombre_microservicio/`_

---
## . karate-config.js base (`src/test/java/karate-config.js`)

```javascript
function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_tre_msa_savings_account = 'http://localhost:8081/tre-msa-savings-account';
  config.port_onb_msa_bs_rt_account_detail = 'http://localhost:8082/onb-msa-bs-rt-account-detail';
  config.port_cdp_msa_bs_scheduled_savings_account = 'http://localhost:8083/cdp-msa-bs-scheduled-savings-account';
  config.port_tre_msa_brms = 'http://localhost:8084/tre-msa-brms';
  // Agrega todos los microservicios que utiliza tu proyecto
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'https://api-dev.empresa.com';
    config.port_tre_msa_savings_account = 'https://api-dev.empresa.com/tre-msa-savings-account';
    config.port_onb_msa_bs_rt_account_detail = 'https://api-dev.empresa.com/onb-msa-bs-rt-account-detail';
    config.port_cdp_msa_bs_scheduled_savings_account = 'https://api-dev.empresa.com/cdp-msa-bs-scheduled-savings-account';
    config.port_tre_msa_brms = 'https://api-dev.empresa.com/tre-msa-brms';
    // Actualiza las URLs para cada microservicio en este entorno
  } 
  else if (env == 'qa') {
    config.baseUrl = 'https://api-qa.empresa.com';
    config.port_tre_msa_savings_account = 'https://api-qa.empresa.com/tre-msa-savings-account';
    config.port_onb_msa_bs_rt_account_detail = 'https://api-qa.empresa.com/onb-msa-bs-rt-account-detail';
    config.port_cdp_msa_bs_scheduled_savings_account = 'https://api-qa.empresa.com/cdp-msa-bs-scheduled-savings-account';
    config.port_tre_msa_brms = 'https://api-qa.empresa.com/tre-msa-brms';
    // Actualiza las URLs para cada microservicio en este entorno
  }
  
  return config;
}
```
# 📘 Consolidated README

## 🦸‍♂️ Main Documentation

# Marvel Characters API

API REST para gestión de personajes de Marvel, desarrollada en Java 17 + Spring Boot + Gradle.

## Despliegue de prueba

Ambiente de test: [http://bp-se-test-cabcd9b246a5.herokuapp.com](http://bp-se-test-cabcd9b246a5.herokuapp.com)

## Uso de la API

Todas las rutas requieren el parámetro de usuario (`{username}`) en el path:

```
http://bp-se-test-cabcd9b246a5.herokuapp.com/{username}/api/characters
```

Ejemplo usando el usuario `testuser`:

```
http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters
```

### Endpoints principales

#### Obtener todos los personajes
- **GET** `/ {username} /api/characters`

#### Obtener personaje por ID
- **GET** `/ {username} /api/characters/{id}`

#### Crear personaje
- **POST** `/ {username} /api/characters`
  - Body (JSON):
    ```json
    {
      "name": "Spider-Man",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    ```

#### Actualizar personaje
- **PUT** `/ {username} /api/characters/{id}`
  - Body igual al POST

#### Eliminar personaje
- **DELETE** `/ {username} /api/characters/{id}`

### Ejemplo con curl
```sh
curl -X POST \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Genio, millonario, playboy, filántropo",
    "powers": ["Armadura", "Inteligencia"]
  }'
```

### Colección Postman
Incluida en el repo: `MarvelCharactersAPI.postman_collection.json`

---

## Levantar el proyecto localmente

1. **Requisitos previos:**
   - Java 17 instalado
   - Gradle (o usar el wrapper incluido: `./gradlew`)

2. **Clona el repositorio:**
   ```sh
   git clone https://github.com/dg-juacasti/bp-dev-test
   cd bp-dev-test
   ```

3. **Construye el proyecto:**
   ```sh
   ./gradlew build o gradlew build
   ```

4. **Ejecuta la aplicación:**
   ```sh
   ./gradlew bootRun o gradlew bootRun
   ```
   o bien:
   ```sh
   java -jar app/build/libs/app-0.0.1-SNAPSHOT.jar
   ```

5. **La API estará disponible en:**
   - `http://localhost:8080/{username}/api/characters`

---

**Notas:**
- Cada usuario ({username}) tiene su propio espacio de personajes.


---

## 🧪 Additional Information

# Proyecto base de pruebas automatizadas con Karate, Java y Gradle

Este proyecto es una base para implementar pruebas automatizadas de la colección de peticiones entregadas (por ejemplo, una colección Postman). Todas las pruebas deben ser escritas en el archivo `src/test/resources/karate-test.feature` siguiendo la sintaxis de Karate DSL.

## Instrucciones de uso

### 1. Descarga del proyecto

Clona este repositorio en tu máquina local:

```sh
git clone https://github.com/dg-juacasti/test-automatisation-base
cd test-automatisation-base
```

### 2. Escribe tus pruebas

- Implementa los escenarios de prueba en el archivo:
  - `src/test/resources/karate-test.feature`
- Usa la sintaxis de Karate para definir los escenarios y validaciones.

### 3. Ejecuta las pruebas

Asegúrate de tener Java 17, 18 o 21 instalado y activo. Luego ejecuta:

```sh
./gradlew test o gradlew test
```

Esto compilará el proyecto y ejecutará todas las pruebas automatizadas.

---

- Si tienes problemas de SSL, puedes agregar la línea `* configure ssl = true` en el `Background` de tu archivo `.feature`.
- Los reportes de ejecución se generarán en la carpeta `karate-reports/`.


---

## 🧰 cURL Examples

# Ejemplos de uso de la Marvel Characters API (cURL)

> Dominio de test: http://bp-se-test-cabcd9b246a5.herokuapp.com
> Usuario de ejemplo: testuser

---

## Obtener todos los personajes
```sh
curl -X GET \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters
```

## Obtener personaje por ID
```sh
curl -X GET \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/1
```

## Crear personaje (válido)
```sh
curl -X POST \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Spider-Man",
    "alterego": "Peter Parker",
    "description": "Superhéroe arácnido de Marvel",
    "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
  }'
```

## Crear personaje (nombre duplicado, error 400)
```sh
curl -X POST \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Spider-Man",
    "alterego": "Peter Parker",
    "description": "Otro intento duplicado",
    "powers": ["Agilidad"]
  }'
```

## Crear personaje (datos inválidos, error 400)
```sh
curl -X POST \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "",
    "alterego": "",
    "description": "",
    "powers": []
  }'
```

## Obtener personaje inexistente (error 404)
```sh
curl -X GET \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999
```

## Actualizar personaje (válido)
```sh
curl -X PUT \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/1 \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Spider-Man",
    "alterego": "Peter Parker",
    "description": "Superhéroe arácnido de Marvel (actualizado)",
    "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
  }'
```

## Actualizar personaje inexistente (error 404)
```sh
curl -X PUT \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999 \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "No existe",
    "alterego": "Nadie",
    "description": "No existe",
    "powers": ["Nada"]
  }'
```

## Eliminar personaje (válido)
```sh
curl -X DELETE \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/1
```

## Eliminar personaje inexistente (error 404)
```sh
curl -X DELETE \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/9999
```

