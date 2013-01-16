﻿
// File generated by Wsutil Compiler version 1.0092 
#include <WebServices.h>
#include "schemas.microsoft.com.2003.10.Serialization.Arrays.xsd.h"
#include "schema.xsd.h"
#include "tempuri.org.xsd.h"
#include "tempuri.org.wsdl.h"

typedef struct _tempuri_org_wsdlLocalDefinitions 
{
    struct // messages
    {
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_carregaGrafo_InputMessage;
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_carregaGrafo_OutputMessage;
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage;
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage;
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_DoWork_InputMessage;
        WS_MESSAGE_DESCRIPTION IGraphs4Social_Service_DoWork_OutputMessage;
    } messages; // end of messages
    struct // contracts
    {
        struct // BasicHttpBinding_IGraphs4Social_Service
        {
            struct // BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
            {
                WS_PARAMETER_DESCRIPTION params[2];
                WS_OPERATION_DESCRIPTION BasicHttpBinding_IGraphs4Social_Service_carregaGrafo;
            } BasicHttpBinding_IGraphs4Social_Service_carregaGrafo;
            struct // BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
            {
                WS_PARAMETER_DESCRIPTION params[3];
                WS_OPERATION_DESCRIPTION BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum;
            } BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum;
            struct // BasicHttpBinding_IGraphs4Social_Service_DoWork
            {
                WS_PARAMETER_DESCRIPTION params[1];
                WS_OPERATION_DESCRIPTION BasicHttpBinding_IGraphs4Social_Service_DoWork;
            } BasicHttpBinding_IGraphs4Social_Service_DoWork;
            WS_OPERATION_DESCRIPTION* operations[3];
            WS_CONTRACT_DESCRIPTION contractDesc;
        } BasicHttpBinding_IGraphs4Social_Service;
    } contracts;  // endof contracts 
    struct // policies
    {
        struct // BasicHttpBinding_IGraphs4Social_Service
        {
            WS_ENCODING encoding;
            WS_ADDRESSING_VERSION addressingVersion;
            WS_ENVELOPE_VERSION envelopeVersion;
            WS_CHANNEL_PROPERTY channelPropertiesArray[3];
        } BasicHttpBinding_IGraphs4Social_Service;
    } policies;
    struct // XML dictionary
    {
        struct // XML string list
        {
            WS_XML_STRING IGraphs4Social_Service_carregaGrafo_InputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/carregaGrafo
            WS_XML_STRING IGraphs4Social_Service_carregaGrafo_OutputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/carregaGrafoResponse
            WS_XML_STRING IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComum
            WS_XML_STRING IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComumResponse
            WS_XML_STRING IGraphs4Social_Service_DoWork_InputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/DoWork
            WS_XML_STRING IGraphs4Social_Service_DoWork_OutputMessageactionName;  // http://tempuri.org/IGraphs4Social_Service/DoWorkResponse
        } xmlStrings; // end of XML string list
        WS_XML_DICTIONARY dict;  
    } dictionary;  // end of XML dictionary
} _tempuri_org_wsdlLocalDefinitions;


typedef struct BasicHttpBinding_IGraphs4Social_Service_carregaGrafoParamStruct 
{
    WCHAR** username;
    Grafo** carregaGrafoResult;
} BasicHttpBinding_IGraphs4Social_Service_carregaGrafoParamStruct;

#if (_MSC_VER >=1400) 
#pragma warning(push)
#endif
#pragma warning(disable: 4055) // conversion from data pointer to function pointer
HRESULT CALLBACK BasicHttpBinding_IGraphs4Social_Service_carregaGrafoOperationStub(
    __in const WS_OPERATION_CONTEXT* _context,
    __in void* _stackStruct,
    __in const void* _callback,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoCallback _operation = (BasicHttpBinding_IGraphs4Social_Service_carregaGrafoCallback)_callback;
    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoParamStruct *_stack =(BasicHttpBinding_IGraphs4Social_Service_carregaGrafoParamStruct*)_stackStruct;
    return _operation( 
        _context,
        *(_stack->username),
        (_stack->carregaGrafoResult),
        (WS_ASYNC_CONTEXT*)_asyncContext,
        _error);
}
#pragma warning(default: 4055)  // conversion from data pointer to function pointer
#if (_MSC_VER >=1400) 
#pragma warning(pop)
#endif

typedef struct BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumParamStruct 
{
    WCHAR** username1;
    WCHAR** username2;
    WCHAR** carregaGrafoAmigosComumResult;
} BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumParamStruct;

#if (_MSC_VER >=1400) 
#pragma warning(push)
#endif
#pragma warning(disable: 4055) // conversion from data pointer to function pointer
HRESULT CALLBACK BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumOperationStub(
    __in const WS_OPERATION_CONTEXT* _context,
    __in void* _stackStruct,
    __in const void* _callback,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumCallback _operation = (BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumCallback)_callback;
    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumParamStruct *_stack =(BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumParamStruct*)_stackStruct;
    return _operation( 
        _context,
        *(_stack->username1),
        *(_stack->username2),
        (_stack->carregaGrafoAmigosComumResult),
        (WS_ASYNC_CONTEXT*)_asyncContext,
        _error);
}
#pragma warning(default: 4055)  // conversion from data pointer to function pointer
#if (_MSC_VER >=1400) 
#pragma warning(pop)
#endif

typedef struct BasicHttpBinding_IGraphs4Social_Service_DoWorkParamStruct 
{
    WCHAR** DoWorkResult;
} BasicHttpBinding_IGraphs4Social_Service_DoWorkParamStruct;

#if (_MSC_VER >=1400) 
#pragma warning(push)
#endif
#pragma warning(disable: 4055) // conversion from data pointer to function pointer
HRESULT CALLBACK BasicHttpBinding_IGraphs4Social_Service_DoWorkOperationStub(
    __in const WS_OPERATION_CONTEXT* _context,
    __in void* _stackStruct,
    __in const void* _callback,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    BasicHttpBinding_IGraphs4Social_Service_DoWorkCallback _operation = (BasicHttpBinding_IGraphs4Social_Service_DoWorkCallback)_callback;
    BasicHttpBinding_IGraphs4Social_Service_DoWorkParamStruct *_stack =(BasicHttpBinding_IGraphs4Social_Service_DoWorkParamStruct*)_stackStruct;
    return _operation( 
        _context,
        (_stack->DoWorkResult),
        (WS_ASYNC_CONTEXT*)_asyncContext,
        _error);
}
#pragma warning(default: 4055)  // conversion from data pointer to function pointer
#if (_MSC_VER >=1400) 
#pragma warning(pop)
#endif
const static _tempuri_org_wsdlLocalDefinitions tempuri_org_wsdlLocalDefinitions =
{
    { // messages
        {    // message description for IGraphs4Social_Service_carregaGrafo_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafo_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafo
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafo, 
        },    // message description for IGraphs4Social_Service_carregaGrafo_InputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafo_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafo_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoResponse, 
        },    // message description for IGraphs4Social_Service_carregaGrafo_OutputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComum
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoAmigosComum, 
        },    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComumResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoAmigosComumResponse, 
        },    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage
        {    // message description for IGraphs4Social_Service_DoWork_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_DoWork_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/DoWork
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.DoWork, 
        },    // message description for IGraphs4Social_Service_DoWork_InputMessage
        {    // message description for IGraphs4Social_Service_DoWork_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_DoWork_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/DoWorkResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.DoWorkResponse, 
        },    // message description for IGraphs4Social_Service_DoWork_OutputMessage
    }, // end of messages 
    { // contracts
        {    // BasicHttpBinding_IGraphs4Social_Service,
            { // BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
                { // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)0, (USHORT)-1 },
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)-1, (USHORT)0 },
                },    // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
                {    // operation description for BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
                    1,
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_carregaGrafo_InputMessage, 
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_carregaGrafo_OutputMessage, 
                    0,
                    0,
                    2,
                    (WS_PARAMETER_DESCRIPTION*)tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafo.params,
                    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoOperationStub,
                    WS_NON_RPC_LITERAL_OPERATION
                }, //operation description for BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
            },  // BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
            { // BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
                { // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)0, (USHORT)-1 },
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)1, (USHORT)-1 },
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)-1, (USHORT)0 },
                },    // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
                {    // operation description for BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
                    1,
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage, 
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage, 
                    0,
                    0,
                    3,
                    (WS_PARAMETER_DESCRIPTION*)tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum.params,
                    BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComumOperationStub,
                    WS_NON_RPC_LITERAL_OPERATION
                }, //operation description for BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
            },  // BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
            { // BasicHttpBinding_IGraphs4Social_Service_DoWork
                { // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_DoWork
                    { WS_PARAMETER_TYPE_NORMAL, (USHORT)-1, (USHORT)0 },
                },    // parameter descriptions for BasicHttpBinding_IGraphs4Social_Service_DoWork
                {    // operation description for BasicHttpBinding_IGraphs4Social_Service_DoWork
                    1,
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_DoWork_InputMessage, 
                    (WS_MESSAGE_DESCRIPTION*)&tempuri_org_wsdl.messages.IGraphs4Social_Service_DoWork_OutputMessage, 
                    0,
                    0,
                    1,
                    (WS_PARAMETER_DESCRIPTION*)tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_DoWork.params,
                    BasicHttpBinding_IGraphs4Social_Service_DoWorkOperationStub,
                    WS_NON_RPC_LITERAL_OPERATION
                }, //operation description for BasicHttpBinding_IGraphs4Social_Service_DoWork
            },  // BasicHttpBinding_IGraphs4Social_Service_DoWork
            {    // array of operations for BasicHttpBinding_IGraphs4Social_Service
                (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafo.BasicHttpBinding_IGraphs4Social_Service_carregaGrafo,
                (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum.BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum,
                (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_DoWork.BasicHttpBinding_IGraphs4Social_Service_DoWork,
            },    // array of operations for BasicHttpBinding_IGraphs4Social_Service
            {    // contract description for BasicHttpBinding_IGraphs4Social_Service
            3,
            (WS_OPERATION_DESCRIPTION**)tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.operations,
            },  // end of contract description for BasicHttpBinding_IGraphs4Social_Service
        },    // BasicHttpBinding_IGraphs4Social_Service
    }, //  end of contracts 
    {// policies
        {
            WS_ENCODING_XML_UTF8,
            WS_ADDRESSING_VERSION_TRANSPORT,
            WS_ENVELOPE_VERSION_SOAP_1_1,
            { // channelPropertiesArray
                {
                    WS_CHANNEL_PROPERTY_ENCODING,
                    (void*)&tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.encoding,
                    sizeof(tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.encoding),
                },
                {
                    WS_CHANNEL_PROPERTY_ADDRESSING_VERSION,
                    (void*)&tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.addressingVersion,
                    sizeof(tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.addressingVersion),
                },
                {
                    WS_CHANNEL_PROPERTY_ENVELOPE_VERSION,
                    (void*)&tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.envelopeVersion,
                    sizeof(tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.envelopeVersion),
                },
            },
        },   // end of BasicHttpBinding_IGraphs4Social_Service,
    }, // policies
    {    // dictionary 
        { // xmlStrings
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/carregaGrafo",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 0),
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/carregaGrafoResponse",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 1),
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComum",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 2),
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComumResponse",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 3),
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/DoWork",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 4),
            WS_XML_STRING_DICTIONARY_VALUE("http://tempuri.org/IGraphs4Social_Service/DoWorkResponse",&tempuri_org_wsdlLocalDefinitions.dictionary.dict, 5),
        },  // end of xmlStrings
        
        {   // tempuri_org_wsdldictionary
        // 3454bf0f-22b0-445b-b9f2-cb41bcb188c1 
        { 0x3454bf0f, 0x22b0, 0x445b, { 0xb9, 0xf2, 0xcb,0x41, 0xbc, 0xb1, 0x88, 0xc1 } },
        (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings,
        6,
        TRUE,
        },
    },   //  end of dictionary
}; //  end of tempuri_org_wsdlLocalDefinitions


// operation: BasicHttpBinding_IGraphs4Social_Service_carregaGrafo
HRESULT WINAPI BasicHttpBinding_IGraphs4Social_Service_carregaGrafo(
    __in WS_SERVICE_PROXY* _serviceProxy,
    __in_opt __nullterminated WCHAR* username, 
    __deref_out_opt Grafo** carregaGrafoResult, 
    __in WS_HEAP* _heap,
    __in_ecount_opt(_callPropertyCount) const WS_CALL_PROPERTY* _callProperties,
    __in const ULONG _callPropertyCount,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    void* _argList[2]; 
    _argList[0] = &username;
    _argList[1] = &carregaGrafoResult;
    return WsCall(_serviceProxy,
        (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafo.BasicHttpBinding_IGraphs4Social_Service_carregaGrafo,
        (const void **)&_argList,
        _heap,
        _callProperties,
        _callPropertyCount,
        _asyncContext,
        _error);
}

// operation: BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum
HRESULT WINAPI BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum(
    __in WS_SERVICE_PROXY* _serviceProxy,
    __in_opt __nullterminated WCHAR* username1, 
    __in_opt __nullterminated WCHAR* username2, 
    __out_opt __deref __nullterminated WCHAR** carregaGrafoAmigosComumResult, 
    __in WS_HEAP* _heap,
    __in_ecount_opt(_callPropertyCount) const WS_CALL_PROPERTY* _callProperties,
    __in const ULONG _callPropertyCount,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    void* _argList[3]; 
    _argList[0] = &username1;
    _argList[1] = &username2;
    _argList[2] = &carregaGrafoAmigosComumResult;
    return WsCall(_serviceProxy,
        (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum.BasicHttpBinding_IGraphs4Social_Service_carregaGrafoAmigosComum,
        (const void **)&_argList,
        _heap,
        _callProperties,
        _callPropertyCount,
        _asyncContext,
        _error);
}

// operation: BasicHttpBinding_IGraphs4Social_Service_DoWork
HRESULT WINAPI BasicHttpBinding_IGraphs4Social_Service_DoWork(
    __in WS_SERVICE_PROXY* _serviceProxy,
    __out_opt __deref __nullterminated WCHAR** DoWorkResult, 
    __in WS_HEAP* _heap,
    __in_ecount_opt(_callPropertyCount) const WS_CALL_PROPERTY* _callProperties,
    __in const ULONG _callPropertyCount,
    __in_opt const WS_ASYNC_CONTEXT* _asyncContext,
    __in_opt WS_ERROR* _error)
{
    void* _argList[1]; 
    _argList[0] = &DoWorkResult;
    return WsCall(_serviceProxy,
        (WS_OPERATION_DESCRIPTION*)&tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.BasicHttpBinding_IGraphs4Social_Service_DoWork.BasicHttpBinding_IGraphs4Social_Service_DoWork,
        (const void **)&_argList,
        _heap,
        _callProperties,
        _callPropertyCount,
        _asyncContext,
        _error);
}
const _tempuri_org_wsdl tempuri_org_wsdl =
{
    {// messages
        {    // message description for IGraphs4Social_Service_carregaGrafo_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafo_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafo
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafo, 
        },    // message description for IGraphs4Social_Service_carregaGrafo_InputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafo_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafo_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoResponse, 
        },    // message description for IGraphs4Social_Service_carregaGrafo_OutputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComum
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoAmigosComum, 
        },    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_InputMessage
        {    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/carregaGrafoAmigosComumResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.carregaGrafoAmigosComumResponse, 
        },    // message description for IGraphs4Social_Service_carregaGrafoAmigosComum_OutputMessage
        {    // message description for IGraphs4Social_Service_DoWork_InputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_DoWork_InputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/DoWork
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.DoWork, 
        },    // message description for IGraphs4Social_Service_DoWork_InputMessage
        {    // message description for IGraphs4Social_Service_DoWork_OutputMessage
            (WS_XML_STRING*)&tempuri_org_wsdlLocalDefinitions.dictionary.xmlStrings.IGraphs4Social_Service_DoWork_OutputMessageactionName, // http://tempuri.org/IGraphs4Social_Service/DoWorkResponse
            (WS_ELEMENT_DESCRIPTION*)&tempuri_org_xsd.globalElements.DoWorkResponse, 
        },    // message description for IGraphs4Social_Service_DoWork_OutputMessage
    }, // messages
    {// contracts
        {   // BasicHttpBinding_IGraphs4Social_Service
            3,
            (WS_OPERATION_DESCRIPTION**)tempuri_org_wsdlLocalDefinitions.contracts.BasicHttpBinding_IGraphs4Social_Service.operations,
        },    // end of BasicHttpBinding_IGraphs4Social_Service
    }, // contracts
    { // policies
        {  // template description for BasicHttpBinding_IGraphs4Social_Service
            {  // channel properties
                (WS_CHANNEL_PROPERTY*)&tempuri_org_wsdlLocalDefinitions.policies.BasicHttpBinding_IGraphs4Social_Service.channelPropertiesArray,
                3,
            },
        },  // end of template description
    },  // policies
}; // end of _tempuri_org_wsdl

HRESULT BasicHttpBinding_IGraphs4Social_Service_CreateServiceProxy(
    __in_opt WS_HTTP_BINDING_TEMPLATE* templateValue,
    __in_ecount_opt(proxyPropertyCount) const WS_PROXY_PROPERTY* proxyProperties,
    __in const ULONG proxyPropertyCount,
    __deref_out_opt WS_SERVICE_PROXY** _serviceProxy,
    __in_opt WS_ERROR* error)
{
    return WsCreateServiceProxyFromTemplate(
        WS_CHANNEL_TYPE_REQUEST,
        proxyProperties,
        proxyPropertyCount,
        WS_HTTP_BINDING_TEMPLATE_TYPE,
        templateValue,
        templateValue == NULL ? 0 : sizeof(WS_HTTP_BINDING_TEMPLATE),
        &tempuri_org_wsdl.policies.BasicHttpBinding_IGraphs4Social_Service,
        sizeof(tempuri_org_wsdl.policies.BasicHttpBinding_IGraphs4Social_Service),
        _serviceProxy,
        error);
}

HRESULT BasicHttpBinding_IGraphs4Social_Service_CreateServiceEndpoint(
    __in_opt WS_HTTP_BINDING_TEMPLATE* templateValue,
    __in_opt CONST WS_STRING* address,
    __in_opt struct BasicHttpBinding_IGraphs4Social_ServiceFunctionTable* functionTable,
    __in_opt WS_SERVICE_SECURITY_CALLBACK authorizationCallback,
    __in_ecount_opt(endpointPropertyCount) WS_SERVICE_ENDPOINT_PROPERTY* endpointProperties,
    __in const ULONG endpointPropertyCount,
    __in WS_HEAP* heap,
    __deref_out_opt WS_SERVICE_ENDPOINT** serviceEndpoint,
    __in_opt WS_ERROR* error)
{
    WS_SERVICE_CONTRACT serviceContract;
    serviceContract.contractDescription = &tempuri_org_wsdl.contracts.BasicHttpBinding_IGraphs4Social_Service;
    serviceContract.defaultMessageHandlerCallback = 0;
    serviceContract.methodTable = (const void*)functionTable;
    
    return WsCreateServiceEndpointFromTemplate(
        WS_CHANNEL_TYPE_REPLY,
        endpointProperties,
        endpointPropertyCount,
        address,
        &serviceContract,
        authorizationCallback,
        heap,
        WS_HTTP_BINDING_TEMPLATE_TYPE,
        templateValue,
        templateValue == NULL ? 0 : sizeof(WS_HTTP_BINDING_TEMPLATE),
        &tempuri_org_wsdl.policies.BasicHttpBinding_IGraphs4Social_Service,
        sizeof(tempuri_org_wsdl.policies.BasicHttpBinding_IGraphs4Social_Service),
        serviceEndpoint,
        error);
}
