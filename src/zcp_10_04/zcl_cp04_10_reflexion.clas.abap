CLASS zcl_cp04_10_reflexion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cp04_10_reflexion IMPLEMENTATION.

ENDCLASS.

*• ¿Qué ventajas tiene usar tipos del diccionario frente a tipos locales?
*Son reutilizables por diferentes programas, clases, CDS y tablas.
*Incorporan etiquetas descriptivas para las pantallas.
*Pueden incluir documentación y ayudas de búsqueda (F4).
*Garantizan que todos los desarrollos utilicen el mismo formato de datos, facilitando el mantenimiento.


*• ¿En qué escenarios seguirías usando TYPES locales?
*Para estructuras o tablas internas que solo se utilizan dentro de una clase o programa.
*En pruebas, ejemplos o ejercicios.
*Cuando el tipo no va a reutilizarse en otros objetos del sistema.


*• ¿Cómo se relacionan los elementos de datos con los dominios en ABAP clásico? ¿Existe esa distinción en ABAP Cloud?
*
*En ABAP clásico:
*
*Un dominio define las características técnicas del dato (tipo, longitud, decimales y, opcionalmente, valores permitidos).
*Un elemento de datos utiliza un dominio y añade la parte semántica: etiquetas, documentación y ayudas de búsqueda.

*En ABAP Cloud:
*
*La separación entre dominio y elemento de datos sigue existiendo en el Diccionario ABAP y continúa utilizándose.
*Sin embargo, en los desarrollos modernos (por ejemplo, CDS y RAP) se fomenta definir la semántica mediante
*anotaciones y reutilizar tipos ya existentes del sistema siempre que sea posible, reduciendo la
*creación de nuevos objetos DDIC cuando no aportan valor.

