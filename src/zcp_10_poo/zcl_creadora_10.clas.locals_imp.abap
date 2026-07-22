*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_creadora DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES tty_emp TYPE STANDARD TABLE OF ztab_eje_obj_10 WITH EMPTY KEY.

    METHODS constructor
      IMPORTING
        iv_nombre          TYPE zde_nombre_10
        iv_apellido        TYPE zde_nombre_10
        iv_telefono        TYPE zde_tele_10
        iv_experiencia     TYPE i
        iv_certificaciones TYPE i.

    METHODS modificacion
      IMPORTING
                iv_nombre          TYPE zde_nombre_10
                iv_apellido        TYPE zde_nombre_10
                iv_telefono        TYPE zde_tele_10
                iv_experiencia     TYPE i
                iv_id_empleado     TYPE i
                iv_certificaciones TYPE i
      RETURNING VALUE(rv_mensaje)  TYPE string.

    METHODS alta_empleado RETURNING VALUE(rv_mensaje) TYPE string.

    METHODS calcular_sueldo.

    METHODS ex_id_empleado.

    METHODS traer_n_filas
      IMPORTING iv_n_filas      TYPE i
      RETURNING VALUE(rv_tabla) TYPE tty_emp.

    METHODS traer_lt
      IMPORTING iv_id_empleado  TYPE i
      RETURNING VALUE(rv_tabla) TYPE tty_emp.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA lt_registro TYPE tty_emp.
    DATA ls_prueba TYPE ztab_eje_obj_10.
    DATA experiencia TYPE i.
    DATA id_empleado TYPE i.
    DATA certificaciones TYPE i.
    DATA iv_nombre TYPE string.

ENDCLASS.

CLASS lcl_creadora IMPLEMENTATION.

  METHOD constructor.
    me->ls_prueba-nombre = iv_nombre.
    me->ls_prueba-apellido = iv_apellido.
    me->ls_prueba-telefono = iv_telefono.

    me->experiencia = iv_experiencia.
    me->certificaciones = iv_certificaciones.

    me->ls_prueba-currency_code = 'EUR'.

  ENDMETHOD.

  METHOD modificacion.
    me->ls_prueba-nombre = iv_nombre.
    me->ls_prueba-apellido = iv_apellido.
    me->ls_prueba-telefono = iv_telefono.

    me->experiencia = iv_experiencia.
    me->certificaciones = iv_certificaciones.

    me->ls_prueba-currency_code = 'EUR'.
    me->ls_prueba-id_empleado = iv_id_empleado.

    SELECT SINGLE @abap_true FROM ztab_eje_obj_10
    WHERE id_empleado = @me->id_empleado
    INTO @DATA(id_exists).

    IF sy-subrc = 0.
      alta_empleado(  ).
    ELSE.
      rv_mensaje = 'El ID no existe en la base de datos, no se ha podido hacer la modificación '.
    ENDIF.

  ENDMETHOD.

  METHOD alta_empleado.
    calcular_sueldo( ).

    IF id_empleado IS NOT INITIAL.
      ls_prueba-id_empleado = id_empleado.
    ELSE.
      ex_id_empleado( ).
    ENDIF.

    MODIFY ztab_eje_obj_10 FROM @ls_prueba.

    IF sy-subrc = 0.
      COMMIT WORK.
      rv_mensaje = 'Subida correcta'.
    ELSE.
      rv_mensaje = 'Error en la subida '.
    ENDIF.

  ENDMETHOD.

  METHOD calcular_sueldo.
    ls_prueba-sueldo = ( certificaciones * 50 + experiencia * 100 ) + 1000.
  ENDMETHOD.

  METHOD ex_id_empleado.
    SELECT MAX( id_empleado )
    FROM ztab_eje_obj_10
    INTO @DATA(max_id_empleado).

    IF sy-subrc = 0.
      ls_prueba-id_empleado = max_id_empleado + 1.
    ELSE.
      ls_prueba-id_empleado = 1.
    ENDIF.

  ENDMETHOD.

  METHOD traer_lt.
    me->id_empleado = iv_id_empleado.

    IF me->id_empleado = 0.
      SELECT *
*        FROM @lt_registro AS registros
      FROM ztab_eje_obj_10 AS registros
      ORDER BY id_empleado
      INTO TABLE @rv_tabla.
    ELSE.
      SELECT *
*      FROM @lt_registro AS registros
      FROM ztab_eje_obj_10 AS registros
      WHERE id_empleado = @me->id_empleado
      ORDER BY id_empleado
      INTO TABLE @rv_tabla.
    ENDIF.

  ENDMETHOD.

  METHOD traer_n_filas.

    SELECT *
*    FROM @lt_registro AS registros
    FROM ztab_eje_obj_10 AS registros
    ORDER BY id_empleado
    INTO TABLE @rv_tabla
    UP TO @iv_n_filas ROWS.

  ENDMETHOD.

ENDCLASS.

