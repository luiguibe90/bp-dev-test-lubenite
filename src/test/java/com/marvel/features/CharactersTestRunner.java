package com.marvel.features;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

class CharactersTestRunner {
    
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testObtenerTodosPersonajes() {
        return Karate.run("characters/obtenerTodosPersonajes").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testCrearPersonaje() {
        return Karate.run("characters/crearPersonaje").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testActualizarPersonaje() {
        return Karate.run("characters/actualizarPersonaje").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testEliminarPersonaje() {
        return Karate.run("characters/eliminarPersonaje").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testObtenerPersonajePorId() {
        return Karate.run("characters/obtenerPersonajePorId").relativeTo(getClass());
    }
}
