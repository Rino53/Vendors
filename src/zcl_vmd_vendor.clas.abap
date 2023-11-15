class ZCL_VMD_VENDOR definition
* SUPPORTS <7.4 *
  public
  create public .

public section.
*"* public components of class ZCL_VMD_VENDOR
*"* do not include other source files here!!!

  data VENDOR type LFA1-LIFNR read-only .
  data MODE type ZCL_VMD_UTIL=>T_MODE .
  data CENTRAL type ref to ZCL_VMD_CENTRAL .
  data ADDRESS type ref to ZCL_VMD_ADDRESS .
  data VAT type ref to ZCL_VMD_VAT .
  data TEXTS type ref to ZCL_VMD_TEXTS .
  data EXTENSION_ID type GUID_32 read-only .
  data ZLOG type ref to ZCL_API_LOG .

  methods CONSTRUCTOR
    importing
      value(I_VENDOR) type LFA1-LIFNR optional
      value(I_EXTENSION_CLASSES) type ZCL_VMD_EXTENSIONS=>TT_EXTENSION_CLASSES optional
      value(I_LOGID) type CLIKE optional
    raising
      ZCX_VMD_VENDOR .
  type-pools ABAP .
  methods GET_DATA
    importing
      !I_REREAD_DB type ABAP_BOOL default ABAP_TRUE
    returning
      value(R_MASTER_DATA) type VMDS_EI_EXTERN
    raising
      ZCX_VMD_VENDOR .
  methods SAVE
    importing
      !I_TEST_RUN type ABAP_BOOL default ABAP_FALSE
      !I_WAIT_AFTER_COMMIT type ABAP_BOOL default ABAP_FALSE
    exporting
      !E_VENDOR type LFA1-LIFNR
      !R_MASTER_DATA type VMDS_EI_EXTERN
    raising
      ZCX_VMD_VENDOR .
  class-methods UPDATE_MASTER_DATA
    importing
      !IS_OLD type ANY
    changing
      !CS_NEW type ANY .
  methods SET_MASTER_DATA
    importing
      !I_MASTER_DATA type VMDS_EI_EXTERN .
  methods ADD_NEW_CONTACT
    returning
      value(R_CONTACT) type ref to ZCL_VMD_CONTACT .
  methods CHANGE_CONTACT
    importing
      value(I_CONTACT) type KNVP-PARNR
    returning
      value(R_CONTACT) type ref to ZCL_VMD_CONTACT
    raising
      ZCX_VMD_VENDOR .
  methods GET_CONTACT
    importing
      value(I_CONTACT) type KNVP-PARNR
    returning
      value(R_CONTACT) type ref to ZCL_VMD_CONTACT
    raising
      ZCX_VMD_VENDOR .
  methods GET_CONTACT_BY_NAME
    importing
      value(I_FIRSTNAME) type BAPIAD3VL-FIRSTNAME
      value(I_LASTNAME) type BAPIAD3VL-LASTNAME
    returning
      value(R_CONTACT) type ref to ZCL_VMD_CONTACT
    raising
      ZCX_VMD_VENDOR .
  methods DELETE_CONTACT
    importing
      value(I_CONTACT) type KNVP-PARNR
      value(I_RAISE_ERROR) type ABAP_BOOL default ABAP_FALSE
    returning
      value(R_CONTACT) type ref to ZCL_VMD_CONTACT
    raising
      ZCX_VMD_VENDOR .
  methods CHANGE_PURCHASING_ORG
    importing
      value(I_PURCHASING_ORG) type EKORG
    returning
      value(R_PURCHASING) type ref to ZCL_VMD_PURCHASING
    raising
      ZCX_VMD_VENDOR .
  methods CREATE_PURCHASING_ORG
    importing
      value(I_PURCHASING_ORG) type EKORG
    returning
      value(R_PURCHASING) type ref to ZCL_VMD_PURCHASING
    raising
      ZCX_VMD_VENDOR .
  methods DELETE_PURCHASING_ORG
    importing
      value(I_PURCHASING_ORG) type EKORG
    returning
      value(R_PURCHASING) type ref to ZCL_VMD_PURCHASING
    raising
      ZCX_VMD_VENDOR .
  methods GET_PURCHASING_ORG
    importing
      value(I_PURCHASING_ORG) type EKORG
    returning
      value(R_PURCHASING) type ref to ZCL_VMD_PURCHASING
    raising
      ZCX_VMD_VENDOR .
  methods CHANGE_COMPANY
    importing
      value(I_COMPANY_CODE) type BUKRS
    returning
      value(R_COMPANY) type ref to ZCL_VMD_COMPANY
    raising
      ZCX_VMD_VENDOR .
  methods CREATE_COMPANY
    importing
      value(I_COMPANY_CODE) type BUKRS
    returning
      value(R_COMPANY) type ref to ZCL_VMD_COMPANY
    raising
      ZCX_VMD_VENDOR .
  methods DELETE_COMPANY
    importing
      value(I_COMPANY_CODE) type BUKRS
    returning
      value(R_COMPANY) type ref to ZCL_VMD_COMPANY
    raising
      ZCX_VMD_VENDOR .
  methods GET_COMPANY
    importing
      value(I_COMPANY_CODE) type BUKRS
    returning
      value(R_COMPANY) type ref to ZCL_VMD_COMPANY
    raising
      ZCX_VMD_VENDOR .
  class-methods DESCRIBE_STRUCT
    importing
      !IS_STRUCT type ANY
    changing
      !CT_LIST type SRT_STRINGS optional .
protected section.
*"* protected components of class ZCL_VMD_VENDOR
*"* do not include other source files here!!!

  data MASTER_DATA type VMDS_EI_EXTERN .
  data ORIGINAL_DATA type VMDS_EI_EXTERN .

  methods LOCK
    raising
      ZCX_VMD_VENDOR .
  methods UNLOCK
    raising
      ZCX_VMD_VENDOR .
  methods RAISE_MESSAGE
    importing
      value(MSGID) type SCX_T100KEY-MSGID default 'Z_VMD_VENDORS'
      value(MSGNO) type SCX_T100KEY-MSGNO default '999'
      value(ATTR1) type CLIKE optional
      value(ATTR2) type CLIKE optional
      value(ATTR3) type CLIKE optional
      value(ATTR4) type CLIKE optional
      value(T100KEY) type SCX_T100KEY optional
    raising
      ZCX_VMD_VENDOR .
private section.
*"* private components of class ZCL_VMD_VENDOR
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_VMD_VENDOR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->ADD_NEW_CONTACT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_CONTACT                      TYPE REF TO ZCL_VMD_CONTACT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_new_contact.
    DATA: lr_contact_data TYPE REF TO VMDS_EI_CONTACTS. "vmds_ei_extern-central_data-contact-contacts .
    TRY.
        r_contact ?= zcl_vmd_contact=>create_instance( i_extension_id = extension_id
                                                       i_vendor = vendor ).
        INSERT INITIAL LINE INTO TABLE master_data-central_data-contact-contacts REFERENCE INTO lr_contact_data.
*        INSERT INITIAL LINE INTO TABLE master_data-central_data-contact-contacts REFERENCE INTO DATA(cont).
        IF sy-subrc EQ 0.
          r_contact->set_data( lr_contact_data ).
        ENDIF.
      CATCH zcx_vmd_vendor.
        "In case of new contact there should not be any error here
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CHANGE_COMPANY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COMPANY_CODE                 TYPE        BUKRS
* | [<-()] R_COMPANY                      TYPE REF TO ZCL_VMD_COMPANY
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_company.
    FIELD-SYMBOLS: <company> LIKE LINE OF master_data-company_data-company.
    READ TABLE master_data-company_data-company ASSIGNING <company> WITH KEY data_key-bukrs = i_company_code.
*    ASSIGN master_data-company_data-company[ data_key-bukrs = i_company_code
*                                                                      ] TO FIELD-SYMBOL(<company>).
    IF sy-subrc EQ 0.
      DATA: lr_company TYPE REF TO vmds_ei_company.
      GET REFERENCE OF <company> INTO lr_company.
      r_company ?= zcl_vmd_company=>create_instance( i_extension_id = extension_id ).
      r_company->set_data( lr_company ). "REF #( <company> ) ).
      r_company->set_task( zcl_vmd_util=>mode-change ).
    ELSE.
      raise_message( msgno = '013' attr1 = i_company_code ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CHANGE_CONTACT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CONTACT                      TYPE        KNVP-PARNR
* | [<-()] R_CONTACT                      TYPE REF TO ZCL_VMD_CONTACT
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_contact.
    DATA: lo_exc TYPE REF TO zcx_vmd_vendor.
    FIELD-SYMBOLS: <cont> LIKE LINE OF master_data-central_data-contact-contacts.
    CHECK i_contact IS NOT INITIAL.
    TRY.
        r_contact ?= zcl_vmd_contact=>create_instance( i_extension_id = extension_id
                                                       i_vendor = vendor
                                                       i_contact  = i_contact ).
        READ TABLE master_data-central_data-contact-contacts WITH KEY data_key-parnr = i_contact ASSIGNING <cont>.
*        ASSIGN master_data-central_data-contact-contacts[ data_key-parnr = i_contact ] TO FIELD-SYMBOL(<cont>).
        IF sy-subrc EQ 0.
          DATA: lr_contact TYPE REF TO vmds_ei_contacts.
          GET REFERENCE OF <cont> INTO lr_contact.
          r_contact->set_data( lr_contact )."REF #( <cont> ) ).
          r_contact->set_mode( zcl_vmd_util=>mode-change ).
        ENDIF.

      CATCH zcx_vmd_vendor INTO lo_exc.
        me->zlog->add_message( iv_textmsg1 = 'Contact doesn''t exists' iv_textmsgty = 'W' ).
        raise_message( t100key = lo_exc->if_t100_message~t100key ).
*        RAISE EXCEPTION TYPE zcx_vmd_vendor
*          EXPORTING
*            textid = lo_exc->if_t100_message~t100key.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CHANGE_PURCHASING_ORG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_PURCHASING_ORG               TYPE        EKORG
* | [<-()] R_PURCHASING                   TYPE REF TO ZCL_VMD_PURCHASING
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_purchasing_org.
    FIELD-SYMBOLS: <purchasing> LIKE LINE OF master_data-purchasing_data-purchasing.
    READ TABLE master_data-purchasing_data-purchasing WITH KEY data_key-ekorg = i_purchasing_org ASSIGNING <purchasing>.
*    ASSIGN master_data-purchasing_data-purchasing[ data_key-ekorg = i_purchasing_org
*                                                                      ] TO FIELD-SYMBOL(<purchasing>).
    IF sy-subrc EQ 0.
      DATA: lr_purchasing TYPE REF TO vmds_ei_purchasing.
      GET REFERENCE OF <purchasing> INTO lr_purchasing.
      r_purchasing ?= zcl_vmd_purchasing=>create_instance( i_extension_id = extension_id ).
      r_purchasing->set_data( lr_purchasing ). "REF #( <purchasing> ) ).
      r_purchasing->set_task( zcl_vmd_util=>mode-change ).
    ELSE.
      raise_message( msgno = '005' attr1 = vendor attr2 = i_purchasing_org ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VENDOR                       TYPE        LFA1-LIFNR(optional)
* | [--->] I_EXTENSION_CLASSES            TYPE        ZCL_VMD_EXTENSIONS=>TT_EXTENSION_CLASSES(optional)
* | [--->] I_LOGID                        TYPE        CLIKE(optional)
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    me->zlog = zcl_api_Log=>init_popup_log( iv_object = 'ZCL_VMD_VENDOR' iv_subobject = i_logid ).

*    vendor = |{ i_vendor  ALPHA = IN }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input         = i_vendor
      IMPORTING
        output        = vendor.

    extension_id = zcl_vmd_extensions=>set_extensions( extensions = i_extension_classes ).
    IF vendor IS INITIAL OR vendor CO '0'.
      mode = zcl_vmd_util=>mode-create.
      master_data-header-object_task = zcl_vmd_util=>mode-create.
    ELSE.
      SELECT SINGLE lifnr INTO vendor
          FROM lfa1
          WHERE lifnr EQ vendor.
      IF sy-subrc NE 0.
        raise_message( msgno = '001' attr1 = vendor ).
      ENDIF.
      get_data( ).
    ENDIF.



    DATA: lr_central TYPE REF TO vmds_ei_extern-central_data-central-data, "VMDS_EI_VMD_CENTRAL_DATA
          lr_centralx TYPE REF TO vmds_ei_extern-central_data-central-datax,
          lr_address TYPE REF TO vmds_ei_extern-central_data-address,
          lr_text TYPE REF TO vmds_ei_extern-central_data-text,
          lr_vat TYPE REF TO vmds_ei_extern-central_data-vat_number.

    GET REFERENCE OF: master_data-central_data-central-data  INTO lr_central,
                      master_data-central_data-central-datax INTO lr_centralx,
                      master_data-central_data-address       INTO lr_address,
                      master_data-central_data-text          INTO lr_text,
                      master_data-central_data-vat_number    INTO lr_vat.

    central ?= zcl_vmd_central=>create_instance( i_extension_id = extension_id i_data = lr_central "REF #( master_data-central_data-central-data )
                                                 i_datax = lr_centralx ). "REF #( master_data-central_data-central-datax ) ).
    address ?= zcl_vmd_address=>create_instance( i_extension_id = extension_id ).
    address->set_data( lr_address ). "REF #( master_data-central_data-address ) ).
    texts ?= zcl_vmd_texts=>create_instance( i_extension_id = extension_id i_texts =  lr_text ). " REF #( master_data-central_data-text )  ).
    vat   ?= zcl_vmd_vat=>create_instance( i_extension_id = extension_id i_vat = lr_vat ). " REF #( master_data-central_data-vat_number ) ).
*    tax_indicator ?= zcl_VMD_tax_ind=>create_instance( i_extension_id = extension_id i_tax_ind = ref #( master_data-central_data-tax_ind ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CREATE_COMPANY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COMPANY_CODE                 TYPE        BUKRS
* | [<-()] R_COMPANY                      TYPE REF TO ZCL_VMD_COMPANY
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_company.
    FIELD-SYMBOLS: <company> LIKE LINE OF master_data-company_data-company.
    READ TABLE master_data-company_data-company WITH KEY data_key-bukrs = i_company_code ASSIGNING <company>.
*    ASSIGN master_data-company_data-company[ data_key-bukrs = i_company_code
*                                                                      ] TO FIELD-SYMBOL(<company>).
    IF sy-subrc NE 0.
      APPEND INITIAL LINE TO master_data-company_data-company ASSIGNING <company>.
      <company>-task = zcl_vmd_util=>mode-create.
      <company>-data_key-bukrs = i_company_code.
*      INSERT VALUE #( task = zcl_vmd_util=>mode-create
*                      data_key-bukrs = i_company_code
*                    ) INTO TABLE master_data-company_data-company REFERENCE INTO DATA(company).
      DATA: lr_company TYPE REF TO vmds_ei_company.
      GET REFERENCE OF <company> INTO lr_company.
      IF sy-subrc EQ 0.
        r_company ?= zcl_vmd_company=>create_instance( i_extension_id = extension_id ).
        r_company->set_data( lr_company ).
      ENDIF.
    ELSE.
      raise_message( msgno = '014' attr1 = i_company_code ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->CREATE_PURCHASING_ORG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_PURCHASING_ORG               TYPE        EKORG
* | [<-()] R_PURCHASING                   TYPE REF TO ZCL_VMD_PURCHASING
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_purchasing_org.
    FIELD-SYMBOLS: <purchasing> LIKE LINE OF master_data-purchasing_data-purchasing.
    READ TABLE master_data-purchasing_data-purchasing WITH KEY data_key-ekorg = i_purchasing_org ASSIGNING <purchasing>.
*    ASSIGN master_data-purchasing_data-purchasing[ data_key-ekorg = i_purchasing_org
*                                                                      ] TO FIELD-SYMBOL(<purchasing>).
    IF sy-subrc NE 0.
      r_purchasing ?= zcl_vmd_purchasing=>create_instance( i_extension_id = extension_id ).
      APPEND INITIAL LINE TO master_data-purchasing_data-purchasing ASSIGNING <purchasing>.
      <purchasing>-data_key-ekorg = i_purchasing_org.
*      INSERT VALUE #( data_key-ekorg = i_purchasing_org
*                     ) INTO TABLE master_data-purchasing_data-purchasing REFERENCE INTO DATA(purchasing).
      DATA: lr_purchasing TYPE REF TO vmds_ei_purchasing.
      GET REFERENCE OF <purchasing> INTO lr_purchasing.
      IF sy-subrc EQ 0.
        r_purchasing->set_data( lr_purchasing ).
        r_purchasing->set_task( zcl_vmd_util=>mode-create ).
      ENDIF.
    ELSE.
      raise_message( msgno = '006' attr1 = vendor attr2 = i_purchasing_org ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->DELETE_COMPANY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COMPANY_CODE                 TYPE        BUKRS
* | [<-()] R_COMPANY                      TYPE REF TO ZCL_VMD_COMPANY
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_company.
     FIELD-SYMBOLS: <company> LIKE LINE OF master_data-company_data-company.
     READ TABLE master_data-company_data-company WITH KEY data_key-bukrs = i_company_code ASSIGNING <company>.
*    ASSIGN master_data-company_data-company[ data_key-bukrs = i_company_code
*                                                                      ] TO FIELD-SYMBOL(<company>).
    IF sy-subrc EQ 0.
      DATA: lr_company TYPE REF TO vmds_ei_company.
      GET REFERENCE OF <company> INTO lr_company.

      r_company ?= zcl_vmd_company=>create_instance( i_extension_id = extension_id ).
      r_company->set_data( lr_company ). "REF #( <company> ) ).
      r_company->set_loevm( abap_true ).
      r_company->set_task( zcl_vmd_util=>mode-change ).
    ELSE.
      raise_message( msgno = '013' attr1 = i_company_code ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->DELETE_CONTACT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CONTACT                      TYPE        KNVP-PARNR
* | [--->] I_RAISE_ERROR                  TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] R_CONTACT                      TYPE REF TO ZCL_VMD_CONTACT
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_contact.
    FIELD-SYMBOLS: <contact> LIKE LINE OF master_data-central_data-contact-contacts,
                   <cc> LIKE LINE OF master_data-central_data-contact-contacts.
    DATA: lr_contact TYPE REF TO vmds_ei_contacts,
          lo_exc TYPE REF TO zcx_vmd_vendor.
    CHECK i_contact IS NOT INITIAL.
    TRY.
        r_contact ?= zcl_vmd_contact=>create_instance( i_extension_id = extension_id
                                                       i_vendor = vendor
                                                       i_contact  = i_contact ).
        READ TABLE master_data-central_data-contact-contacts WITH KEY data_key-parnr = i_contact ASSIGNING <contact>.
*        ASSIGN master_data-central_data-contact-contacts[ data_key-parnr = i_contact ] TO FIELD-SYMBOL(<cont>).
        IF sy-subrc EQ 0.
          " This is needed as in other case contact data are deleted in internal table
          " and there is an error that name is initial. So me must clear current state and
          " set all contacts as to be updated.
          CLEAR master_data-central_data-contact-current_state.
          LOOP AT master_data-central_data-contact-contacts ASSIGNING <cc> WHERE task IS INITIAL.
            <cc>-task = zcl_vmd_util=>mode-change.
          ENDLOOP.
          GET REFERENCE OF <contact> INTO lr_contact.
          r_contact->set_data( lr_contact ). "REF #( <cont> ) ).
          r_contact->set_mode( zcl_vmd_util=>mode-delete ).
        ENDIF.

      CATCH zcx_vmd_vendor INTO lo_exc.
        me->zlog->add_message( iv_textmsg1 = 'Contact doesn''t exists' iv_textmsgty = 'W').
        IF i_raise_error EQ abap_true.
          raise_message( t100key = lo_exc->if_t100_message~t100key ).
*          RAISE EXCEPTION TYPE zcx_vmd_vendor
*            EXPORTING
*              textid = lo_exc->if_t100_message~t100key.
        ENDIF.
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->DELETE_PURCHASING_ORG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_PURCHASING_ORG               TYPE        EKORG
* | [<-()] R_PURCHASING                   TYPE REF TO ZCL_VMD_PURCHASING
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_purchasing_org.
    FIELD-SYMBOLS: <purchasing> LIKE LINE OF master_data-purchasing_data-purchasing.
    READ TABLE master_data-purchasing_data-purchasing WITH KEY data_key-ekorg = i_purchasing_org ASSIGNING <purchasing>.
*    ASSIGN master_data-purchasing_data-purchasing[ data_key-ekorg = i_purchasing_org
*                                                                      ] TO FIELD-SYMBOL(<purchasing>).
    IF sy-subrc EQ 0.
      DATA: lr_purchasing TYPE REF TO vmds_ei_purchasing.
      GET REFERENCE OF <purchasing> INTO lr_purchasing.
      r_purchasing ?= zcl_vmd_purchasing=>create_instance( i_extension_id = extension_id ).
      r_purchasing->set_data( lr_purchasing )." REF #( <purchasing> ) ).
      r_purchasing->set_loevm( abap_true ).
      r_purchasing->set_task( zcl_vmd_util=>mode-change ).
    ELSE.
      raise_message( msgno = '005' attr1 = vendor attr2 = i_purchasing_org ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_VENDOR=>DESCRIBE_STRUCT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_STRUCT                      TYPE        ANY
* | [<-->] CT_LIST                        TYPE        SRT_STRINGS(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD DESCRIBE_STRUCT.
*    IF original_data IS INITIAL.
*      set_master_data( i_master_data ).
*    ELSE.

    DATA:
          lo_descr TYPE REF TO cl_abap_structdescr,
          lo_descr2 TYPE REF TO cl_abap_structdescr,
          lv_entry TYPE string,
          lv_head_idx TYPE i,
          lv_root_name TYPE string,
          ls_comp TYPE abap_compdescr,
          ls_comp2 TYPE abap_compdescr.

    FIELD-SYMBOLS: <ls_stru> TYPE any,
                   <lv_entry> TYPE string.

    IF ct_list IS NOT INITIAL.
      lv_head_idx = lines( ct_list ).
      READ TABLE ct_list INTO lv_root_name INDEX lv_head_idx.
      lv_root_name = |{ lv_root_name }-|.
    ENDIF.

    lo_descr ?= cl_abap_typedescr=>describe_by_data( is_struct ).
    LOOP AT lo_descr->components[] INTO ls_comp WHERE name <> 'DATAX'.

      ASSIGN COMPONENT ls_comp-name OF STRUCTURE is_struct TO <ls_stru>.
      IF sy-subrc = 0.

        CASE ls_comp-type_kind.
          WHEN cl_abap_structdescr=>typekind_struct1  " flat (u)
            OR cl_abap_structdescr=>typekind_struct2. " deep (v)


*            READ TABLE ct_list ASSIGNING <lv_entry> INDEX lv_head_idx.
*            IF sy-subrc = 0.
*              <lv_entry> = |{ lv_root_name }-{ ls_comp-name }|.
*            ELSE.
*              APPEND ls_comp-name TO ct_list.
*            ENDIF.
            APPEND INITIAL LINE TO ct_list ASSIGNING <lv_entry>.
            <lv_entry> = |{ lv_root_name }{ ls_comp-name }|.

            describe_struct( EXPORTING is_struct = <ls_stru>
                             CHANGING  ct_list   = ct_list ).

          WHEN OTHERS. "cl_abap_structdescr=>typekind_char. " char (C)
*            READ TABLE ct_list INTO lv_entry INDEX lv_head_idx.
*            IF sy-subrc = 0.
              lv_entry = |{ lv_root_name }{ ls_comp-name }|.

              IF ls_comp-type_kind = cl_abap_structdescr=>typekind_table.
                lv_entry = |{ lv_entry }[]|.
              ENDIF.

              APPEND lv_entry TO ct_list.
*            ENDIF.

*            rv_name = ls_comp-name.
        ENDCASE.

      ENDIF.
    ENDLOOP.
    IF lv_head_idx IS NOT INITIAL AND
       lo_descr->components[] IS NOT INITIAL.
      DELETE ct_list INDEX lv_head_idx.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->GET_COMPANY
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COMPANY_CODE                 TYPE        BUKRS
* | [<-()] R_COMPANY                      TYPE REF TO ZCL_VMD_COMPANY
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_company.
    FIELD-SYMBOLS: <company> LIKE LINE OF master_data-company_data-company.
    READ TABLE master_data-company_data-company WITH KEY data_key-bukrs = i_company_code ASSIGNING <company>.
*    ASSIGN master_data-company_data-company[ data_key-bukrs = i_company_code
*                                                                         ] TO FIELD-SYMBOL(<company>).
    IF sy-subrc EQ 0.
      DATA: lr_company TYPE REF TO vmds_ei_company.
      GET REFERENCE OF <company> INTO lr_company.

      r_company ?= zcl_vmd_company=>create_instance( i_extension_id = extension_id ).
      r_company->set_data( lr_company )."REF #( <company> ) ).
    ELSE.
      raise_message( msgno = '013' attr1 = i_company_code ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->GET_CONTACT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CONTACT                      TYPE        KNVP-PARNR
* | [<-()] R_CONTACT                      TYPE REF TO ZCL_VMD_CONTACT
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_contact.
    FIELD-SYMBOLS: <contact> LIKE LINE OF master_data-central_data-contact-contacts.
    DATA: lr_contact TYPE REF TO vmds_ei_contacts,
          lo_exc TYPE REF TO zcx_vmd_vendor.

    TRY.
        r_contact ?= zcl_vmd_contact=>create_instance( i_extension_id = extension_id
                                                       i_vendor = vendor
                                                       i_contact  = i_contact ).
        READ TABLE master_data-central_data-contact-contacts WITH KEY data_key-parnr = i_contact ASSIGNING <contact>.
*        ASSIGN master_data-central_data-contact-contacts[ data_key-parnr = i_contact ] TO FIELD-SYMBOL(<cont>).
        IF sy-subrc EQ 0.
          GET REFERENCE OF <contact> INTO lr_contact.
          r_contact->set_data( lr_contact ). "REF #( <cont> ) ).
          r_contact->set_mode( zcl_vmd_util=>mode-change ).
        ENDIF.
      CATCH zcx_vmd_vendor INTO lo_exc.
        me->zlog->add_message( iv_textmsg1 = 'Contact doesn''t exists' iv_textmsgty = 'W').
        raise_message( t100key = lo_exc->if_t100_message~t100key ).
*        RAISE EXCEPTION TYPE zcx_vmd_vendor
*          EXPORTING
*            textid = lo_exc->if_t100_message~t100key.
    ENDTRY.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->GET_CONTACT_BY_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_FIRSTNAME                    TYPE        BAPIAD3VL-FIRSTNAME
* | [--->] I_LASTNAME                     TYPE        BAPIAD3VL-LASTNAME
* | [<-()] R_CONTACT                      TYPE REF TO ZCL_VMD_CONTACT
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_contact_by_name.
    FIELD-SYMBOLS: <contact> LIKE LINE OF master_data-central_data-contact-contacts.
    DATA: lr_contact TYPE REF TO vmds_ei_contacts,
          lo_exc TYPE REF TO zcx_vmd_vendor.

    CHECK i_lastname IS NOT INITIAL.
    READ TABLE master_data-central_data-contact-contacts WITH KEY address_type_3-postal-data-firstname = i_firstname
                                                                  address_type_3-postal-data-lastname = i_lastname ASSIGNING <contact>.
*    ASSIGN master_data-central_data-contact-contacts[  address_type_3-postal-data-firstname  = i_firstname
*                                                       address_type_3-postal-data-lastname   = i_lastname
*                                                         ] TO FIELD-SYMBOL(<cont>).
    IF sy-subrc EQ 0.
      TRY.
          GET REFERENCE OF <contact> INTO lr_contact.
          r_contact ?= zcl_vmd_contact=>create_instance( i_extension_id = extension_id
                                                         i_vendor = vendor
                                                         i_contact  = <contact>-data_key-parnr ).
          r_contact->set_data( lr_contact ). "REF #( <cont> ) ).
          r_contact->set_mode( zcl_vmd_util=>mode-change ).
        CATCH zcx_vmd_vendor INTO lo_exc.
          "Contact doesn't exists
          me->zlog->add_message( iv_textmsg1 = 'Contact doesn''t exists' iv_textmsgty = 'W').
          raise_message( t100key = lo_exc->if_t100_message~t100key ).
*          RAISE EXCEPTION TYPE zcx_vmd_vendor
*            EXPORTING
*              textid = lo_exc->if_t100_message~t100key.
      ENDTRY.
    ENDIF.



  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_REREAD_DB                    TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] R_MASTER_DATA                  TYPE        VMDS_EI_EXTERN
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.
    DATA: ls_master_in TYPE VMDS_EI_MAIN,
          ls_master_out TYPE VMDS_EI_MAIN,
          ls_error TYPE CVIS_MESSAGE.

    FIELD-SYMBOLS: <ls_vend_head> TYPE VMDS_EI_EXTERN,
                   <vendor> TYPE vmds_ei_extern.

    CHECK vendor IS NOT INITIAL.

    IF i_reread_db EQ abap_true.

      APPEND INITIAL LINE TO ls_master_in-vendors ASSIGNING <ls_vend_head>.
      <ls_vend_head>-header-object_task = zcl_vmd_util=>mode-modify .
      <ls_vend_head>-header-object_instance = vendor .

      vmd_ei_api_extract=>get_data(
        EXPORTING
*          is_master_data = VALUE #( vendors = VALUE #( ( header = VALUE #( object_task = zcl_vmd_util=>mode-modify object_instance = vendor ) ) ) )
          is_master_data = ls_master_in
*          i_always_get_contacts = 'X' " Only in >7.4 !!!
        IMPORTING
          es_master_data = ls_master_out
          es_error       = ls_error
      ).
      IF ls_error-is_error EQ abap_false.
        READ TABLE ls_master_out-vendors ASSIGNING <vendor> INDEX 1.
*        ASSIGN es_master_data-vendors[ 1 ] TO FIELD-SYMBOL(<vendor>).
        IF sy-subrc EQ 0.
          r_master_data = <vendor>.
          master_data = <vendor>.
          original_data = <vendor>.

        ENDIF.
      ELSE.
        raise_message( ).
*        RAISE EXCEPTION TYPE zcx_vmd_vendor EXPORTING messages = ls_error-messages.
      ENDIF.
    ELSE.
      r_master_data = master_data.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->GET_PURCHASING_ORG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_PURCHASING_ORG               TYPE        EKORG
* | [<-()] R_PURCHASING                   TYPE REF TO ZCL_VMD_PURCHASING
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_purchasing_org.
    FIELD-SYMBOLS: <purchasing> LIKE LINE OF master_data-purchasing_data-purchasing.
    READ TABLE master_data-purchasing_data-purchasing WITH KEY data_key-ekorg = i_purchasing_org ASSIGNING <purchasing>.
*    ASSIGN master_data-purchasing_data-purchasing[ data_key-ekorg = i_purchasing_org
*                                                                      ] TO FIELD-SYMBOL(<purchasing>).
    IF sy-subrc EQ 0.
      DATA: lr_purchasing TYPE REF TO vmds_ei_purchasing.
      GET REFERENCE OF <purchasing> INTO lr_purchasing.
      r_purchasing ?= zcl_vmd_purchasing=>create_instance( i_extension_id = extension_id ).
      r_purchasing->set_data( lr_purchasing )."REF #( <purchasing> ) ).
    ELSE.
      raise_message( msgno = '005' attr1 = vendor attr2 = i_purchasing_org ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_VENDOR->LOCK
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD lock.
    CHECK vendor IS NOT INITIAL.
    CALL FUNCTION 'ENQUEUE_EXLFA1'
      EXPORTING
        mode_lfa1      = 'E'
        mandt          = sy-mandt
        lifnr          = vendor
*       x_lifnr        = x_lifnr    " Fill argument 02 with initial value?
*       _scope         = _scope
*       _wait          = _wait
*       _collect       = _collect    " Initially only collect lock
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      raise_message( msgid = sy-msgid attr1 = sy-msgv1 attr3 = sy-msgv3
                     msgno = sy-msgno attr2 = sy-msgv2 attr4 = sy-msgv4 ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_VENDOR->RAISE_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] MSGID                          TYPE        SCX_T100KEY-MSGID (default ='Z_VMD_VENDORS')
* | [--->] MSGNO                          TYPE        SCX_T100KEY-MSGNO (default ='999')
* | [--->] ATTR1                          TYPE        CLIKE(optional)
* | [--->] ATTR2                          TYPE        CLIKE(optional)
* | [--->] ATTR3                          TYPE        CLIKE(optional)
* | [--->] ATTR4                          TYPE        CLIKE(optional)
* | [--->] T100KEY                        TYPE        SCX_T100KEY(optional)
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
   METHOD raise_message.
    DATA: ls_t100key TYPE scx_t100key.
    IF t100key IS NOT INITIAL.
      ls_t100key = t100key.
    ELSE.
      ls_t100key-msgid = msgid.
      ls_t100key-msgno = msgno.
      ls_t100key-attr1 = attr1.
      ls_t100key-attr2 = attr2.
      ls_t100key-attr3 = attr3.
      ls_t100key-attr4 = attr4.
    ENDIF.
    me->zlog->add_message( is_t100key = ls_t100key iv_textmsgty = 'E' ).
    me->zlog->save( iv_save_info = space ).
    RAISE EXCEPTION TYPE zcx_vmd_vendor
        EXPORTING
          textid = ls_t100key.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TEST_RUN                     TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [--->] I_WAIT_AFTER_COMMIT            TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<---] E_VENDOR                       TYPE        LFA1-LIFNR
* | [<---] R_MASTER_DATA                  TYPE        VMDS_EI_EXTERN
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save.


    IF master_data IS INITIAL.
      raise_message( msgno = '002' ).
*      RAISE EXCEPTION TYPE zcx_vmd_vendor EXPORTING no = 002.
    ENDIF.


    lock( ).

    "Delete Not changed company code data
    IF mode NE zcl_vmd_util=>mode-create.
      DELETE master_data-company_data-company WHERE task IS INITIAL OR task EQ zcl_vmd_util=>mode-current_state.
    ENDIF.

    "Delete other PURCHASING orgs from the list to not check the authorizations.
    DELETE master_data-purchasing_data-purchasing WHERE task IS INITIAL OR task EQ zcl_vmd_util=>mode-current_state.


    DATA: ls_master_data TYPE vmds_ei_main.
    APPEND master_data TO ls_master_data-vendors[].
*    DATA(bapi_structure) = VALUE vmds_ei_main( vendors = VALUE #( ( master_data ) ) ).

    DATA:
      correct_data  TYPE VMDS_EI_MAIN,
      correct_messages  TYPE CVIS_MESSAGE,
      error_messages  TYPE CVIS_MESSAGE.

    vmd_ei_api=>maintain_bapi(
      EXPORTING
         iv_test_run              = i_test_run
         iv_collect_messages      = abap_true
         is_master_data           = ls_master_data
*         is_master_data           = VALUE #( vendors = VALUE #( ( master_data ) ) )
      IMPORTING
        es_master_data_correct   = correct_data
        es_message_correct       = correct_messages
        es_message_defective     = error_messages
        ).

    IF error_messages-is_error EQ abap_false AND i_test_run EQ abap_false.

      IF error_messages-is_error EQ abap_false.
        zcl_vmd_util=>commit_work( i_wait = i_wait_after_commit ).
        unlock( ).

        DATA: ls_vendor LIKE LINE OF correct_data-vendors.
        READ TABLE correct_data-vendors INTO ls_vendor INDEX 1.
        IF sy-subrc = 0.
          vendor = ls_vendor-header-object_instance-lifnr.
          e_vendor = vendor.

          IF mode = zcl_vmd_util=>mode-create.
            me->zlog->add_message( iv_textmsg1 = 'Vendor created' iv_textmsg2 = vendor ).
          ELSE.
            me->zlog->add_message( iv_textmsg1 = 'Vendor updated' iv_textmsg2 = vendor ).
          ENDIF.

          mode = zcl_vmd_util=>mode-change.

        ENDIF.
*        TRY.
*            vendor = correct_data-vendors[ 1 ]-header-object_instance-lifnr.
*            mode = zcl_vmd_util=>mode-change.
*            e_vendor = vendor.
*          CATCH cx_sy_itab_line_not_found.
*
*        ENDTRY.
      ELSE.
        zcl_vmd_util=>rollback_work( ).
        unlock( ).
        me->zlog->add_message( it_bapiret = error_messages-messages[] ).
        raise_message( msgno = '003' ).
*        RAISE EXCEPTION TYPE zcx_vmd_vendor EXPORTING no = 003 messages = error_messages-messages.
      ENDIF.
    ELSEIF error_messages-is_error EQ abap_true.
      IF i_test_run EQ abap_false.
        zcl_vmd_util=>rollback_work( ).
      ENDIF.
      unlock( ).
      me->zlog->add_message( it_bapiret = error_messages-messages[] ).
      raise_message( msgno = '003' ).
*      RAISE EXCEPTION TYPE zcx_vmd_vendor EXPORTING no = 003 messages = error_messages-messages.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_VMD_VENDOR->SET_MASTER_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_MASTER_DATA                  TYPE        VMDS_EI_EXTERN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_master_data.
    master_data = i_master_data.

    IF i_master_data-header-object_task = cvi_ei_api_map_structure=>gc_update.

      update_master_data( EXPORTING is_old = original_data
                          CHANGING  cs_new = master_data   ).

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_VMD_VENDOR->UNLOCK
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_VMD_VENDOR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unlock.
    CALL FUNCTION 'DEQUEUE_EXLFA1'
      EXPORTING
        mode_lfa1 = 'E'
        mandt     = sy-mandt    " 01th enqueue argument
        lifnr     = vendor
*       x_lifnr   = x_lifnr    " Fill argument 02 with initial value?
*       _scope    = _scope
*       _synchron = _synchron    " Synchonous unlock
*       _collect  = _collect    " Initially only collect lock
      .
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_VENDOR=>UPDATE_MASTER_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_OLD                         TYPE        ANY
* | [<-->] CS_NEW                         TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_master_data.

    DATA: lt_descibed TYPE srt_strings,
          lv_fieldx TYPE string,
          lv_field TYPE string.

    FIELD-SYMBOLS: <lv_original> TYPE any,
                   <lv_new>      TYPE any.

    describe_struct( EXPORTING is_struct = cs_new
                     CHANGING  ct_list   = lt_descibed ).

    LOOP AT lt_descibed INTO lv_field.
      ASSIGN COMPONENT lv_field OF STRUCTURE cs_new TO <lv_new>.
      ASSIGN COMPONENT lv_field OF STRUCTURE is_old TO <lv_original>.
      IF sy-subrc = 0 AND <lv_original> <> <lv_new>.
*        ASSIGN COMPONENT lv_field  OF STRUCTURE master_data TO <lv_original>.
*        <lv_original> = <lv_new>.

        REPLACE ALL OCCURRENCES OF '-DATA-' IN lv_field WITH '-DATAX-'.
        IF sy-subrc = 0.
          ASSIGN COMPONENT lv_field OF STRUCTURE cs_new TO <lv_original>.
          IF sy-subrc = 0.
            <lv_original> = abap_true.
          ENDIF.
        ENDIF.
***      ELSEIF sy-subrc <> 0.
***        " ERROR: is_old stru is not equal to cs_new!
***        MESSAGE x398(00) WITH 'Fatal error while updating partner!'.
***        RETURN.
      ENDIF.
    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
