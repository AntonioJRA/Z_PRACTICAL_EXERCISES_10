CLASS zcl_cp03_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cp03_10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lo_flight_manager) = NEW zcl_flight_manager_10( ).

    TRY.
        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #(
            airline    = 'AA'
            flight_num = '4001'
            origin     = 'MUC'
            dest       = 'PAR'
            price      = '100.00'
            seats_free = 50
          )
        ).

        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'LH' flight_num = '2001' origin = 'FRA' dest = 'MAD' price = '180.00' seats_free = 18 )
        ).

        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'AF' flight_num = '3001' origin = 'PAR' dest = 'ROM' price = '150.00' seats_free = 30 )
        ).

        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'IB' flight_num = '1002' origin = 'BCN' dest = 'PMI' price = '90.00' seats_free = 40 )
        ).

        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'LH' flight_num = '2002' origin = 'MUC' dest = 'LON' price = '210.00' seats_free = 15 )
        ).

**        PRECIO NEGATIVO
*        lo_flight_manager->zif_flight_manager_10~add_flight(
*            is_flight = VALUE #( airline = 'IB' flight_num = '1007' origin = 'BCN' dest = 'PMI' price = '-90.00' seats_free = 40 )
*        ).
*
**        VUELO REPETIDO
*        lo_flight_manager->zif_flight_manager_10~add_flight(
*            is_flight = VALUE #( airline = 'AF' flight_num = '3001' origin = 'PAR' dest = 'ROM' price = '150.00' seats_free = 30 )
*        ).

      CATCH zcx_flight_error_10 INTO DATA(lo_ex).
        out->write( lo_ex->message ).
    ENDTRY.


*        PRECIO NEGATIVO
    TRY.

        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'IB' flight_num = '1007' origin = 'BCN' dest = 'PMI' price = '-90.00' seats_free = 40 )
        ).

      CATCH zcx_flight_error_10 INTO DATA(err_negative_number).
        out->write( err_negative_number->message ).
    ENDTRY.

*        VUELO REPETIDO
    TRY.
        lo_flight_manager->zif_flight_manager_10~add_flight(
            is_flight = VALUE #( airline = 'AF' flight_num = '3001' origin = 'PAR' dest = 'ROM' price = '150.00' seats_free = 30 )
        ).

      CATCH zcx_flight_error_10 INTO DATA(err_duplicate).
        out->write( err_duplicate->message ).
    ENDTRY.

*   5. Muestra los vuelos de una aerolínea concreta.
    out->write( 'Muestra los vuelos de una aerolínea concreta' ).
    out->write(
        lo_flight_manager->zif_flight_manager_10~get_flights_by_airline(
          EXPORTING
            iv_airline = 'LH'
        )
    ).

*   6. Muestra el vuelo más barato.
    out->write( 'Muestra la vuelo más barato' ).
    out->write(
        lo_flight_manager->zif_flight_manager_10~get_cheapest_flight( )
    ).

*   7. Muestra la facturación total.
    out->write( 'Muestra la facturación total' ).
    out->write(
        lo_flight_manager->zif_flight_manager_10~get_total_revenue( )
    ).


  ENDMETHOD.
ENDCLASS.
