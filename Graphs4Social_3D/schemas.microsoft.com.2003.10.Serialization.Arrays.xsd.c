﻿
// File generated by Wsutil Compiler version 1.0092 
#include <WebServices.h>
#include "schemas.microsoft.com.2003.10.Serialization.Arrays.xsd.h"

typedef struct _schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions 
{
    struct  // global types
    {
        char unused;
        struct // ArrayOfstring
        {
            WS_FIELD_DESCRIPTION String;
            WS_FIELD_DESCRIPTION* ArrayOfstringFields [1]; 
        } ArrayOfstringdescs; // end of ArrayOfstring
    } globalTypes;  // end of global types
    struct // XML dictionary
    {
        struct // XML string list
        {
            WS_XML_STRING ArrayOfstringTypeName;  // ArrayOfstring
            WS_XML_STRING ArrayOfstringTypeNamespace;  // http://schemas.microsoft.com/2003/10/Serialization/Arrays
            WS_XML_STRING ArrayOfstringStringLocalName;  // string
        } xmlStrings; // end of XML string list
        WS_XML_DICTIONARY dict;  
    } dictionary;  // end of XML dictionary
} _schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions;

const static _schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions =
{
    { // global types
        0,
        {   // ArrayOfstring
            { // field description for String
            WS_REPEATING_ELEMENT_FIELD_MAPPING,
            0,
            0,
            WS_WSZ_TYPE,
            0,
            WsOffsetOf(ArrayOfstring, String),
             WS_FIELD_NILLABLE_ITEM,
            0,
            WsOffsetOf(ArrayOfstring, StringCount),
            (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringStringLocalName, // string
            (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringTypeNamespace, // http://schemas.microsoft.com/2003/10/Serialization/Arrays
            0,
            },    // end of field description for String
            {    // fields description for ArrayOfstring
            (WS_FIELD_DESCRIPTION*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.globalTypes.ArrayOfstringdescs.String,
            },
        },    // ArrayOfstring
    }, // end of global types
    {    // dictionary 
        { // xmlStrings
            WS_XML_STRING_DICTIONARY_VALUE("ArrayOfstring",&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.dict, 0),
            WS_XML_STRING_DICTIONARY_VALUE("http://schemas.microsoft.com/2003/10/Serialization/Arrays",&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.dict, 1),
            WS_XML_STRING_DICTIONARY_VALUE("string",&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.dict, 2),
        },  // end of xmlStrings
        
        {   // schemas_microsoft_com_2003_10_Serialization_Arrays_xsddictionary
        // 601756bd-428f-4d56-91f8-5b42ceddc774 
        { 0x601756bd, 0x428f, 0x4d56, { 0x91, 0xf8, 0x5b,0x42, 0xce, 0xdd, 0xc7, 0x74 } },
        (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings,
        3,
        TRUE,
        },
    },   //  end of dictionary
}; //  end of schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions

const _schemas_microsoft_com_2003_10_Serialization_Arrays_xsd schemas_microsoft_com_2003_10_Serialization_Arrays_xsd =
{
    {// globalTypes
        {
        sizeof(ArrayOfstring),
        __alignof(ArrayOfstring),
        (WS_FIELD_DESCRIPTION**)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.globalTypes.ArrayOfstringdescs.ArrayOfstringFields,
        WsCountOf(schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.globalTypes.ArrayOfstringdescs.ArrayOfstringFields),
        (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringTypeName, // ArrayOfstring
        (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringTypeNamespace, // http://schemas.microsoft.com/2003/10/Serialization/Arrays
        0,
        0,
        0,
        },   // end of struct description for ArrayOfstring
    }, // globalTypes
    {// globalElements
        {
            (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringTypeName, // ArrayOfstring
            (WS_XML_STRING*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsdLocalDefinitions.dictionary.xmlStrings.ArrayOfstringTypeNamespace, // http://schemas.microsoft.com/2003/10/Serialization/Arrays
            WS_STRUCT_TYPE,
            (void*)&schemas_microsoft_com_2003_10_Serialization_Arrays_xsd.globalTypes.ArrayOfstring,
        },
    }, // globalElements
}; // end of _schemas_microsoft_com_2003_10_Serialization_Arrays_xsd
