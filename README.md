# Simulating Rolling Shutter

Diego Shalom

Inspirado en el dispositivo que tienen en el C3

Inspirado también en este video de Smarter Every Day https://www.youtube.com/watch?v=dNVtMmLlnoE

## Como funca

Toma imagenes de la webcam y las procesa para simular el simpático efecto de Rolling Shutter

### Performance

En mi compu corre a unos 25fps. Por lo que si la resolución es 160x120, tiene 120 lineas verticales, y tarda unos 120/25 ~5 segundos en barrer verticalmente la pantalla. Con resoluciones más altas, tarda más, y el efecto no esta tan lindo. 

### TO DO: 

Se podria implementar que en cada actualizacion tome mas de una linea de cada frame, por lo que tardaria menos a resoluciones altas. intentí implementarlo pero no me salió. habria que trabajar un poco mas.

### Versiones:
A mi me funciona bien la webcam en Matlab 2013a 32, pero no me funciona en 2015a 64, por la webcam. No se si es por los 64bit, o es la version mas nueva.