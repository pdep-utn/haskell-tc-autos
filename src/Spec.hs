module Spec where

import PdePreludat
import Library
import Test.Hspec

-- Fixtures auxiliares

carreraVacia :: Carrera
carreraVacia = Carrera "Vacía" (1, 1) []

unaCarrera :: Carrera
unaCarrera = Carrera "Test" (1, 1) [("Pepe", 10), ("Juan", 8), ("Ana", 5)]

tabla :: [Posicion]
tabla = tablaDePosiciones carreras corredores

correrTests :: IO ()
correrTests = hspec $ do

  describe "safeHead" $ do
    it "una lista vacía no tiene cabeza" $
      safeHead ([] :: [Number]) `shouldBe` Nothing
    it "la cabeza de una lista de un solo elemento es ese elemento" $
      safeHead [42 :: Number] `shouldBe` Just 42
    it "la cabeza de una lista no vacía es su primer elemento" $
      safeHead [1, 2, 3 :: Number] `shouldBe` Just 1

  describe "puntosPorPosicion" $ do
    it "una posición ausente vale 0 puntos" $
      puntosPorPosicion Nothing `shouldBe` 0
    it "una posición presente vale los puntos de esa posición" $
      puntosPorPosicion (Just ("Pepe", 10)) `shouldBe` 10

  describe "puntosDeCorredor" $ do
    it "un corredor que figura en una carrera obtiene los puntos de esa carrera" $
      puntosDeCorredor "Pepe" unaCarrera `shouldBe` 10
    it "un corredor que no figura en la carrera obtiene 0 puntos" $
      puntosDeCorredor "Fantasma" unaCarrera `shouldBe` 0
    it "una carrera sin posiciones aporta 0 puntos a cualquier corredor" $
      puntosDeCorredor "Pepe" carreraVacia `shouldBe` 0

  describe "puntosObtenidos" $ do
    it "un corredor que participó en varias carreras suma los puntos de todas" $
      puntosObtenidos "Urcera" carreras `shouldBe` 86
    it "un corredor que participó en una sola carrera obtiene los puntos de esa carrera" $
      puntosObtenidos "Pepe" [unaCarrera] `shouldBe` 10
    it "un corredor que no participó en ninguna carrera obtiene 0 puntos" $
      puntosObtenidos "Fantasma" carreras `shouldBe` 0
    it "sin carreras corridas, cualquier corredor obtiene 0 puntos" $
      puntosObtenidos "Urcera" [] `shouldBe` 0

  describe "ordenarCorredor" $ do
    it "insertar en una lista vacía produce una lista de un solo elemento" $
      ordenarCorredor [] ("Pepe", 10) `shouldBe` [("Pepe", 10)]
    it "una posición con más puntos que las existentes queda al frente" $
      ordenarCorredor [("Juan", 5)] ("Pepe", 10) `shouldBe` [("Pepe", 10), ("Juan", 5)]
    it "una posición con menos puntos que todas las existentes queda al final" $
      ordenarCorredor [("Pepe", 10), ("Juan", 8)] ("Ana", 3)
        `shouldBe` [("Pepe", 10), ("Juan", 8), ("Ana", 3)]
    it "una posición con puntos intermedios queda entre la de más puntos y la de menos" $
      ordenarCorredor [("Pepe", 10), ("Ana", 3)] ("Juan", 7)
        `shouldBe` [("Pepe", 10), ("Juan", 7), ("Ana", 3)]
    it "ante empate de puntos, la posición nueva queda después de la existente (orden estable)" $
      ordenarCorredor [("Pepe", 10), ("Juan", 5)] ("Ana", 5)
        `shouldBe` [("Pepe", 10), ("Juan", 5), ("Ana", 5)]

  describe "sortCorredores" $ do
    it "ordenar una lista vacía produce una lista vacía" $
      sortCorredores [] `shouldBe` []
    it "ordenar una lista de un solo elemento la deja igual" $
      sortCorredores [("Pepe", 10)] `shouldBe` [("Pepe", 10)]
    it "una lista ya ordenada de mayor a menor queda igual" $
      sortCorredores [("Pepe", 10), ("Juan", 8), ("Ana", 5)]
        `shouldBe` [("Pepe", 10), ("Juan", 8), ("Ana", 5)]
    it "una lista en orden inverso se reordena de mayor a menor" $
      sortCorredores [("Ana", 5), ("Juan", 8), ("Pepe", 10)]
        `shouldBe` [("Pepe", 10), ("Juan", 8), ("Ana", 5)]
    it "ante empate de puntos, se preserva el orden original de aparición (orden estable)" $
      sortCorredores [("Primero", 10), ("Segundo", 7), ("Tercero", 7), ("Cuarto", 3)]
        `shouldBe` [("Primero", 10), ("Segundo", 7), ("Tercero", 7), ("Cuarto", 3)]

  describe "tablaDePosiciones" $ do
    it "el primer puesto corresponde al corredor con mayor puntaje" $
      (corredor . head) tabla `shouldBe` "Urcera"
    it "el puntaje del primer puesto es la suma de sus participaciones" $
      (puntos . head) tabla `shouldBe` 86
    it "sin carreras corridas, todos los corredores tienen 0 puntos" $
      tablaDePosiciones [] corredores `shouldSatisfy` all ((== 0) . puntos)
    it "sin corredores, la tabla queda vacía" $
      tablaDePosiciones carreras [] `shouldBe` []
    it "un corredor que no participó en ninguna carrera aparece al final con 0 puntos" $
      (last . tablaDePosiciones carreras) (corredores ++ ["Fantasma"])
        `shouldBe` ("Fantasma", 0)
    it "la tabla contiene a todos los corredores con el puntaje correspondiente a la suma de sus carreras" $
      tabla `shouldMatchList`
        [ ("Urcera", 86), ("Ardusso", 83.5), ("Werner", 77.5)
        , ("Aguirre", 47), ("Rossi", 47)
        , ("Benvenuti", 45), ("Mangoni", 45)
        , ("Ortelli", 42), ("De Benedictis", 42), ("Ponce de León", 42)
        , ("Mazzacane", 39), ("Ledesma", 38.5)
        ]

    describe "estabilidad del sort en empates" $ do
      it "ante empate entre dos corredores, queda primero el que aparece antes en la lista de corredores" $
        takeWhile (/= "Rossi") (map corredor tabla) `shouldSatisfy` elem "Aguirre"
      it "ante empate entre tres o más corredores, se preserva el orden completo de la lista de corredores" $ do
        takeWhile (/= "De Benedictis") (map corredor tabla) `shouldSatisfy` elem "Ortelli"
        takeWhile (/= "Ponce de León") (map corredor tabla) `shouldSatisfy` elem "De Benedictis"
