@REQ_MARVEL-005 @HU005 @get_character_by_id @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: MARVEL-005 Obtener personaje por ID (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters_api
    * headers headers

  @id:1 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-MARVEL-005-CA01-Obtener personaje por ID exitosamente 200 - karate
    Given path '1'
    When method GET
    Then status 200
    # And match response.id == 1
    # And match response contains { name: '#string', alterego: '#string', description: '#string', powers: '#array' }

  @id:2 @obtenerPersonajePorId @personajeNoEncontrado404
  Scenario: T-API-MARVEL-005-CA02-Obtener personaje por ID inexistente 404 - karate
    Given path '999'
    When method GET
    Then status 404
    # And match response.error == 'Character not found'
    # And match response.status == 404

  @id:3 @obtenerPersonajePorId @errorServicio500
  Scenario: T-API-MARVEL-005-CA03-Obtener personaje por ID con error interno 500 - karate
    Given path '1'
    When method GET
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
