module Library where
import PdePreludat

-- Dada la siguiente información de las carreras de TC disputadas en el año...
type Corredor = String
type Puntos = Number
type Posicion = (Corredor, Puntos)

data Carrera = Carrera {
    lugar :: String,
    fecha :: (Number, Number),
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
    "Werner",
    "Benvenuti",
    "Aguirre",
    "Urcera",
    "De Benedictis",
    "Mangoni",
    "Mazzacane",
    "Rossi",
    "Ponce de León",
    "Ledesma"
    ]

carreras :: [Carrera]
carreras = [
    viedma,
    neuquen,
    concepcionUruguay,
    sanLuis,
    rosario
    ]


-- *******************************************************************************************************
-- Requerimiento
--
-- Se pide que arme la tabla de posiciones indicando (corredor, puntos obtenidos)
-- ordenándolo de mayor a menor

-- *******************************************************************************************************
-- Tabla de posiciones - función general
--
tablaDePosiciones :: [Carrera] -> [Corredor] -> [Posicion]
tablaDePosiciones carreras = sortCorredores . map (\corredor -> (corredor, puntosObtenidos corredor carreras))

-- *******************************************************************************************************
-- Obtener los puntos de un corredor
--
puntosObtenidos :: Corredor -> [Carrera] -> Puntos
puntosObtenidos corredor = foldr ((+) . puntosDeCorredor corredor) 0
-- puntosObtenidos corredor = foldl (\acum carrera -> acum + (findPuntos corredor) carrera) 0.0
-- puntosObtenidos corredor = foldl (flip ((+) . puntosDeCorredor corredor)) 0

corredor :: Posicion -> Corredor
corredor = fst

puntos :: Posicion -> Puntos
puntos = snd

-- alternativa 1
-- filtramos en la lista de posiciones aquellos que coinciden con el corredor, debería haber 0 ó 1
-- si no hay ninguno (lista vacía) => lo asociamos con 0
-- si hay alguno (debería ser 1 solo) => tomamos los puntos que es la segunda parte de la tupla

-- puntosDeCorredor :: Corredor -> Carrera -> Puntos
-- puntosDeCorredor unCorredor = puntosPorPosicion . filter ((== unCorredor) . corredor) . posiciones

-- puntosPorPosicion :: [Posicion] -> Puntos
-- puntosPorPosicion ((_, puntos):_) = puntos
-- puntosPorPosicion []         = 0


-- alternativa 2 heavy para calcular los puntos de un corredor en una carrera
--
puntosDeCorredor :: Corredor -> Carrera -> Puntos
puntosDeCorredor unCorredor = puntosPorPosicion . safeHead . filter ((== unCorredor) . corredor) . posiciones
-- otra opción más simple
-- puntosDeCorredor unCorredor = sum . map puntos . filter ((== unCorredor) . corredor) . posiciones

-- el head no es seguro (safe), puede devolverte un valor o no, para eso existe el tipo de dato Maybe
-- que se acompaña de otro tipo. En este caso si la lista es de aes, "maybe" te devuelvo un a, o "maybe not",
-- en cuyo caso te devuelvo Nothing. El tipo de dato Maybe tiene dos constructores: Nothing cuando
-- queremos representar el valor ausente, y Just (un valor) cuando el dato está presente.
-- Un concepto similar son los optional de Java o los nullable (`?` de Typescript y Kotlin).
--
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x

-- no sabemos si el corredor obtuvo puntos, entonces "maybe" (quizás) te paso los puntos
-- o por ahí no te paso nada
-- lo manejamos con pattern matching
--
puntosPorPosicion :: Maybe Posicion -> Number
puntosPorPosicion Nothing       = 0
puntosPorPosicion (Just posicion) = puntos posicion

-- *******************************************************************************************************
-- Ordenamiento
--
-- alternativa 1 - por burbujeo
-- explicación copada
-- https://www.youtube.com/watch?v=nmhjrI-aW5o
--
-- sortCorredores :: [Posicion] -> [Posicion]
-- sortCorredores = foldl ordenarCorredor []

-- ordenarCorredor :: [Posicion] -> Posicion -> [Posicion]
-- ordenarCorredor [] posicion = [posicion]
-- ordenarCorredor (posicion1:posiciones) posicion
--     | puntos posicion > puntos posicion1 = (posicion:posicion1:posiciones)
--     | otherwise                          = posicion1:ordenarCorredor posiciones posicion


-- alternativa 2
-- usar quicksort
-- explicaciones copadas son
-- https://www.youtube.com/watch?v=MZaf_9IZCrc
-- https://www.youtube.com/watch?v=d0V6ibXxI5M
-- 

sortCorredores :: [Posicion] -> [Posicion]
sortCorredores []     = []
sortCorredores (corredor:corredores) = (sortCorredores lesser) ++ [corredor] ++ (sortCorredores greater)
    where
        lesser  = filter (\(_, puntosOtro) -> puntosActual < puntosOtro) corredores
        greater = filter (\(_, puntosOtro) -> puntosActual >= puntosOtro) corredores
        puntosActual = puntos corredor
-- *******************************************************************************************************
