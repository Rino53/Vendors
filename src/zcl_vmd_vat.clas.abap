CLASS zcl_vmd_vat DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    CLASS-METHODS: create_instance IMPORTING i_extension_id TYPE guid_32
                                             i_vat          TYPE REF TO cvis_ei_vat_numbers
                                   RETURNING VALUE(r_vat)   TYPE REF TO zcl_vmd_vat.

    METHODS add_vat_number
      IMPORTING
        VALUE(i_country) TYPE land1_gp
        VALUE(i_vat_no)  TYPE stceg
      RAISING
        zcx_vmd_vendor .
    METHODS change_vat_number
      IMPORTING
        VALUE(i_country) TYPE land1_gp
        VALUE(i_vat_no)  TYPE stceg
      RAISING
        zcx_vmd_vendor .
    METHODS delete_vat_number
      IMPORTING
        VALUE(i_country) TYPE land1_gp
      RAISING
        zcx_vmd_vendor .
    METHODS get_vat_number
      IMPORTING
        VALUE(i_country) TYPE land1_gp
      RETURNING
        VALUE(r_vat_no)  TYPE stceg
      RAISING
        zcx_vmd_vendor .
  PROTECTED SECTION.
    DATA: ref_data TYPE REF TO cvis_ei_vat_numbers.
    METHODS constructor IMPORTING i_vat TYPE REF TO cvis_ei_vat_numbers.
    METHODS raise_message IMPORTING VALUE(msgid) TYPE scx_t100key-msgid OPTIONAL
                                    VALUE(msgno) TYPE scx_t100key-msgno OPTIONAL
                                    VALUE(attr1) TYPE CLIKE OPTIONAL
                                    VALUE(attr2) TYPE CLIKE OPTIONAL
                                    VALUE(attr3) TYPE CLIKE OPTIONAL
                                    VALUE(attr4) TYPE CLIKE OPTIONAL.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VMD_VAT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VAT->ADD_VAT_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COUNTRY                      TYPE        LAND1_GP
* | [--->] I_VAT_NO                       TYPE        STCEG
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_vat_number.
    FIELD-SYMBOLS: <vat> LIKE LINE OF ref_data->vat_numbers.
    READ TABLE ref_data->vat_numbers WITH KEY data_key-land1 = i_country ASSIGNING <vat>.
*    ASSIGN ref_data->vat_numbers[ data_key-land1 = i_country ] TO FIELD-SYMBOL(<vat>).
    IF sy-subrc NE 0.
      APPEND INITIAL LINE TO ref_data->vat_numbers ASSIGNING <vat>.
      <vat>-task           = zcl_vmd_util=>mode-create.
      <vat>-data_key-land1 = i_country.
      <vat>-data-stceg     = i_vat_no.
*      INSERT VALUE #( task = zcl_vmd_util=>mode-create
*                      data_key-land1 = i_country
*                      data-stceg = i_vat_no
*                    ) INTO TABLE ref_data->vat_numbers.
    ELSE.
      raise_message( msgno = '010' attr1 = i_country ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VAT->CHANGE_VAT_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COUNTRY                      TYPE        LAND1_GP
* | [--->] I_VAT_NO                       TYPE        STCEG
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_vat_number.
    FIELD-SYMBOLS: <vat> LIKE LINE OF ref_data->vat_numbers.
    READ TABLE ref_data->vat_numbers WITH KEY data_key-land1 = i_country ASSIGNING <vat>.
*    ASSIGN ref_data->vat_numbers[ data_key-land1 = i_country ] TO FIELD-SYMBOL(<vat>).
    IF sy-subrc EQ 0.
      <vat>-task = zcl_vmd_util=>mode-change.
      <vat>-data-stceg = i_vat_no.
    ELSE.
      raise_message( msgno = '009' attr1 = i_country ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_VAT->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VAT                          TYPE REF TO CVIS_EI_VAT_NUMBERS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    ref_data = i_vat.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_VAT=>CREATE_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_EXTENSION_ID                 TYPE        GUID_32
* | [--->] I_VAT                          TYPE REF TO CVIS_EI_VAT_NUMBERS
* | [<-()] R_VAT                          TYPE REF TO ZCL_VMD_VAT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_instance.
    IF i_extension_id IS INITIAL.
      CREATE OBJECT r_vat EXPORTING i_vat = i_vat.
*      r_vat = NEW #( i_vat = i_vat ).
    ELSE.
      DATA: subclass TYPE REF TO object.
      TRY.
        DATA: sublcass_abs_name TYPE ABAP_ABSTYPENAME.
        sublcass_abs_name = zcl_vmd_extensions=>get_extension_class_abs_name( id = i_extension_id type = zcl_vmd_extensions=>class_extension-vat ).
        CREATE OBJECT subclass TYPE (sublcass_abs_name)
         EXPORTING
          i_vat       = i_vat.
        r_vat ?= subclass.
        CATCH zcx_vmd_no_extension.
          CREATE OBJECT r_vat EXPORTING i_vat = i_vat.
*          r_vat = NEW #( i_vat = i_vat ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VAT->DELETE_VAT_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COUNTRY                      TYPE        LAND1_GP
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_vat_number.
    FIELD-SYMBOLS: <vat> LIKE LINE OF ref_data->vat_numbers.
    READ TABLE ref_data->vat_numbers WITH KEY data_key-land1 = i_country ASSIGNING <vat>.
*    ASSIGN ref_data->vat_numbers[ data_key-land1 = i_country ] TO FIELD-SYMBOL(<vat>).
    IF sy-subrc EQ 0.
      <vat>-task = zcl_vmd_util=>mode-delete.
    ELSE.
      raise_message( msgno = '009' attr1 = i_country ).
*      RAISE EXCEPTION TYPE zcx_vmd_vendor
*        EXPORTING
*          no = 009
*          v1 = CONV #( i_country ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VAT->GET_VAT_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COUNTRY                      TYPE        LAND1_GP
* | [<-()] R_VAT_NO                       TYPE        STCEG
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_vat_number.
    FIELD-SYMBOLS: <vat> LIKE LINE OF ref_data->vat_numbers.
    READ TABLE ref_data->vat_numbers WITH KEY data_key-land1 = i_country ASSIGNING <vat>.
*    ASSIGN ref_data->vat_numbers[ data_key-land1 = i_country ] TO FIELD-SYMBOL(<vat>).
    IF sy-subrc EQ 0.
      r_vat_no = <vat>-data-stceg.
    ELSE.
      raise_message( msgno = '009' attr1 = i_country ).
*      RAISE EXCEPTION TYPE zcx_vmd_vendor
*        EXPORTING
*          no = 009
*          v1 = CONV #( i_country ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_VAT->RAISE_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] MSGID                          TYPE        SCX_T100KEY-MSGID(optional)
* | [--->] MSGNO                          TYPE        SCX_T100KEY-MSGNO(optional)
* | [--->] ATTR1                          TYPE        CLIKE(optional)
* | [--->] ATTR2                          TYPE        CLIKE(optional)
* | [--->] ATTR3                          TYPE        CLIKE(optional)
* | [--->] ATTR4                          TYPE        CLIKE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD raise_message.
    DATA: ls_t100key TYPE scx_t100key.
    ls_t100key-msgid = msgid.
    ls_t100key-msgno = msgno.
    ls_t100key-attr1 = attr1.
    ls_t100key-attr2 = attr2.
    ls_t100key-attr3 = attr3.
    ls_t100key-attr4 = attr4.
    RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
  ENDMETHOD.
ENDCLASS.
