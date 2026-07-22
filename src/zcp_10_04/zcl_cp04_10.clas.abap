CLASS zcl_cp04_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

*    TYPES:
*      BEGIN OF st_flights,
*        id_reserva TYPE i,
*        aerolinea  TYPE c LENGTH 2,
*        num_vuelo  TYPE n LENGTH 4,
*        pasajero   TYPE string,
*        fecha      TYPE d,
*        precio     TYPE p LENGTH 8 DECIMALS 2,
*        estado     TYPE c LENGTH 1,
*      END OF st_flights.

* Todos los campos son tipos genéricos
*id_reserva  Podría usar un elemento de datos con la descripción "ID de reserva".
*aerolinea   Podría usar un elemento de datos como un código de aerolínea, con validación y ayuda F4.
*num_vuelo   Podría tener un elemento de datos específico para números de vuelo.
*pasajero    Podría usar un elemento de datos para nombre de pasajero con longitud definida y etiquetas.
*fecha   Podría utilizar un elemento de datos de fecha de vuelo con documentación.
*precio  Lo ideal sería un elemento de datos asociado a un dominio de importe y, normalmente, acompañado de un campo de moneda (WAERS).
*estado  Muy recomendable un elemento de datos con un dominio de valores fijos (por ejemplo: A = Activa, C = Cancelada, F = Finalizada), facilitando validación y ayuda F4.


*    data flights type standard table of st_flights with empty key.
    DATA flights TYPE STANDARD TABLE OF zst_booking_10 WITH EMPTY KEY.

ENDCLASS.



CLASS zcl_cp04_10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    flights = VALUE #(
      (
            id_reserva = 1
            aerolinea  = 'LH'
            num_vuelo  = '0400'
            pasajero   = 'Ana García'
            fecha      = '20260515'
            precio      = '899.00'
            estado     = 'A'
      )
      (
            id_reserva = 2
            aerolinea  = 'IB'
            num_vuelo  = '3740'
            pasajero   = 'Calos López'
            fecha      = '20260515'
            precio      = '120.00'
            estado     = 'A'
      )
      (
            id_reserva = 3
            aerolinea  = 'AA'
            num_vuelo  = '0017'
            pasajero   = 'John Smith'
            fecha      = '20260520'
            precio      = '450.50'
            estado     = 'A'
      )
      (
            id_reserva = 4
            aerolinea  = 'LH'
            num_vuelo  = '0455'
            pasajero   = 'María Pérez'
            fecha      = '20260520'
            precio      = '310.75'
            estado     = 'A'
      )
      (
            id_reserva = 5
            aerolinea  = 'IB'
            num_vuelo  = '3740'
            pasajero   = 'Pedro Ruiz'
            fecha      = '20260515'
            precio      = '120.00'
            estado     = 'C'
      )
      (
            id_reserva = 6
            aerolinea  = 'SQ'
            num_vuelo  = '0026'
            pasajero   = 'Lisa Tan'
            fecha      = '20260601'
            precio      = '1250.00'
            estado     = 'A'
      )
      (
            id_reserva = 7
            aerolinea  = 'LH'
            num_vuelo  = '0400'
            pasajero   = 'Hans Müller'
            fecha      = '20260515'
            precio      = '899.00'
            estado     = 'A'
      )
      (
            id_reserva = 8
            aerolinea  = 'AA'
            num_vuelo  = '0064'
            pasajero   = 'Sarah Jones'
            fecha      = '20260525'
            precio      = '510.00'
            estado     = 'A'
      )
    ).

    out->write( flights ).
    out->write( '-----------------------------------' ).


* Tarea 2.1 – Altas de reservas
**********************************************************************
    out->write( 'Tarea 2.1 – Altas de reservas' ).
    APPEND VALUE #(
            id_reserva = 9
            aerolinea  = 'IB'
            num_vuelo  = '3950'
            pasajero   = 'Elena Martín'
            fecha      = '20260601'
            precio      = '285.30'
            estado     = 'A'
     ) TO flights.

    APPEND VALUE #(
           id_reserva = 10
           aerolinea  = 'LH'
           num_vuelo  = '2030'
           pasajero   = 'Franz Weber'
           fecha      = '20260610'
           precio      = '95.00'
           estado     = 'A'
    ) TO flights.

    out->write( flights ).
    out->write( '-----------------------------------' ).

* Tarea 2.2 – Modificaciones MODIFY
**********************************************************************
* REUTILIZABLES
*    DATA flights_backup TYPE STANDARD TABLE OF st_flights WITH EMPTY KEY.
    DATA flights_backup TYPE STANDARD TABLE OF zst_booking_10 WITH EMPTY KEY.
    flights_backup = flights.

**********************************************************************
*    1. Busca la reserva con ID 3 y cambia su precio a 480.00.
    out->write( 'Tarea 2.2 – Modificaciones MODIFY' ).
*    DATA modify_modified_flights TYPE STANDARD TABLE OF st_flights WITH EMPTY KEY.
    DATA modify_modified_flights TYPE STANDARD TABLE OF zst_booking_10 WITH EMPTY KEY.

*    DATA modify_flights TYPE st_flights.
    DATA modify_flights TYPE zst_booking_10.

    READ TABLE flights_backup
    INTO modify_flights
    WITH KEY id_reserva = 3.

    IF sy-subrc = 0.

      modify_flights-precio = '480.00'.

      MODIFY flights_backup FROM modify_flights INDEX sy-tabix.

      APPEND modify_flights TO modify_modified_flights.

    ENDIF.

*    2. Para todas las reservas de la aerolínea LH, aplica un descuento del 10%.
*       Muestra los registros modificados.
    LOOP AT flights_backup INTO DATA(modify_flight).

      IF modify_flight-aerolinea = 'LH'.

        modify_flight-precio = modify_flight-precio * '0.9'.

        MODIFY flights_backup FROM modify_flight INDEX sy-tabix.

        APPEND modify_flight TO modify_modified_flights.

      ENDIF.

    ENDLOOP.

    out->write( 'Registros modificados con MODIFY:' ).
    out->write( modify_modified_flights ).
    out->write( '-----------------------------------' ).

* Tarea 2.2 – Modificaciones ASSIGNING FIELD-SYMBOLS
**********************************************************************
*    1. Busca la reserva con ID 3 y cambia su precio a 480.00.
    out->write( 'Tarea 2.2 – Modificaciones ASSIGNING FIELD-SYMBOLS' ).
*    DATA afs_modified_flights TYPE STANDARD TABLE OF st_flights WITH EMPTY KEY.
    DATA afs_modified_flights TYPE STANDARD TABLE OF zst_booking_10 WITH EMPTY KEY.

*    FIELD-SYMBOLS <afs_flight> TYPE st_flights.
    FIELD-SYMBOLS <afs_flight> TYPE zst_booking_10.

    READ TABLE flights_backup
    ASSIGNING <afs_flight>
    WITH KEY id_reserva = 3.

    IF sy-subrc = 0.

      <afs_flight>-precio = '480.00'.

      APPEND <afs_flight> TO afs_modified_flights.

    ENDIF.


*    2. Para todas las reservas de la aerolínea LH, aplica un descuento del 10%.
*       Muestra los registros modificados.
    LOOP AT flights ASSIGNING FIELD-SYMBOL(<flight>).

      IF <flight>-aerolinea = 'LH'.

        <flight>-precio = <flight>-precio * '0.9'.

        APPEND <flight> TO afs_modified_flights.

      ENDIF.

    ENDLOOP.

    out->write( 'Registros modificados con ASSIGNING FIELD-SYMBOLS:' ).
    out->write( afs_modified_flights ).
    out->write( '-----------------------------------' ).


* Tarea 2.3 – Cancelaciones y borrados con MODIFY
**********************************************************************
*    1. Cambia el estado de la reserva ID 4 a «C» (cancelada).
    out->write( 'Tarea 2.3 – Cancelaciones y borrados con MODIFY' ).
*    FIELD-SYMBOLS <afs_flight> TYPE st_flights.

    READ TABLE flights_backup
    INTO modify_flights
    WITH KEY id_reserva = 4.

    IF sy-subrc = 0.

      modify_flights-estado = 'C'.

      MODIFY flights_backup FROM modify_flights INDEX sy-tabix.

    ENDIF.

* 2. Elimina físicamente de la tabla todas las reservas con estado «C».
    DELETE flights_backup WHERE estado = 'C'.

    out->write( 'Registros cancelados eliminados:' ).
    out->write( flights_backup ).

* 3. Muestra la tabla resultante y el número de registros eliminados.
    out->write( |Número de registros eliminados: { sy-dbcnt }| ).
    out->write( '-----------------------------------' ).

*   Reset del backup
    flights_backup = flights.

* Tarea 2.3 – Cancelaciones y borrados con ASSIGNING FIELD-SYMBOLS
**********************************************************************
*    1. Cambia el estado de la reserva ID 4 a «C» (cancelada).
    out->write( 'Tarea 2.3 – Cancelaciones y borrados con ASSIGNING FIELD-SYMBOLS' ).
*    FIELD-SYMBOLS <afs_flight> TYPE st_flights.

    READ TABLE flights_backup
    ASSIGNING <afs_flight>
    WITH KEY id_reserva = 4.

    IF sy-subrc = 0.

      <afs_flight>-estado = 'C'.

    ENDIF.


* 2. Elimina físicamente de la tabla todas las reservas con estado «C».
    DELETE flights_backup WHERE estado = 'C'.

    out->write( 'Registros cancelados eliminados:' ).
    out->write( flights_backup ).

* 3. Muestra la tabla resultante y el número de registros eliminados.
    out->write( |Número de registros eliminados: { sy-dbcnt }| ).
    out->write( '-----------------------------------' ).

*   Guardado en flights
    flights = flights_backup.

* Tarea 2.4 – Búsquedas
**********************************************************************
*   1. Busca si existe una reserva para el pasajero «Lisa Tan» (TRANSPORTING NO FIELDS + sy-subrc).
    out->write( 'Tarea 2.4 – Búsquedas (TRANSPORTING NO FIELDS)' ).
    READ TABLE flights_backup
    WITH KEY pasajero = 'Lisa Tan'
    TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      out->write( | Existe una reserva para el pasajero "Lisa Tan" en posición { sy-tabix }| ).
      out->write( '-----------------------------------' ).

    ENDIF.

*    IF line_exists( )
    out->write( 'Tarea 2.4 – Búsquedas (line_exists)' ).

    IF line_exists( flights_backup[ pasajero = 'Lisa Tan' ] ).

      out->write( 'Existe una reserva para el pasajero Lisa Tan' ).
      out->write( '-----------------------------------' ).
    ENDIF.

*    READ TABLE ... ASSIGNING FIELD-SYMBOL (utilizando sy-tabix)
    out->write( 'Tarea 2.4 – Búsquedas (ASSIGNING FIELD-SYMBOL)' ).

    READ TABLE flights_backup
    ASSIGNING <afs_flight>
    WITH KEY pasajero = 'Lisa Tan'.

    IF sy-subrc = 0.

      out->write( | Existe una reserva para el pasajero "Lisa Tan" en posición { sy-tabix }| ).
      out->write( '-----------------------------------' ).

    ENDIF.

*   2. Obtén una referencia (REFERENCE INTO) a la reserva con ID 6 y
*   muestra sus datos.
*    DATA flight_ref TYPE REF TO st_flights.
    DATA flight_ref TYPE REF TO zst_booking_10.

    READ TABLE flights
      REFERENCE INTO flight_ref
      WITH KEY id_reserva = 6.

    IF sy-subrc = 0.

      out->write( 'REFERENCE INTO' ).
      out->write( flight_ref->* ).
      out->write( '-----------------------------------' ).

    ENDIF.

*    3. Usa la expresión de tabla VALUE #( itab[ ... ] ) para acceder directamente al
*   pasajero de la reserva con ID 1.
    DATA(passenger) = VALUE #(
        flights[ id_reserva = 1 ]
     ).

    out->write( 'ITAB' ).
    out->write( passenger ).
    out->write( '-----------------------------------' ).

* Tarea 2.5 – Agrupación y agregados
**********************************************************************
    out->write( 'Tarea 2.5 – Agrupación y agregados' ).
    LOOP AT flights_backup INTO DATA(group_flight)
        GROUP BY ( aerolinea = group_flight-aerolinea )
        INTO DATA(group).

      DATA(total_reservas) = 0.
      DATA(total_precio) = CONV decfloat34( 0 ).

      LOOP AT GROUP group INTO DATA(member).

        total_reservas += 1.
        total_precio += member-precio.

      ENDLOOP.

      DATA(precio_medio) = total_precio / total_reservas.

      out->write( |Aerolínea: { group-aerolinea } -----| ).
      out->write( |Reservas: { total_reservas } | ).
      out->write( |Precio total: { total_precio } | ).
      out->write( |Precio medio: { precio_medio } | ).
      out->write( '-----------------------------------' ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
