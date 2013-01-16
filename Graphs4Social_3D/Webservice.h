#ifndef _WEBSERVICE_INCLUDE
#define _WEBSERVICE_INCLUDE


#include <string>
#include <iostream>
#include <stdlib.h> 
#include <iostream>
#include <fstream>
#include "schema.xsd.h"
using namespace std;

Grafo webServiceRequest(char* user);

char * webServiceCaminhoCurto(char* user1, char * user2);

bool webServiceVerificarUser(char * user);
#endif