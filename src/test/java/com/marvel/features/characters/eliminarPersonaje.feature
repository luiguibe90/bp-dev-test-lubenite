@REQ_MARVEL-004 @HU004 @delete_character @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: MARVEL-004 Eliminar personaje (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters_api
    * headers headers

  @id:1 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-MARVEL-004-CA01-Eliminar personaje exitosamente 204 - karate
    Given path '1'
    When method DELETE
    Then status 204
    # And match response == ''
    # And match responseHeaders contains { 'Content-Length': '0' }

  @id:2 @eliminarPersonaje @personajeNoEncontrado404
  Scenario: T-API-MARVEL-004-CA02-Eliminar personaje inexistente 404 - karate
    Given path '999'
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response.status == 404

  @id:3 @eliminarPersonaje @errorServicio500
  Scenario: T-API-MARVEL-004-CA03-Eliminar personaje con error interno 500 - karate
    Given path '1'
    When method DELETE
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
