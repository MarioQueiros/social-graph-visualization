// WebService.cpp : Defines the entry point for the console application.
//

#include "Webservice.h"
#include "stdafx.h"
#include "WebServices.h"
#include "schemas.microsoft.com.2003.10.Serialization.Arrays.xsd.h"
#include "schemas.microsoft.com.2003.10.Serialization.xsd.h"
#include "tempuri.org.xsd.h"
#include "tempuri.org.wsdl.h"
#include "schema.xsd.h"

Grafo webServiceRequest(char* user)
{
	wstring text1;
	copy(user, user + strlen(user), back_inserter(text1));
	//
	WCHAR* username = const_cast<wchar_t*>( text1.c_str() );
	//0063f248
	//
	//
	//
	//
	//	Abrir apartir de um ficheiro, errado por causa dos espa�os que s�o omitidos
	/*ifstream myfile;

	myfile.open ("webservice.grafo", ios::in);
	if (!myfile.is_open()) {
	cout << "Erro ao abrir " << "webservice.grafo" << "para ler" <<endl;
	exit(1);
	}

	char * aux1 = new char[100];
	int z = 0;

	while(!myfile.eof()){
	myfile >> aux1[z];
	z++;
	}

	myfile.close();

	wstring aux2;
	copy(aux1, aux1 + strlen(aux1), back_inserter(aux2));

	WCHAR * result = const_cast<wchar_t*>( aux2.c_str() );
	*/



	HRESULT hr = ERROR_SUCCESS; 
	WS_ERROR* error = NULL; 
	WS_HEAP* heap = NULL; 
	WS_SERVICE_PROXY* proxy = NULL; 
	WS_ENDPOINT_ADDRESS address = {};


	//endere�o do servi�o 
	WS_STRING url=WS_STRING_VALUE(L"http://wvm035.dei.isep.ipp.pt/Graphs4Social_WebService/Graphs4Social_Service.svc"); 


	address.url = url; 
	hr = WsCreateHeap(10240, 512, NULL, 0, &heap, error);
	WS_HTTP_BINDING_TEMPLATE templ = {};



	//cria��o do proxy para o servi�o 
	hr = BasicHttpBinding_IGraphs4Social_Service_CreateServiceProxy(&templ, NULL, 0, &proxy, error); 
	hr = WsOpenServiceProxy(proxy, &address, NULL, error);
	Grafo * result ;

	
	//chamada de uma opera��o do servi�o alvo. O resultado vem no par�metro result 
	hr = BasicHttpBinding_IGraphs4Social_Service_carregaGrafo(proxy, username, &result,heap, NULL, 0, NULL, error);




	if(proxy){ 
		WsCloseServiceProxy(proxy, NULL, NULL); 
		WsFreeServiceProxy(proxy); 
	}
	/*if(heap){
		WsFreeHeap(heap);
	} 
	if(error){ 
		WsFreeError(error);
	}*/

	return *result;
}

char * webServiceCaminhoCurto(char* user1, char* user2){

	wstring text1,text2;
	copy(user1, user1 + strlen(user1), back_inserter(text1));
	//
	WCHAR* username1 = const_cast<wchar_t*>( text1.c_str() );
	
	copy(user2, user2 + strlen(user2), back_inserter(text2));
	//
	WCHAR* username2 = const_cast<wchar_t*>( text2.c_str() );

	HRESULT hr = ERROR_SUCCESS; 
	WS_ERROR* error = NULL; 
	WS_HEAP* heap = NULL; 
	WS_SERVICE_PROXY* proxy = NULL; 
	WS_ENDPOINT_ADDRESS address = {};


	//endere�o do servi�o 
	WS_STRING url=WS_STRING_VALUE(L"http://wvm035.dei.isep.ipp.pt/Graphs4Social_WebService/Graphs4Social_Service.svc"); 


	address.url = url; 
	hr = WsCreateHeap(10240, 512, NULL, 0, &heap, error);
	WS_HTTP_BINDING_TEMPLATE templ = {};

	//cria��o do proxy para o servi�o 
	hr = BasicHttpBinding_IGraphs4Social_Service_CreateServiceProxy(&templ, NULL, 0, &proxy, error); 
	hr = WsOpenServiceProxy(proxy, &address, NULL, error);
	WCHAR * result ;

	
	//chamada de uma opera��o do servi�o alvo. O resultado vem no par�metro result 
	hr = BasicHttpBinding_IGraphs4Social_Service_caminhoMaisCurto(proxy, username1,username2,&result,heap, NULL, 0, NULL, error);




	if(proxy){ 
		WsCloseServiceProxy(proxy, NULL, NULL); 
		WsFreeServiceProxy(proxy); 
	}


	size_t buffersize = wcslen(result);
	size_t num;
	char* returnValueChar = (char *)malloc( buffersize );

	wcstombs_s(&num,returnValueChar,buffersize+1,result,buffersize+1);


	/*if(heap){
		WsFreeHeap(heap);
	} 
	if(error){ 
		WsFreeError(error);
	}*/

	return returnValueChar;
}


bool webServiceVerificarUser(char* user1){

	wstring text1;
	copy(user1, user1 + strlen(user1), back_inserter(text1));
	//
	WCHAR* username1 = const_cast<wchar_t*>( text1.c_str() );

	HRESULT hr = ERROR_SUCCESS; 
	WS_ERROR* error = NULL; 
	WS_HEAP* heap = NULL; 
	WS_SERVICE_PROXY* proxy = NULL; 
	WS_ENDPOINT_ADDRESS address = {};


	//endere�o do servi�o 
	WS_STRING url=WS_STRING_VALUE(L"http://wvm035.dei.isep.ipp.pt/Graphs4Social_WebService/Graphs4Social_Service.svc"); 


	address.url = url; 
	hr = WsCreateHeap(10240, 512, NULL, 0, &heap, error);
	WS_HTTP_BINDING_TEMPLATE templ = {};

	//cria��o do proxy para o servi�o 
	hr = BasicHttpBinding_IGraphs4Social_Service_CreateServiceProxy(&templ, NULL, 0, &proxy, error); 
	hr = WsOpenServiceProxy(proxy, &address, NULL, error);
	BOOL result ;

	
	//chamada de uma opera��o do servi�o alvo. O resultado vem no par�metro result 
	hr = BasicHttpBinding_IGraphs4Social_Service_verificarUser(proxy,username1,&result,heap,NULL,0,NULL,error);




	if(proxy){ 
		WsCloseServiceProxy(proxy, NULL, NULL); 
		WsFreeServiceProxy(proxy); 
	}


	


	/*if(heap){
		WsFreeHeap(heap);
	} 
	if(error){ 
		WsFreeError(error);
	}*/

	return result;
}