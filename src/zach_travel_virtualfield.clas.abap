CLASS zach_travel_virtualfield DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_sadl_exit_filter_transform.
    INTERFACES if_sadl_exit_sort_transform.

  PRIVATE SECTION.
    TYPES ty_travel_data TYPE zach_c_traveltp.

    TYPES tt_travel_data TYPE STANDARD TABLE OF ty_travel_data.

    DATA lv_entity TYPE string.

    METHODS _calc_travel
      IMPORTING it_travel                TYPE tt_travel_data
                it_request_calc_elements TYPE if_sadl_exit_calc_element_read=>tt_elements
      CHANGING  ct_calculated_data       TYPE STANDARD TABLE.

ENDCLASS.


CLASS zach_travel_virtualfield IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    CASE lv_entity.

      WHEN 'ZACH_C_TRAVELTP'.
        _calc_travel( EXPORTING it_travel                = CORRESPONDING #( it_original_data )
                                it_request_calc_elements = it_requested_calc_elements
                      CHANGING  ct_calculated_data       = ct_calculated_data ).

    ENDCASE.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    DATA lv_user TYPE string VALUE 'CREATEDBY'.
    DATA lv_date TYPE string VALUE 'BEGINDATE'.

    lv_entity = iv_entity.

    CASE lv_entity.
      WHEN 'ZACH_C_TRAVELTP'.
        INSERT lv_user INTO TABLE et_requested_orig_elements.
        INSERT lv_date INTO TABLE et_requested_orig_elements.
    ENDCASE.
  ENDMETHOD.

  METHOD if_sadl_exit_filter_transform~map_atom.
    DATA(lo_cfac) = cl_sadl_cond_prov_factory_pub=>create_simple_cond_factory( ).
    DATA(lo_element_date) = lo_cfac->element( 'BEGINDATE' ).
    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).

    lv_date += iv_value.

    CASE iv_element.
      WHEN 'DAYSTOFLIGHT'.
        ro_condition = COND #(
        WHEN iv_operator = if_sadl_exit_filter_transform~co_operator-equals THEN
          lo_element_date->equals( lv_date )
        WHEN iv_operator = if_sadl_exit_filter_transform~co_operator-less_than THEN
          lo_element_date->less_than( lv_date )
        WHEN iv_operator = if_sadl_exit_filter_transform~co_operator-greater_than THEN
          lo_element_date->greater_than( lv_date ) ).

    ENDCASE.
  ENDMETHOD.

  METHOD if_sadl_exit_sort_transform~map_element.
    IF iv_element = 'DAYSTOFLIGHT'.
      APPEND VALUE #( name = 'BEGINDATE' ) TO et_sort_elements.
    ENDIF.
  ENDMETHOD.

  METHOD _calc_travel.
    " TODO: parameter IT_REQUEST_CALC_ELEMENTS is never used (ABAP cleaner)

    DATA ls_travel_data LIKE LINE OF it_travel.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).

    LOOP AT it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      ASSIGN ct_calculated_data[ sy-tabix ] TO FIELD-SYMBOL(<ls_calculated_data>).
      IF <ls_travel>-Createdby = sy-uname.
        ls_travel_data-ismytravel = 'X'.
      ENDIF.

      ls_travel_data-DaysToFlight = <ls_travel>-begindate - lv_date.

      <ls_calculated_data> = CORRESPONDING #( ls_travel_data ).

      CLEAR ls_travel_data.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
