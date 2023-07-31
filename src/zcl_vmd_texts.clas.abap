CLASS zcl_vmd_texts DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.

    CLASS-METHODS create_instance
      IMPORTING
        !i_texts        TYPE REF TO cvis_ei_cvis_text
        !i_extension_id TYPE guid_32
      RETURNING
        VALUE(r_texts)  TYPE REF TO zcl_vmd_texts .
    METHODS add_text
      IMPORTING
        VALUE(i_id)       TYPE tdid
        VALUE(i_language) TYPE spras
        VALUE(i_text)     TYPE tline_tab
      RAISING
        zcx_vmd_vendor .
    METHODS change_text
      IMPORTING
        VALUE(i_id)       TYPE tdid
        VALUE(i_language) TYPE spras
        VALUE(i_text)     TYPE tline_tab
      RAISING
        zcx_vmd_vendor .
    METHODS delete_text
      IMPORTING
        VALUE(i_id)       TYPE tdid
        VALUE(i_language) TYPE spras
      RAISING
        zcx_vmd_vendor .
    METHODS get_text
      IMPORTING
        VALUE(i_id)       TYPE tdid
        VALUE(i_language) TYPE spras
      RETURNING
        VALUE(r_text)     TYPE tline_tab
      RAISING
        zcx_vmd_vendor .
  PROTECTED SECTION.
    DATA: ref_data TYPE REF TO cvis_ei_cvis_text.
    METHODS constructor
      IMPORTING
        !i_texts TYPE REF TO cvis_ei_cvis_text .

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VMD_TEXTS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_TEXTS->ADD_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ID                           TYPE        TDID
* | [--->] I_LANGUAGE                     TYPE        SPRAS
* | [--->] I_TEXT                         TYPE        TLINE_TAB
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_text.
    DATA: ls_ref_data LIKE LINE OF ref_data->texts.
    FIELD-SYMBOLS: <tx> LIKE LINE OF ref_data->texts[].
    READ TABLE ref_data->texts ASSIGNING <tx> WITH KEY data_key-text_id = i_id data_key-langu = i_language.
*    ASSIGN ref_data->texts[ data_key-text_id = i_id data_key-langu = i_language ] TO FIELD-SYMBOL(<tx>).
    IF sy-subrc NE 0.
      CLEAR: ls_ref_data.
      ls_ref_data-data_key-text_id = i_id.
      ls_ref_data-data_key-langu = i_language.
      ls_ref_data-data = i_text.
      ls_ref_data-task = zcl_vmd_util=>mode-create.
      INSERT ls_ref_data INTO TABLE ref_data->texts.
*      INSERT VALUE #( data_key-text_id = i_id
*                      data_key-langu = i_language
*                      data = i_text
*                      task = zcl_vmd_util=>mode-create
*                    ) INTO TABLE ref_data->texts.
    ELSE.
      DATA: ls_t100key TYPE SCX_T100KEY.
      ls_t100key-msgno = '007'.
      ls_t100key-attr1 = i_id.
      RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
*          no = 007
*          v1 = CONV #( i_id ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_TEXTS->CHANGE_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ID                           TYPE        TDID
* | [--->] I_LANGUAGE                     TYPE        SPRAS
* | [--->] I_TEXT                         TYPE        TLINE_TAB
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_text.
    FIELD-SYMBOLS: <tx> LIKE LINE OF ref_data->texts[].
    READ TABLE ref_data->texts ASSIGNING <tx> WITH KEY data_key-text_id = i_id data_key-langu = i_language.
*    ASSIGN ref_data->texts[ data_key-text_id = i_id data_key-langu = i_language ] TO FIELD-SYMBOL(<tx>).
    IF sy-subrc EQ 0.
      <tx>-task = zcl_vmd_util=>mode-change.
      <tx>-data = i_text.
    ELSE.
      DATA: ls_t100key TYPE SCX_T100KEY.
      ls_t100key-msgno = '008'.
      ls_t100key-attr1 = i_id.
      RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
*          no = 008
*          v1 = CONV #( i_id ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_TEXTS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TEXTS                        TYPE REF TO CVIS_EI_CVIS_TEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    CHECK i_texts IS NOT INITIAL.
    ref_data = i_texts.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_TEXTS=>CREATE_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TEXTS                        TYPE REF TO CVIS_EI_CVIS_TEXT
* | [--->] I_EXTENSION_ID                 TYPE        GUID_32
* | [<-()] R_TEXTS                        TYPE REF TO ZCL_VMD_TEXTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_instance.
    IF i_extension_id IS INITIAL.
      CREATE OBJECT r_texts EXPORTING i_texts = i_texts.
*      r_texts = NEW #( i_texts = i_texts ).
    ELSE.
      DATA: subclass TYPE REF TO object.
      TRY.
          DATA: sublcass_abs_name TYPE abap_abstypename.
          sublcass_abs_name = zcl_vmd_extensions=>get_extension_class_abs_name( id = i_extension_id type = zcl_vmd_extensions=>class_extension-texts ).
          CREATE OBJECT subclass TYPE (sublcass_abs_name)
           EXPORTING
            i_texts       = i_texts.
          r_texts ?= subclass.
        CATCH zcx_vmd_no_extension.
          CREATE OBJECT r_texts EXPORTING i_texts = i_texts.
*          r_texts = NEW #( i_texts = i_texts ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_TEXTS->DELETE_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ID                           TYPE        TDID
* | [--->] I_LANGUAGE                     TYPE        SPRAS
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_text.
    FIELD-SYMBOLS: <tx> LIKE LINE OF ref_data->texts[].
    READ TABLE ref_data->texts ASSIGNING <tx> WITH KEY data_key-text_id = i_id data_key-langu = i_language.
*    ASSIGN ref_data->texts[ data_key-text_id = i_id data_key-langu = i_language ] TO FIELD-SYMBOL(<tx>).
    IF sy-subrc EQ 0.
      <tx>-task = zcl_vmd_util=>mode-delete.
    ELSE.
      DATA: ls_t100key TYPE scx_t100key.
      ls_t100key-msgno = '008'.
      ls_t100key-attr1 = i_id.
      RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
*          no = 008
*          v1 = CONV #( i_id ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_TEXTS->GET_TEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ID                           TYPE        TDID
* | [--->] I_LANGUAGE                     TYPE        SPRAS
* | [<-()] R_TEXT                         TYPE        TLINE_TAB
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_text.
    FIELD-SYMBOLS: <tx> LIKE LINE OF ref_data->texts[].
    READ TABLE ref_data->texts ASSIGNING <tx> WITH KEY data_key-text_id = i_id data_key-langu = i_language.
*    ASSIGN ref_data->texts[ data_key-text_id = i_id data_key-langu = i_language ] TO FIELD-SYMBOL(<tx>).
    IF sy-subrc EQ 0.
      r_text = <tx>-data.
    ELSE.
      DATA: ls_t100key TYPE SCX_T100KEY.
      ls_t100key-msgno = '008'.
      ls_t100key-attr1 = i_id.
      RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
*          no = 008
*          v1 = CONV #( i_id ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
