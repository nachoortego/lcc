La instrucción LDR r1, =0x12abcdef o LDR r1, =etiqueta en la arquitectura ARM, especialmente a partir de la versión ARMv6T2, permite cargar un valor inmediato de 32 bits o la dirección de una etiqueta (también de 32 bits) en un registro. Aunque las instrucciones en ARM son de 32 bits de longitud, esto se logra gracias a un mecanismo de instrucción literal o "pseudo-instrucción".

Explicación:

Cuando usas LDR r1, =0x12abcdef o LDR r1, =etiqueta, lo que realmente está ocurriendo es que el ensamblador genera una secuencia de instrucciones que incluyen un salto a una dirección donde se almacena el valor inmediato (en lugar de hacerlo directamente en la misma instrucción de 32 bits).

El mecanismo funciona de la siguiente manera:

Cargar valores inmediatos grandes: Los valores inmediatos de 32 bits no pueden ser representados directamente en una instrucción ARM de 32 bits con un solo desplazamiento o valor inmediato debido a la limitación en los valores de 12 bits que pueden ser usados en las instrucciones ARM estándar.

Instrucción literal: La instrucción LDR r1, =0x12abcdef o LDR r1, =etiqueta es una pseudo-instrucción que, en realidad, lo que hace es cargar el valor desde una dirección literal. La dirección literal es un valor que contiene la dirección de memoria en la que está almacenado el valor inmediato o la etiqueta.

Generación de instrucciones adicionales: Para valores de 32 bits que no pueden ser cargados directamente, el ensamblador inserta instrucciones adicionales para cargar el valor en el registro. Este valor puede ser cargado en dos fases:

Primero, el valor inmediato puede ser colocado en una posición de memoria (en la sección de datos del programa o en una ubicación accesible).
Luego, la instrucción LDR se utiliza para cargar el valor desde esa dirección de memoria en el registro.
Por ejemplo:

La instrucción LDR r1, =0x12abcdef puede generar algo como: 

````c

LDR r1, [PC, #offset]   // Carga el valor desde una dirección calculada

````

Donde offset es la dirección relativa (desplazamiento) a la que se carga el valor inmediato, que se coloca en la sección de datos del programa.
Esto permite que la instrucción LDR cargue un valor de 32 bits usando solo una instrucción, aunque en el fondo, el proceso involucra una secuencia de operaciones más compleja que involucra una tabla de valores o direcciones, y no solo una instrucción directa de 32 bits.

En resumen, aunque las instrucciones ARM son de 32 bits de longitud, el mecanismo de dirección literal permite manejar valores grandes o direcciones de etiquetas mediante una combinación de instrucciones y memoria, logrando cargar un valor de 32 bits en un solo paso lógico.






