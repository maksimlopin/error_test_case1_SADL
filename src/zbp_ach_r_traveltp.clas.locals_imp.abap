CLASS lhc_ZACH_R_TRAVELTP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF travel_status,
        open     TYPE c LENGTH 1  VALUE 'O',
        accepted TYPE c LENGTH 1  VALUE 'A',
        canceled TYPE c LENGTH 1  VALUE 'X',
      END OF travel_status.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR zach_r_traveltp RESULT result.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.
    METHODS validateCustomerId FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validateCustomerId.

    METHODS setInitialStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~setInitialStatus.
    METHODS calcTravelID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~calcTravelID.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.
    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.




ENDCLASS.

CLASS lhc_ZACH_R_TRAVELTP IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD validatedates.

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
        ENTITY Travel
        FIELDS ( Begindate Enddate Travelid ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_dates).

    LOOP AT lt_dates INTO DATA(ls_dates).

      IF ls_dates-Begindate < sy-datum.
        APPEND VALUE #( %tky = ls_dates-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = ls_dates-%tky
                        %msg = new_message(
                            id = 'ZLX_TRAVEL'
                            number = '3'
                            v1 = ls_dates-Begindate
                            severity = if_abap_behv_message=>severity-error ) ) TO reported-travel.

      ELSEIF ls_dates-Enddate < ls_dates-Begindate.
        APPEND VALUE #( %tky = ls_dates-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = ls_dates-%tky
                        %msg = new_message(
                            id = 'ZLX_TRAVEL'
                            number = '2'
                            v1 = ls_dates-Begindate
                            v2 = ls_dates-Enddate
                            v3 = ls_dates-Travelid
                            severity = if_abap_behv_message=>severity-error ) ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateCustomerId.
    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
            ENTITY Travel
            FIELDS ( Customerid ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_customer).

    IF lt_customer IS NOT INITIAL.

      SELECT Customerid FROM zlxcustomer
      FOR ALL ENTRIES IN @lt_customer
      WHERE Customerid = @lt_customer-Customerid
      INTO TABLE @DATA(lt_customer_db).

    ENDIF.

    LOOP AT lt_customer INTO DATA(ls_customer).
      IF ls_customer-Customerid IS INITIAL OR NOT line_exists( lt_customer_db[ customerid = ls_customer-Customerid ] ).
        APPEND VALUE #( %tky = ls_customer-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = ls_customer-%tky
                        %msg = new_message(
                            id = 'ZLX_TRAVEL'
                            number = '1'
                            v1 = ls_customer-Customerid
                            severity = if_abap_behv_message=>severity-error ) ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD setInitialStatus.

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
        ENTITY Travel
        FIELDS ( Overallstatus ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_status).

    DELETE lt_status WHERE Overallstatus IS NOT INITIAL.
    CHECK lt_status IS NOT INITIAL.

    MODIFY ENTITIES OF zach_r_traveltp IN LOCAL MODE
        ENTITY Travel
        UPDATE FROM VALUE #( FOR ls_status IN lt_status ( %key-Traveluuid = ls_status-Traveluuid
                                                          Overallstatus = travel_status-open
                                                          %control-Overallstatus = if_abap_behv=>mk-on ) )

    MAPPED DATA(lt_mapped)
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

  ENDMETHOD.

  METHOD calcTravelID.

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
          ENTITY Travel
          FIELDS ( Travelid ) WITH CORRESPONDING #( keys )
          RESULT DATA(lt_travelid).

    DELETE lt_travelid WHERE Travelid IS NOT INITIAL.

    IF lt_travelid IS NOT INITIAL.

      SELECT SINGLE FROM zlxtravel
             FIELDS MAX( travelid ) AS TravelID
             INTO @DATA(max_travelid).

      MODIFY ENTITIES OF zach_r_traveltp IN LOCAL MODE
      ENTITY Travel
      UPDATE FROM VALUE #( FOR ls_travelid IN lt_travelid ( %key-Traveluuid = ls_travelid-Traveluuid
                                                               Travelid = max_travelid + 1
                                                               %control-Travelid = if_abap_behv=>mk-on ) )

     MAPPED DATA(lt_mapped)
     REPORTED DATA(lt_reported)
     FAILED DATA(lt_failed).

    ENDIF.

  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zach_r_traveltp IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( Overallstatus ) WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                                                        Overallstatus = travel_status-accepted ) )
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
          ENTITY Travel
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky %param = ls_result ) ).


  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF zach_r_traveltp IN LOCAL MODE
      ENTITY Travel
      UPDATE FIELDS ( Overallstatus ) WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                                                          Overallstatus = travel_status-canceled ) )
      REPORTED DATA(lt_reported)
      FAILED DATA(lt_failed).

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
          ENTITY Travel
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zach_r_traveltp IN LOCAL MODE
            ENTITY Travel
            FIELDS ( Overallstatus ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result)
            FAILED DATA(lt_failed)
            REPORTED DATA(lt_reported).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
    %action-acceptTravel = COND #( WHEN ls_result-OverallStatus = travel_status-accepted THEN if_abap_behv=>fc-o-disabled
                                                                                         ELSE if_abap_behv=>fc-o-enabled )
    %action-rejectTravel = COND #( WHEN ls_result-OverallStatus = travel_status-canceled THEN if_abap_behv=>fc-o-disabled
                                                                                         ELSE if_abap_behv=>fc-o-enabled )
    ) ).

  ENDMETHOD.

ENDCLASS.
