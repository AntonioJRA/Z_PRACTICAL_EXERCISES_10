INTERFACE zif_flight_manager_10
  PUBLIC .

  " Inicia la declaración de una estructura de tipos llamada ty_flight,
  "que representará los datos de un vuelo con los siguientes CAMPOS
  "Ningún punto del enunciado habla de: pasajeros, estado del vuelo, identificador id, origen, destino y asientos libres
  TYPES: BEGIN OF ty_flight,
           airline    TYPE c LENGTH 2, "código de aerolínea, tipo carácter de 2 posiciones
           flight_num TYPE n LENGTH 4, "número de vuelo, tipo numérico de 4 posiciones
           origin     TYPE c LENGTH 3, "aeropuerto de origen, tipo carácter de 3 posiciones
           dest       TYPE c LENGTH 3, "aeropuerto de destino, tipo carácter de 3 posiciones
           price      TYPE p LENGTH 8 DECIMALS 2, "precio del vuelo, tipo empaquetado con 8 de longitud y 2 decimales
           seats_free TYPE i, "asientos libres, tipo entero
         END OF ty_flight.

  " Declara un tipo TABLA INTERNA tt_flights basado en la estructura ty_flight,
  " como tabla estándar (permite duplicados y acceso por índice)
  TYPES tt_flights TYPE STANDARD TABLE OF ty_flight
        " Define una clave primaria explícita no única, compuesta por los campos airline y flight_num
        WITH NON-UNIQUE KEY airline flight_num.
  "no incluimos una clave secundaria hash porque
  "para el volumen de datos de este ejercicio (unos pocos vuelos de prueba)
  "la diferencia de rendimiento es irrelevante

  "" Declara un tipo reutilizable ty_amount para cualquier importe monetario (precio, facturación, etc.), evitando el tipo genérico p en RETURNING
  TYPES ty_amount TYPE p LENGTH 8 DECIMALS 2.

**********************************************************************

  METHODS add_flight
    IMPORTING is_flight TYPE ty_flight
    RAISING
      zcx_flight_error_10.

  METHODS get_flights_by_airline
    IMPORTING iv_airline        TYPE c
    RETURNING VALUE(rt_flights) TYPE tt_flights.

  METHODS get_cheapest_flight
    RETURNING VALUE(rs_flight) TYPE ty_flight.

  METHODS get_total_revenue
    RETURNING VALUE(rv_total) TYPE ty_amount.

ENDINTERFACE.
