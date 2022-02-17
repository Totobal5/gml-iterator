# gml-iterator
Otro "foreach" para game maker con la excepcion de que permite utilizar variables locales. Soporta actualmente:
  * Array
  * Struct
  * String
  * List
  * Map

Ejemplo de uso:

iter "variables_name", data_struct exc 
// CODE
fin

### Descripión

variables_name: los nombres de variables que se utilizaran.
  * Para *arrays* se puede utilizar un string (que será el nombre de la variable) con los indices siendo guardados en "i". Pero tambien se puede utilizar un array que incluye el     nombre de la variable como el indice. (ejemplo: ["in", "index"] )

  * Para *structs* se puede utilizar un string (que será el nombre de la variable) con las llaves siendo "key" y los indices siendo "i". Pero tambien se puede utilizar un array  que incluye las variables de indice y llave (ejemplo: ["in", "name", "index"] *SI SE UTIlIZA UN ARRAY SI O SI SE DEBE INDICAR EL NOMBRE DE LA LLAVE*)

  * Para *strings* se se puede utilizar un string(que será el nombre de la variable) con el indice siendo "i" y la posicion de caracter en el texto siendo "pos". Pero tambien se puede utilizar un array que incluye las variables de indice y posicion (ejemplo: ["in", "index", "position"] ) *SI SE UTILIZA UN ARRAY SI O SI SE DEBE INDICAR EL NOMBRE DE LA POSICIÓN*

  * Para *list* funciona de igual manera que los *arrays*

  * Para *map* funciona de igual manera que los *structs*

data_struct: El tipo de dato que se debe de iterar. Lanzará un error al intentar iterar un dato no soportado.


## Ejemplos

#### Array
```
  var _array = [0, 1, 2, 3, 4, 5];  
  iter "in" , _array exc
    show_debug_message(in);
    
    //  Mostrará
    //  0, 1, 2, 3, 4, 5
  fin
```

#### Struct
```
  var _struct = {
    be: " me",
    not: " for bee",
    no: " honey for me"
  }

  iter "in" , _struct exc
    show_debug_message("\n" + key + in);
    
    //  Mostrará
    //  be me
    //  not for bee
    //  no honey for me
  fin
```



