@REQ_MARVEL-003 @HU003 @update_character @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: MARVEL-003 Actualizar personaje (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters_api
    * headers headers

  @id:1 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-MARVEL-003-CA01-Actualizar personaje exitosamente 200 - karate
    * def jsonData = read('classpath:data/characters/update_character.json')
    Given path '285'
    And request jsonData
    When method PUT
    Then status 200
    # And match response.name == jsonData.name
    # And match response.description == jsonData.description

  @id:2 @actualizarPersonaje @personajeNoEncontrado404
  Scenario: T-API-MARVEL-003-CA02-Actualizar personaje inexistente 404 - karate
    * def jsonData = read('classpath:data/characters/update_character.json')
    Given path '999'
    And request jsonData
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response.status == 404

  @id:3 @actualizarPersonaje @errorValidacion400
  Scenario: T-API-MARVEL-003-CA03-Actualizar personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/characters/invalid_character.json')
    Given path '285'
    And request jsonData
    When method PUT
    Then status 400
    # And match response contains { "name": "Name is required" }
    # And match response contains { "powers": "Powers are required" }

  @id:4 @actualizarPersonaje @errorServicio500
  Scenario: T-API-MARVEL-003-CA04-Actualizar personaje con error interno 500 - karate
    * def jsonData = read('classpath:data/characters/update_character.json')
    Given path '285'
    And request jsonData
    When method PUT
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
