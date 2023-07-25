CLASS zcl_vmd_remarks DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.

    CLASS-METHODS: create_instance IMPORTING i_extension_id   TYPE guid_32
                                             i_data           TYPE REF TO cvis_ei_cvi_rem
                                   RETURNING VALUE(r_remarks) TYPE REF TO zcl_vmd_remarks.

    METHODS add_remark
      IMPORTING
        VALUE(i_remark)       TYPE ad_remark1
        VALUE(i_language)     TYPE spras DEFAULT sy-langu
        VALUE(i_language_iso) TYPE spras_iso OPTIONAL .
    METHODS delete_remark
      IMPORTING
        VALUE(i_remark)       TYPE ad_remark1
        VALUE(i_language)     TYPE spras OPTIONAL
        VALUE(i_language_iso) TYPE spras_iso OPTIONAL .
    METHODS change_remark
      IMPORTING
        VALUE(i_remark)       TYPE ad_remark1
        VALUE(i_language)     TYPE spras DEFAULT sy-langu
        VALUE(i_language_iso) TYPE spras_iso OPTIONAL .
  PROTECTED SECTION.
    DATA: ref_data TYPE REF TO cvis_ei_cvi_rem.
    METHODS constructor
      IMPORTING
        !i_data TYPE REF TO cvis_ei_cvi_rem .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VMD_REMARKS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_REMARKS->ADD_REMARK
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_REMARK                       TYPE        AD_REMARK1
* | [--->] I_LANGUAGE                     TYPE        SPRAS (default =SY-LANGU)
* | [--->] I_LANGUAGE_ISO                 TYPE        SPRAS_ISO(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_remark.
    DATA: ls_remark LIKE LINE OF ref_data->remarks[].
    FIELD-SYMBOLS: <rem> LIKE LINE OF ref_data->remarks[].
    IF i_language_iso IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu_iso = i_language_iso.
*      ASSIGN ref_data->remarks[ data-langu_iso = i_language_iso ] TO <rem>.
    ELSEIF i_language IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu = i_language.
*      ASSIGN ref_data->remarks[ data-langu = i_language ] TO <rem>.
    ENDIF.
    IF <rem> IS NOT ASSIGNED.
      IF i_language_iso IS NOT INITIAL.
        CLEAR: ls_remark.
        ls_remark-task           = zcl_vmd_util=>mode-create.
        ls_remark-data-langu_iso = i_language_iso.
        ls_remark-data-adr_notes = i_remark.
        INSERT ls_remark INTO TABLE ref_data->remarks.
*        INSERT VALUE #( task = zcl_vmd_util=>mode-create data-langu_iso = i_language_iso  data-adr_notes = i_remark ) INTO TABLE ref_data->remarks.
      ELSEIF i_language IS NOT INITIAL.
        CLEAR: ls_remark.
        ls_remark-task           = zcl_vmd_util=>mode-create.
        ls_remark-data-langu     = i_language.
        ls_remark-data-adr_notes = i_remark.
        INSERT ls_remark INTO TABLE ref_data->remarks.
*        INSERT VALUE #( task = zcl_vmd_util=>mode-create data-langu = i_language  data-adr_notes = i_remark ) INTO TABLE ref_data->remarks.
      ENDIF.
    ELSE.
      change_remark(
        EXPORTING
          i_remark       = i_remark
          i_language     = i_language
          i_language_iso = i_language_iso
      ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_REMARKS->CHANGE_REMARK
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_REMARK                       TYPE        AD_REMARK1
* | [--->] I_LANGUAGE                     TYPE        SPRAS (default =SY-LANGU)
* | [--->] I_LANGUAGE_ISO                 TYPE        SPRAS_ISO(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_remark.
    FIELD-SYMBOLS: <rem> LIKE LINE OF ref_data->remarks[].
    IF i_language_iso IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu_iso = i_language_iso.
*      ASSIGN ref_data->remarks[ data-langu_iso = i_language_iso ] TO FIELD-SYMBOL(<rem>).
    ELSEIF i_language IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu = i_language.
*      ASSIGN ref_data->remarks[ data-langu = i_language ] TO <rem>.
    ENDIF.
    IF <rem> IS NOT ASSIGNED AND ( i_language_iso IS NOT INITIAL OR i_language IS NOT INITIAL ).
      INSERT INITIAL LINE INTO TABLE ref_data->remarks ASSIGNING <rem>.
      IF sy-subrc EQ 0.
        IF i_language_iso IS NOT INITIAL.
          <rem>-data-langu_iso = i_language_iso.
        ELSEIF i_language IS NOT INITIAL.
          <rem>-data-langu = i_language.
        ENDIF.
      ENDIF.
    ENDIF.
    IF <rem> IS ASSIGNED.
      <rem>-task = zcl_vmd_util=>mode-change.
      <rem>-data-adr_notes = i_remark.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_REMARKS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_DATA                         TYPE REF TO CVIS_EI_CVI_REM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    ref_data = i_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_REMARKS=>CREATE_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_EXTENSION_ID                 TYPE        GUID_32
* | [--->] I_DATA                         TYPE REF TO CVIS_EI_CVI_REM
* | [<-()] R_REMARKS                      TYPE REF TO ZCL_VMD_REMARKS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_instance.
    IF i_extension_id IS INITIAL.
      CREATE OBJECT r_remarks EXPORTING i_data = i_data.
*      r_remarks = NEW #( i_data = i_data ).
    ELSE.
      DATA: subclass TYPE REF TO object.
      TRY.
          DATA: sublcass_abs_name TYPE abap_abstypename.
          sublcass_abs_name = zcl_vmd_extensions=>get_extension_class_abs_name( id = i_extension_id type = zcl_vmd_extensions=>class_extension-remarks ).
*          DATA(sublcass_abs_name) = zcl_vmd_extensions=>get_extension_class_abs_name( id = i_extension_id type = zcl_vmd_extensions=>class_extension-remarks ).
          CREATE OBJECT subclass TYPE (sublcass_abs_name)
           EXPORTING
            i_data       = i_data.
          r_remarks ?= subclass.
        CATCH zcx_vmd_no_extension.
          CREATE OBJECT r_remarks EXPORTING i_data = i_data.
*          r_remarks = NEW #( i_data = i_data ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_REMARKS->DELETE_REMARK
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_REMARK                       TYPE        AD_REMARK1
* | [--->] I_LANGUAGE                     TYPE        SPRAS(optional)
* | [--->] I_LANGUAGE_ISO                 TYPE        SPRAS_ISO(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_remark.
    FIELD-SYMBOLS: <rem> LIKE LINE OF ref_data->remarks[].
    IF i_language_iso IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu_iso = i_language_iso.
*      ASSIGN ref_data->remarks[ data-langu_iso = i_language_iso ] TO FIELD-SYMBOL(<rem>).
    ELSEIF i_language IS NOT INITIAL.
      READ TABLE ref_data->remarks ASSIGNING <rem> WITH KEY data-langu = i_language.
*      ASSIGN ref_data->remarks[ data-langu = i_language ] TO <rem>.
    ENDIF.
    IF <rem> IS  ASSIGNED.
      <rem>-task = zcl_vmd_util=>mode-delete.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
