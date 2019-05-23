module Library where
import PdePreludat

-- Dada la siguiente información de las carreras de TC disputadas en el año...
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

-- Se pide que arme la tabla de posiciones indicando
-- Corredor, Puntos obtenidos
-- ordenándolo de mayor a menor
tablaDePosiciones :: [Carrera] -> [Posicion]
tablaDePosiciones carreras = (sortCorredores . map (\corredor -> (corredor, puntosObtenidos corredor carreras))) corredores

puntosObtenidos :: Corredor -> [Carrera] -> Puntos
puntosObtenidos corredor = foldr ((+) . findPuntos corredor) 0
--puntosObtenidos corredor = foldl (\acum carrera -> acum + (findPuntos corredor) carrera) 0.0

corredor :: Posicion -> Corredor
corredor = fst

findPuntos :: Corredor -> Carrera -> Puntos
findPuntos unCorredor = headOrZero . filter ((== unCorredor) . corredor) . posiciones

headOrZero :: [Posicion] -> Puntos
headOrZero [posicion] = snd posicion
headOrZero []         = 0

sortCorredores :: [Posicion] -> [Posicion]
sortCorredores = foldl ordenarCorredor []

ordenarCorredor :: [Posicion] -> Posicion -> [Posicion]
ordenarCorredor [] posicion = [posicion]
ordenarCorredor (posicion1:posiciones) posicion
    | (snd posicion1 < snd posicion) = (posicion:posicion1:posiciones)
    | otherwise                      = posicion1:ordenarCorredor posiciones posicion


-- Función 1
--f :: Ord t => (b -> Int) -> (Int -> b) -> Int -> t -> [t] -> Int
f a b c d (r:rs)
   | r > d      = (a . b) c
   | otherwise  = c * length rs

data Nota = Insuficiente | Regular | Aprobado | Sobresaliente deriving (Eq, Ord, Show, Enum)