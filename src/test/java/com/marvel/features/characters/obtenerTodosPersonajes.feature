@REQ_MARVEL-001 @HU001 @get_all_characters @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: MARVEL-001 Obtener todos los personajes (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters_api
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-MARVEL-001-CA01-Obtener todos los personajes exitosamente 200 - karate
    Given path ''
    When method GET
    Then status 200
    # And match response != null
    # And match response == '#array'

  @id:2 @obtenerPersonajes @errorServicio500
  Scenario: T-API-MARVEL-001-CA02-Obtener personajes con error interno 500 - karate
    Given path ''
    When method GET
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
