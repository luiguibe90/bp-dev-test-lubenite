@REQ_MARVEL-002 @HU002 @create_character @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: MARVEL-002 Crear personaje (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters_api
    * headers headers

  @id:1 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-MARVEL-002-CA01-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/characters/create_character.json')
    Given path ''
    And request jsonData
    When method POST
    Then status 201
    # And match response.id != null
    # And match response.name == jsonData.name

  @id:2 @crearPersonaje @errorNombreDuplicado400
  Scenario: T-API-MARVEL-002-CA02-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/characters/duplicate_name_character.json')
    Given path ''
    And request jsonData
    When method POST
    Then status 400
    # And match response.error == 'Character name already exists'
    # And match response.status == 400

  @id:3 @crearPersonaje @errorValidacion400
  Scenario: T-API-MARVEL-002-CA03-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/characters/invalid_character.json')
    Given path ''
    And request jsonData
    When method POST
    Then status 400
    # And match response.name == 'Name is required'
    # And match response contains { "alterego": "Alterego is required" }

  @id:4 @crearPersonaje @errorServicio500
  Scenario: T-API-MARVEL-002-CA04-Crear personaje con error interno 500 - karate
    * def jsonData = read('classpath:data/characters/create_character.json')
    Given path ''
    And request jsonData
    When method POST
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
