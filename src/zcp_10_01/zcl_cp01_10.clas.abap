
CLASS zcl_cp01_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF st_flights,
        Airline      TYPE /dmo/carrier_id,
        FlightNumber TYPE /dmo/connection_id,
        AirportFrom  TYPE /dmo/airport_from_id,
        AirportTo    TYPE /dmo/airport_to_id,
        Price        TYPE /dmo/flight_price,
        FreeSeats    TYPE i,
      END OF st_flights.

    DATA flights TYPE STANDARD TABLE OF st_flights WITH EMPTY KEY.

ENDCLASS.



CLASS zcl_cp01_10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* IMPLEMENTACION DE LA TABLA INTERNA
    flights =
        VALUE #(
          (
          airline = 'LH'
          flightnumber = '0400'
          airportfrom = 'FRA'
          airportto = 'JFK'
          price = '899.00'
          freeseats = '15'
          )
          (
          airline = 'AA'
          flightnumber = '0017'
          airportfrom = 'JFK'
          airportto = 'SFO'
          price = '450.50'
          freeseats = '0'
          )
          (
          airline = 'IB'
          flightnumber = '3740'
          airportfrom = 'MAD'
          airportto = 'BCN'
          price = '120.00'
          freeseats = '42'
          )
          (
          airline = 'LH'
          flightnumber = '0455'
          airportfrom = 'FRA'
          airportto = 'MAD'
          price = '310.75'
          freeseats = '8'
          )
          (
          airline = 'AA'
          flightnumber = '0064'
          airportfrom = 'SFO'
          airportto = 'JFK'
          price = '510.00'
          freeseats = '3'
          )
          (
          airline = 'IB'
          flightnumber = '3950'
          airportfrom = 'BCN'
          airportto = 'LHR'
          price = '275.30'
          freeseats = '0'
          )
          (
          airline = 'LH'
          flightnumber = '2030'
          airportfrom = 'MUC'
          airportto = 'FRA'
          price = '95.00'
          freeseats = '60'
          )
          (
          airline = 'SQ'
          flightnumber = '0026'
          airportfrom = 'SIN'
          airportto = 'FRA'
          price = '1250.00'
          freeseats = '00'
          )
        ).

    out->write( flights ).

* Tarea 1.1 – Clasificación por precio
**********************************************************************
    out->write( 'Tarea 1.1 – Clasificación por precio' ).
    DATA flight_price TYPE st_flights-price.

    LOOP AT flights INTO DATA(flight).

      flight_price = flight-price.

      DATA(category) = COND string(
          WHEN flight_price <= 150 THEN 'Económico'
          WHEN flight_price > 150 AND flight_price <= 500 THEN 'Estándar'
          WHEN flight_price > 500 AND flight_price <= 1000  THEN 'Premium'
          ELSE 'First Class'
      ).

      out->write( | Vuelo: { flight-airline } { flight-flightnumber } - Category: { category } | ).

    ENDLOOP.

* Tarea 1.2 – Filtrado con operadores lógicos
**********************************************************************
    out->write( 'Tarea 1.2 – Filtrado con operadores lógicos' ).
    DATA output_2 TYPE TABLE OF st_flights.

    LOOP AT flights INTO DATA(flight_2).

      IF flight_2-freeseats > 0
      AND ( flight_2-airportfrom = 'FRA' OR flight_2-airportto = 'FRA' )
      AND flight_2-price < 1000.

        APPEND flight_2 TO output_2.

      ENDIF.
    ENDLOOP.

    out->write( output_2 ).

* Tarea 1.3 – Transformación de cadenas
**********************************************************************
    out->write( 'Tarea 1.3 – Transformación de cadenas' ).
    DATA concatAirline TYPE string.
    DATA airportToMinus TYPE string.
    DATA concatAirlineLenght TYPE i.


    LOOP AT flights INTO DATA(flight_3).

      IF flight_3-freeseats > 0
      AND ( flight_3-airportfrom = 'FRA' OR flight_3-airportto = 'FRA' )
      AND flight_3-price < 1000.

*       Código de vuelo concatenando la aerolínea y el número de vuelo
        CONCATENATE flight_3-airline flight_3-flightnumber
        INTO concatairline
        SEPARATED BY '-'.

*       Destino a minúsculas
        airportToMinus = to_lower( flight_3-airportto ).

*       Longitud del código generado
        concatairlinelenght = strlen( concatairline ).

        out->write( | { concatairline } \| { airportToMinus } \| { concatairlinelenght } | ).

      ENDIF.
    ENDLOOP.


* Tarea 1.4 – Resumen con funciones numéricas
**********************************************************************
    out->write( 'Tarea 1.4 – Resumen con funciones numéricas' ).
    DATA maxPrice TYPE st_flights-price.
    DATA minPrice TYPE st_flights-price.
    DATA allFlightPrices TYPE p LENGTH 8 DECIMALS 2.
    DATA avgPrice TYPE p LENGTH 8 DECIMALS 2.
    DATA totalFlights TYPE i.
    DATA totalSeats TYPE i VALUE 0.

    LOOP AT flights INTO DATA(flight_4).

*  precio máximo y mínimo de todos los vuelos.
      IF maxPrice IS INITIAL OR flight_4-price > maxPrice.
        maxPrice = flight_4-price.
      ENDIF.

      IF minPrice IS INITIAL OR minPrice > flight_4-price.
        minPrice = flight_4-price.
      ENDIF.

*  precio medio
      allFlightPrices = allFlightPrices + flight_4-price.
      totalflights =  totalflights + 1.

*  número total de plazas libres en todos los vuelos
      totalSeats = totalSeats + flight_4-freeseats.

    ENDLOOP.

*  precio medio
    avgprice = round(
        val = allflightprices / totalflights
        dec = 2
    ).

    out->write( |Max Price: { maxPrice } \| Min Price: { minPrice } \| Avg Price: { avgPrice } \| Total Seats: { totalSeats }| ).

  ENDMETHOD.
ENDCLASS.
