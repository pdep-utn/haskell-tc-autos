# Ejercicio Corredores de TC

[![Build Status](https://travis-ci.org/pdep-utn/haskell-tc-autos.svg?branch=master)](https://travis-ci.org/pdep-utn/haskell-tc-autos)

## Objetivo

Dada la siguiente información de las carreras de TC disputadas en el año...

```haskell
type Corredor = String
type Puntos = Float
type Posicion = (Corredor, Puntos)

data Carrera = Carrera {
    lugar :: String,
    fecha :: (Int, Int),
    posiciones :: [Posicion]
}

viedma = Carrera "Viedma" (10, 2) [ ("Ardusso", 45), ("Ortelli", 42), ("Werner", 39) ]
neuquen = Carrera "Neuquén" (3, 3) [ ("Aguirre", 47), ("Urcera", 42), ("Werner", 38.5)]
concepcionUruguay = Carrera "Concepción del Uruguay" (31, 3) [ ("Benvenuti", 45), ("De Benedictis", 42), ("Ardusso", 38.5)]
sanLuis = Carrera "San Luis" (14, 4) [ ("Mangoni", 45), ("Urcera", 44), ("Mazzacane", 39)]
rosario = Carrera "Rosario" (5, 5) [ ("Rossi", 47), ("Ponce de León", 42), ("Ledesma", 38.5) ]

corredores :: [Corredor]
corredores = [
    "Ardusso",
    "Ortelli",
    ... ]

carreras :: [Carrera]
carreras = [
    viedma,
    neuquen,
    concepcionUruguay,
    sanLuis,
    rosario
    ]
```

... se pide que arme la tabla de posiciones indicando

- corredor y puntos obtenidos
- ordenándolo de mayor a menor

