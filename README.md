# Ejercicio Corredores de TC

[![build](https://github.com/pdep-utn/haskell-tc-autos/actions/workflows/build.yml/badge.svg)](https://github.com/pdep-utn/haskell-tc-autos/actions/workflows/build.yml)

## Instalación del entorno

Para instalar y ejecutar este ejemplo sigan [estas instrucciones](https://github.com/pdep-utn/enunciados-miercoles-noche/blob/master/pages/haskell/entorno.md)

## Objetivo

Dada la siguiente información de las carreras de TC disputadas en el año...

```haskell
type Corredor = String
type Puntos = Number    -- o Float si no estás usando el pdepreludat
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

```haskell
tablaDePosiciones carreras
[("Urcera",86.0),("Ardusso",83.5),("Werner",77.5),("Aguirre",47.0),("Rossi",47.0),("Benvenuti",45.0),("Mangoni",45.0),("Ortelli",42.0),("De Benedictis",42.0),("Ponce de Le\243n",42.0),("Mazzacane",39.0),("Ledesma",38.5)]
```

## Instrucciones para descargarse el ejemplo

Una vez clonado el repo, se paran en la carpeta raíz y ejecutan los siguientes comandos en Git Bash / terminal de Linux:

```bash
stack build
stack ghci
```

Allí podrán pedir la tabla de posiciones de los corredores de la siguiente manera:

```hs
tablaDePosiciones carreras
```

También pueden ejecutar los tests unitarios, una vez ejecutados los dos comandos `stack build`:

```bash
stack test
```

## Diapositivas para explicar el ejercicio

Pueden ver [aquí](https://docs.google.com/presentation/d/1M1D-v42JwRWg7VjuZ2D0r10lhQ88aX6QhUJ0eBVxHBs/edit#slide=id.g77eff50ac3_0_156) la explicación didáctica que guía el ejemplo.
