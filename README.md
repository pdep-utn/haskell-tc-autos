# Ejercicio Corredores de TC

[![Build Status](https://travis-ci.org/pdep-utn/haskell-tc-autos.svg?branch=master)](https://travis-ci.org/pdep-utn/haskell-tc-autos)

Dada la siguiente información de las carreras de TC disputadas en el año, se pide que arme la tabla de posiciones indicando

- corredor y puntos obtenidos
- ordenándolo de mayor a menor

## Instrucciones para descargarse el ejemplo

Una vez clonado el repo, se paran en la carpeta raíz y ejecutan los siguientes comandos en Git Bash / terminal de Linux:

```bash
stack build intero
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
