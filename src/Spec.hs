module Spec where

import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Tabla de posiciones" $ do
    it "Quien gana hasta el momento" $ do
      ((corredor . head . tablaDePosiciones) carreras) `shouldBe` "Urcera"
    it "Cuantos puntos tiene" $ do
      ((puntos . head . tablaDePosiciones) carreras) `shouldBe` 86.0
  