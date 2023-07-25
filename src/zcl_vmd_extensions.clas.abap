CLASS zcl_vmd_extensions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF t_extension_classes,
             type TYPE string,
             name TYPE string,
           END OF t_extension_classes,
           tt_extension_classes TYPE HASHED TABLE OF t_extension_classes WITH UNIQUE KEY type,
           BEGIN OF t_extension_objects,
             id         TYPE guid_32,
             extensions TYPE tt_extension_classes,
           END OF t_extension_objects,
           tt_extensions_objects TYPE HASHED TABLE OF t_extension_objects WITH UNIQUE KEY id.

    CONSTANTS:
      BEGIN OF class_extension,
        contact  TYPE string VALUE 'contact',
        address  TYPE string VALUE 'address',
        purchase TYPE string VALUE 'purchase',
        vat      TYPE string VALUE 'vat',
        tax_ind  TYPE string VALUE 'tax',
        remarks  TYPE string VALUE 'remarks',
        company  TYPE string VALUE 'company',
        central  TYPE string VALUE 'central',
        texts    TYPE string VALUE 'texts',
        vendor   TYPE string VALUE 'vendor',
      END OF class_extension.

    CLASS-DATA: extension_objects TYPE tt_extensions_objects.
    CLASS-METHODS: set_extensions IMPORTING extensions          TYPE tt_extension_classes
                                  RETURNING VALUE(extension_id) TYPE guid_32.
    CLASS-METHODS: get_extensions IMPORTING id                TYPE guid_32
                                  RETURNING VALUE(extensions) TYPE tt_extension_classes.
    CLASS-METHODS: get_extension_by_type IMPORTING id                          TYPE guid_32
                                                   type                        TYPE string
                                         RETURNING VALUE(extension_class_name) TYPE string.
    CLASS-METHODS get_extension_class_abs_name
      IMPORTING
                id                       TYPE guid_32
                type                     TYPE string
      RETURNING
                VALUE(subclass_abs_name) TYPE abap_abstypename
      RAISING   zcx_vmd_no_extension.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS get_class_description
      IMPORTING i_class_name         TYPE string
      RETURNING VALUE(r_class_descr) TYPE REF TO cl_abap_typedescr.
ENDCLASS.



CLASS ZCL_VMD_EXTENSIONS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_VMD_EXTENSIONS=>GET_CLASS_DESCRIPTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CLASS_NAME                   TYPE        STRING
* | [<-()] R_CLASS_DESCR                  TYPE REF TO CL_ABAP_TYPEDESCR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_class_description.
    CHECK i_class_name IS NOT INITIAL.
    "global class
    cl_abap_classdescr=>describe_by_name( EXPORTING p_name = to_upper( i_class_name )
                                          RECEIVING p_descr_ref = r_class_descr
                                                  EXCEPTIONS type_not_found = 1 ).
    IF sy-subrc EQ 0.
      RETURN.
    ELSE.
      "local class
      DATA: local_class_name TYPE string.
      local_class_name = |\\PROGRAM={ sy-cprog }\\CLASS={ i_class_name }|.
      cl_abap_classdescr=>describe_by_name( EXPORTING p_name = to_upper( local_class_name )
                                            RECEIVING p_descr_ref = r_class_descr
                                                    EXCEPTIONS type_not_found = 1 ).
      IF sy-subrc EQ 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_EXTENSIONS=>GET_EXTENSIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] ID                             TYPE        GUID_32
* | [<-()] EXTENSIONS                     TYPE        TT_EXTENSION_CLASSES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_extensions.
    FIELD-SYMBOLS: <ext> LIKE LINE OF extension_objects.
    READ TABLE extension_objects ASSIGNING <ext> WITH KEY id = id.
*    ASSIGN extension_objects[ id = id ] TO FIELD-SYMBOL(<ext>).
    IF <ext> IS ASSIGNED.
      extensions = <ext>-extensions.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_EXTENSIONS=>GET_EXTENSION_BY_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] ID                             TYPE        GUID_32
* | [--->] TYPE                           TYPE        STRING
* | [<-()] EXTENSION_CLASS_NAME           TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_extension_by_type.
    CHECK id IS NOT INITIAL.
    FIELD-SYMBOLS: <ext> LIKE LINE OF extension_objects.
    READ TABLE extension_objects ASSIGNING <ext> WITH KEY id = id.
*    ASSIGN extension_objects[ id = id ] TO FIELD-SYMBOL(<ext>).
    IF <ext> IS ASSIGNED.
      FIELD-SYMBOLS: <ext_class> LIKE LINE OF <ext>-extensions.
      READ TABLE <ext>-extensions ASSIGNING <ext_class> WITH KEY type = type.
*      ASSIGN <ext>-extensions[ type = type ] TO FIELD-SYMBOL(<ext_class>).
      IF <ext_class> IS ASSIGNED.
        extension_class_name = <ext_class>-name.
      ENDIF.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_EXTENSIONS=>GET_EXTENSION_CLASS_ABS_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] ID                             TYPE        GUID_32
* | [--->] TYPE                           TYPE        STRING
* | [<-()] SUBCLASS_ABS_NAME              TYPE        ABAP_ABSTYPENAME
* | [!CX!] ZCX_VMD_NO_EXTENSION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_extension_class_abs_name.
    DATA: subclass_description TYPE REF TO CL_ABAP_TYPEDESCR.
    subclass_description = get_class_description( get_extension_by_type( id = id type = type ) ).
    IF subclass_description IS INITIAL.
      RAISE EXCEPTION TYPE zcx_vmd_no_extension.
    ENDIF.
    subclass_abs_name = subclass_description->absolute_name.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_VMD_EXTENSIONS=>SET_EXTENSIONS
* +-------------------------------------------------------------------------------------------------+
* | [--->] EXTENSIONS                     TYPE        TT_EXTENSION_CLASSES
* | [<-()] EXTENSION_ID                   TYPE        GUID_32
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_extensions.
    DATA: ls_extension_objects LIKE LINE OF extension_objects.
    cl_reca_guid=>guid_create(
      IMPORTING
        ed_guid_32 = extension_id ).
    ls_extension_objects-id         = extension_id.
    ls_extension_objects-extensions = extensions.
    INSERT ls_extension_objects INTO TABLE extension_objects.
*    INSERT VALUE #( id = extension_id extensions = extensions ) INTO TABLE extension_objects.
  ENDMETHOD.
ENDCLASS.
