# gml-iterator
Otro "foreach" para game maker con la excepcion de que permite utilizar variables locales. Soporta actualmente:
  * Array
  * Struct
  * String
  * List
  * Map

Ejemplo de uso:

iterate data, name istart
	/*CODIGO A EJECUTAR*/
iend

### Descripión

#### Arrays y List
```iterate data, name, index```
en donde data es el array/list que se intenta iterar, name es el nombre que se desea usar para los valores adentro del array/list y index es el nombre que se desea usar para el indice que se encuentra el iterador.

#### Struct y Map
```iterate data, name, key, index```
en donde data es el struct/map que se intenta iterar, name es el nombre que se desea usar para los valores adentro del struct/map, key es el nombre que se desea usar para la llave que se encuentra el iterador y index es el nombre que se desea usar para el indice que se encuentra el iterador.

#### String
```iterate data, name, char, index```
en donde data es el string que se intenta iterar, name es el nombre que se desea usar para el texto recreado por iteracion, char es el nombre que se desea usar para el caracter actual en el que se encuentra el iterador y index es el nombre que se desea usar para el indice que se encuentra el iterador.


## Ejemplos

#### Array
```
  var _array = [0, 1, 2, 3, 4, 5];  
  iterate _array, "valor" istart
    show_debug_message(valor);
  istart
  
  //  Mostrará
  //  0, 1, 2, 3, 4, 5
```

#### Struct
```
  var _struct = {
    be: " me",
    not: " for bee",
    no: " honey for me"
  }

  iterate _struct, "in", "key" istart
    show_debug_message("\n" + key + in);
  iend

    //  Mostrará
    //  be me
    //  not for bee
    //  no honey for me
  fin
```

## Rendimiento

Acá se muestra una prueba de rendimiento, se utiliza un array con 100 elementos y se realizan una suma del valor anterior con el valor nuevo en la iteracion.

| Metodo  			 | Tiempo [ms]      |
| ------------------ | ---------------- |
| iterate 			 | 0.20             |
| repeat  			 | 0.3              |
| anonymous-function | 0.6              |
