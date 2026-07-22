CLASS zcl_flight_manager_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES:
      if_oo_adt_classrun,
      zif_flight_manager_10.

    METHODS constructor
      IMPORTING
        it_flights TYPE zif_flight_manager_10=>tt_flights OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_flights TYPE zif_flight_manager_10=>tt_flights.

ENDCLASS.



CLASS zcl_flight_manager_10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.



  METHOD constructor.
    mt_flights = it_flights.
  ENDMETHOD.



  METHOD zif_flight_manager_10~add_flight.
*  Validar precio
    IF is_flight-price <= 0.
      RAISE EXCEPTION TYPE zcx_flight_error_10
        EXPORTING
          iv_message = 'El precio del vuelo no es positivo' .
    ENDIF.

*   Comprobar duplicados
    READ TABLE mt_flights
    WITH KEY airline = is_flight-airline
             flight_num = is_flight-flight_num
             TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE zcx_flight_error_10
        EXPORTING
          iv_message = 'El vuelo ya existe'.
    ENDIF.

*   Añadir a la tabla interna
    APPEND is_flight TO mt_flights.
  ENDMETHOD.



  METHOD zif_flight_manager_10~get_cheapest_flight.
*   RECOMENDADO
*   RAISE EXCEPTION NEW zcx_flight_error_03_26( iv_message = |Error: Ya existe el vuelo { is_flight-airline }{ is_flight-flight_num } en el sistema.|
*
*    IF flights IS INITIAL.
*      RAISE EXCEPTION NEW zcx_flight_error_03_26(
*        iv_message = |Error: No hay vuelos registrados para calcular el más barato.|
*      ).
*    ENDIF.

    rs_flight = REDUCE zif_flight_manager_10=>ty_flight(
        INIT lv_cheapest = VALUE #( )
            FOR ls_flight IN mt_flights
            NEXT lv_cheapest = COND #(
                WHEN lv_cheapest IS INITIAL OR ls_flight-price < lv_cheapest-price
                THEN ls_flight
                ELSE lv_cheapest
            )
        ).

  ENDMETHOD.



  METHOD zif_flight_manager_10~get_flights_by_airline.
*  SI NUESTRA TABLA FUESE HASHED O SORTED
*    rt_flights = FILTER #(
*        mt_flights
*        WHERE airline = iv_airline
*    ).

    rt_flights = VALUE #(
        FOR ls_flight IN mt_flights
        WHERE ( airline = iv_airline )
        ( ls_flight )
    ).


  ENDMETHOD.



  METHOD zif_flight_manager_10~get_total_revenue.

    rv_total = REDUCE zif_flight_manager_10=>ty_amount(
        INIT lv_total = 0
        FOR ls_flight IN mt_flights
        NEXT lv_total += ls_flight-price
     ).

  ENDMETHOD.

ENDCLASS.
