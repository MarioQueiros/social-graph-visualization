// WebService.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "WebServices.h"
#include "schemas.microsoft.com.2003.10.Serialization.xsd.h"
#include "tempuri.org.xsd.h"
#include "tempuri.org.wsdl.h"
#include <string>
#include <iostream>
#include <stdlib.h> 
#include <iostream>
#include <fstream>
using namespace std;


static string webServiceRequest(char* user)
{
	wstring text1;
	copy(user, user + strlen(user), back_inserter(text1));
	//
	WCHAR* username = const_cast<wchar_t*>( text1.c_str() );
	//
	//
	//
	//
	//
	//	Abrir apartir de um ficheiro, errado por causa dos espaços que são omitidos
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
	
	
	
	//endereço do serviço 
	WS_STRING url=WS_STRING_VALUE(L"http://wvm035.dei.isep.ipp.pt/Graphs4Social_WebService/Graphs4Social_Service.svc"); 
	
	
	address.url = url; 
	hr = WsCreateHeap(5120, 512, NULL, 0, &heap, error); 
	WS_HTTP_BINDING_TEMPLATE templ = {};
	
	
	
	//criação do proxy para o serviço 
	hr = BasicHttpBinding_IGraphs4Social_Service_CreateServiceProxy(&templ, NULL, 0, &proxy, error); 
	hr = WsOpenServiceProxy(proxy, &address, NULL, error); 
	WCHAR * result;


	
	//chamada de uma operação do serviço alvo. O resultado vem no parâmetro result 
	hr = BasicHttpBinding_IGraphs4Social_Service_carregaGrafo(proxy, username, &result,heap, NULL, 0, NULL, error); 
	



	if(proxy){ 
	WsCloseServiceProxy(proxy, NULL, NULL); 
	WsFreeServiceProxy(proxy); 
	}

	

	wstring returnValue = result;
	size_t buffersize = wcslen(result);
	size_t num;


	char* returnValueChar = (char *)malloc( buffersize );
	
	wcstombs_s(&num,returnValueChar,buffersize+1,result,buffersize+1);

	if(heap){
		WsFreeHeap(heap);
	} 
	if(error){ 
		WsFreeError(error);
	}

	return returnValueChar;
}

int _tmain(int argc, _TCHAR* argv[])
{

	
	string result = webServiceRequest("Mario");

	printf("%s",result.c_str());

	while(true);
}