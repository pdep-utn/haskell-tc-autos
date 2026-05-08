# Ejercicio Corredores de TC

[![build](https://github.com/pdep-utn/haskell-tc-autos/actions/workflows/build.yml/badge.svg)](https://github.com/pdep-utn/haskell-tc-autos/actions/workflows/build.yml)

## El problema

Dada la siguiente información de las carreras de TC disputadas en el año:

```haskell
type Corredor = String
type Puntos = Number
type Posicion = (Corredor, Puntos)

data Carrera = Carrera {
    lugar     :: String,
    fecha     :: (Number, Number),
    posiciones :: [Posicion]
}

viedma            = Carrera "Viedma"                  (10, 2) [ ("Ardusso", 45), ("Ortelli", 42), ("Werner", 39) ]
neuquen           = Carrera "Neuquén"                  (3, 3) [ ("Aguirre", 47), ("Urcera", 42), ("Werner", 38.5)]
concepcionUruguay = Carrera "Concepción del Uruguay"  (31, 3) [ ("Benvenuti", 45), ("De Benedictis", 42), ("Ardusso", 38.5)]
sanLuis           = Carrera "San Luis"                (14, 4) [ ("Mangoni", 45), ("Urcera", 44), ("Mazzacane", 39)]
rosario           = Carrera "Rosario"                  (5, 5) [ ("Rossi", 47), ("Ponce de León", 42), ("Ledesma", 38.5) ]

corredores :: [Corredor]
corredores = ["Ardusso", "Ortelli", "Werner", "Benvenuti", "Aguirre",
              "Urcera", "De Benedictis", "Mangoni", "Mazzacane",
              "Rossi", "Ponce de León", "Ledesma"]

carreras :: [Carrera]
carreras = [viedma, neuquen, concepcionUruguay, sanLuis, rosario]
```

...se pide armar la tabla de posiciones indicando corredor y puntos obtenidos, ordenada de mayor a menor:

```haskell
tablaDePosiciones carreras corredores
-- [("Urcera",86.0),("Ardusso",83.5),("Werner",77.5),("Aguirre",47.0),("Rossi",47.0),
--  ("Benvenuti",45.0),("Mangoni",45.0),("Ortelli",42.0),("De Benedictis",42.0),
--  ("Ponce de León",42.0),("Mazzacane",39.0),("Ledesma",38.5)]
```

## Resolución guiada

La solución se descompone top-down en tres responsabilidades:

```haskell
tablaDePosiciones :: [Carrera] -> [Corredor] -> [Posicion]
tablaDePosiciones carreras = sortCorredores . map (\corredor -> (corredor, puntosObtenidos corredor carreras))
```

1. Para cada corredor de la lista, calcular sus puntos totales (`puntosObtenidos`).
2. Ordenar esa lista de posiciones de mayor a menor (`sortCorredores`).

A su vez, `puntosObtenidos` delega en `puntosDeCorredor` para saber qué puntos obtuvo un corredor en una carrera individual.

Cada uno de esos tres pasos tiene varias implementaciones posibles. A continuación se explican con sus alternativas.

## Alternativas de diseño

### 1. Sumar los puntos de un corredor en el campeonato

`puntosObtenidos` recibe un corredor y la lista de carreras y devuelve la suma de sus puntos en todas ellas.

**Alternativa vigente — `foldr`**

```haskell
puntosObtenidos :: Corredor -> [Carrera] -> Puntos
puntosObtenidos corredor = foldr ((+) . puntosDeCorredor corredor) 0
```

`foldr` recorre la lista de derecha a izquierda acumulando la suma. La expresión `(+) . puntosDeCorredor corredor` es una función que, dada una carrera, suma sus puntos al acumulador. Es la forma más compacta de escribirlo.

**Alternativa con `foldl`**

```haskell
-- forma explícita
puntosObtenidos corredor = foldl (\acum carrera -> acum + puntosDeCorredor corredor carrera) 0

-- forma point-free
puntosObtenidos corredor = foldl (flip ((+) . puntosDeCorredor corredor)) 0
```

`foldl` recorre de izquierda a derecha. Para listas finitas el resultado es el mismo; la elección entre `foldr` y `foldl` suele ser una cuestión de legibilidad. La forma explícita con lambda es la más fácil de leer para quien no está acostumbrado a la notación point-free.

**Alternativa con `sumOf`**

```haskell
puntosObtenidos corredor = sumOf (puntosDeCorredor corredor)
```

`sumOf` (disponible en PdePreludat) aplica una función a cada elemento de una lista y suma los resultados. Es la alternativa más declarativa de las tres: dice exactamente qué hace sin mencionar el mecanismo de acumulación.

---

### 2. Encontrar los puntos de un corredor en una carrera

`puntosDeCorredor` busca al corredor en la lista de posiciones de una carrera y devuelve sus puntos, o 0 si no participó.

**Alternativa 1 — `filter` + pattern matching de lista**

```haskell
puntosDeCorredor :: Corredor -> Carrera -> Puntos
puntosDeCorredor unCorredor = puntosPorPosicion . filter ((== unCorredor) . corredor) . posiciones

puntosPorPosicion :: [Posicion] -> Puntos
puntosPorPosicion ((_, puntosDelCorredor):_) = puntosDelCorredor
puntosPorPosicion []                         = 0
```

Se filtra la lista de posiciones para quedarse con las que corresponden al corredor (debería haber 0 ó 1). Si el resultado está vacío devuelve 0; si tiene elementos toma el primero por pattern matching. Es concisa pero usa `head` de forma implícita: si por algún motivo hubiera más de una posición para el mismo corredor, tomaría la primera silenciosamente.

**Alternativa 2 — `Maybe` + `safeHead` (vigente)**

```haskell
puntosDeCorredor :: Corredor -> Carrera -> Puntos
puntosDeCorredor unCorredor = puntosPorPosicion . safeHead . filter ((== unCorredor) . corredor) . posiciones

-- safeHead no lanza una excepción si la lista está vacía:
-- devuelve Nothing (ausencia de valor) o Just x (valor presente)
safeHead :: [a] -> Maybe a
safeHead []     = Nothing
safeHead (x:xs) = Just x

puntosPorPosicion :: Maybe Posicion -> Puntos
puntosPorPosicion Nothing         = 0
puntosPorPosicion (Just posicion) = puntos posicion
```

`Maybe` es el tipo de dato de Haskell para representar que un valor *puede o no estar*. Tiene dos constructores: `Nothing` (ausencia) y `Just valor` (presencia). Equivale al `Optional<T>` de Java o al tipo `T | null` con `?` de TypeScript y Kotlin.

`safeHead` hace explícito en el tipo que el resultado puede ser vacío: en lugar de explotar con un error en tiempo de ejecución como haría `head []`, devuelve `Nothing`. Después `puntosPorPosicion` maneja ambos casos por pattern matching.

Esta alternativa es más expresiva porque el tipo dice exactamente que "quizás hay una posición, quizás no".

**Variante simplificada (también válida)**

```haskell
puntosDeCorredor unCorredor = sum . map puntos . filter ((== unCorredor) . corredor) . posiciones
```

`sum` de una lista vacía es 0, así que el caso "no participó" sale gratis. Muy concisa, aunque no introduce el concepto de `Maybe`.

---

### 3. Ordenar la tabla de posiciones

`sortCorredores` toma la lista de posiciones (corredor, puntos) y la devuelve ordenada de mayor a menor puntaje.

**Alternativa 1 — ordenamiento por inserción con `foldl` (vigente)**

```haskell
sortCorredores :: [Posicion] -> [Posicion]
sortCorredores = foldl ordenarCorredor []

ordenarCorredor :: [Posicion] -> Posicion -> [Posicion]
ordenarCorredor [] posicion = [posicion]
ordenarCorredor (posicion1:posiciones) posicion
    | puntos posicion > puntos posicion1 = posicion : posicion1 : posiciones
    | otherwise                          = posicion1 : ordenarCorredor posiciones posicion
```

Va construyendo la lista ordenada de a un elemento por vez (inserción). Si el elemento nuevo tiene más puntos que el primero de la lista acumulada, va al frente; si no, se busca su lugar recursivamente. Es un algoritmo **estable**: ante empate de puntos, el corredor que aparece antes en la lista de entrada mantiene su posición relativa.

**Alternativa 2 — quicksort**

```haskell
sortCorredores :: [Posicion] -> [Posicion]
sortCorredores []     = []
sortCorredores (corredor:corredores) =
    sortCorredores conMasPuntos ++ [corredor] ++ sortCorredores conMenosPuntos
    where
        conMasPuntos   = filter (\(_, puntosOtro) -> puntosActual < puntosOtro) corredores
        conMenosPuntos = filter (\(_, puntosOtro) -> puntosActual >= puntosOtro) corredores
        puntosActual   = puntos corredor
```

El primer elemento de la lista actúa como pivote. Se separan los que tienen más puntos y los que tienen menos (o igual), se ordenan recursivamente y se concatenan. Es el ejemplo clásico de cómo la recursión y las listas encajan de forma natural en Haskell. A diferencia de la inserción, **no es estable**: ante empate de puntos el orden relativo puede variar.

Explicaciones visuales del algoritmo:
- [https://www.youtube.com/watch?v=MZaf_9IZCrc](https://www.youtube.com/watch?v=MZaf_9IZCrc)
- [https://www.youtube.com/watch?v=d0V6ibXxI5M](https://www.youtube.com/watch?v=d0V6ibXxI5M)

## Cómo correrlo

Una vez clonado el repo, desde la carpeta raíz:

```bash
stack build
stack ghci
```

Desde el REPL podés pedir la tabla de posiciones:

```haskell
tablaDePosiciones carreras corredores
```

## Tests

Para correr la suite de tests:

```bash
stack test
```

## Diapositivas

Podés ver [aquí](https://docs.google.com/presentation/d/1M1D-v42JwRWg7VjuZ2D0r10lhQ88aX6QhUJ0eBVxHBs/edit#slide=id.g77eff50ac3_0_156) la explicación didáctica que guía el ejemplo.
