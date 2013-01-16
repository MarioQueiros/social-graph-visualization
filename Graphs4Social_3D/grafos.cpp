#include "grafos.h"
#include <iostream>
#include <fstream>
#include "Webservice.h"
#include "schemas.microsoft.com.2003.10.Serialization.Arrays.xsd.h"
#include "schemas.microsoft.com.2003.10.Serialization.xsd.h"
#include "tempuri.org.xsd.h"
#include "tempuri.org.wsdl.h"
#include "schema.xsd.h"
#include <vector>

#define __GRAFO__FILE__ "exemplo.grafo"

No nos[_MAX_NOS_GRAFO];
Arco arcos[_MAX_ARCOS_GRAFO];
int numNos=0, numArcos=0;

using namespace std;

void addNo(No no){
	if(numNos<_MAX_NOS_GRAFO){
		nos[numNos]=no;
		numNos++;
	}else{
		cout << "Número de nós chegou ao limite" << endl;
	}
}

void deleteNo(int indNo){
	if(indNo>=0 && indNo<numNos){
		for(int i=indNo; i<numNos; nos[i++]=nos[i+i]);
		numNos--;
	}else{
		cout << "Indíce de nó inválido" << endl;
	}
}

void imprimeNo(No no){
	cout << "X:" << no.x << "Y:" << no.y << "Z:" << no.z <<endl;
}

void listNos(){
	for(int i=0; i<numNos; imprimeNo(nos[i++]));
}

No criaNo(float x, float y, float z){
	No no;
	no.x=x;
	no.y=y;
	no.z=z;
	return no;
}

void addArco(Arco arco){
	if(numArcos<_MAX_ARCOS_GRAFO){
		arcos[numArcos]=arco;
		numArcos++;
	}else{
		cout << "Número de arcos chegou ao limite" << endl;
	}
}

void deleteArco(int indArco){
	if(indArco>=0 && indArco<numArcos){
		for(int i=indArco; i<numArcos; arcos[i++]=arcos[i+i]);
		numArcos--;
	}else{
		cout << "Indíce de arco inválido" << endl;
	}
}

void imprimeArco(Arco arco){
	cout << "No início:" << arco.noi << "Nó final:" << arco.nof << "Peso:" << arco.peso << "Largura:" << arco.largura << endl;
}

void listArcos(){
	for(int i=0; i<numArcos; imprimeArco(arcos[i++]));
}

Arco criaArco(int noi, int nof, float peso, float largura){
	Arco arco;
	arco.noi=noi;
	arco.nof=nof;
	arco.peso=peso;
	arco.largura=largura;
	return arco;
}

void gravaGrafo(){
	ofstream myfile;

	myfile.open (__GRAFO__FILE__, ios::out);
	if (!myfile.is_open()) {
		cout << "Erro ao abrir " << __GRAFO__FILE__ << "para escrever" <<endl;
		exit(1);
	}
	myfile << numNos << endl;
	for(int i=0; i<numNos;i++)
		myfile << nos[i].x << " " << nos[i].y << " " << nos[i].z <<endl;
	myfile << numArcos << endl;
	for(int i=0; i<numArcos;i++)
		myfile << arcos[i].noi << " " << arcos[i].nof << " " << arcos[i].peso << " " << arcos[i].largura << endl;
	myfile.close();
}
void leGrafo(){
	ifstream myfile;
	
	myfile.open (__GRAFO__FILE__, ios::in);
	if (!myfile.is_open()) {
		cout << "Erro ao abrir " << __GRAFO__FILE__ << "para ler" <<endl;
		exit(1);
	}
	myfile >> numNos;
	for(int i=0; i<numNos;i++)
		myfile >> nos[i].x >> nos[i].y >> nos[i].z>>nos[i].largura;
	myfile >> numArcos ;
	for(int i=0; i<numArcos;i++)
		myfile >> arcos[i].noi >> arcos[i].nof >> arcos[i].peso >> arcos[i].largura ;
	myfile.close();
}

bool carregaGrafo(char* username){
	try{
		Grafo grafo = webServiceRequest(username);


		numNos = grafo.NrNos;
		numArcos = grafo.NrArcos;

		for(int i = 0;i< grafo.UsersCount; i++){
			User * u = grafo.Users[i];

			nos[i].x = (float)(*u).X;
			nos[i].y = (float)(*u).Y;
			nos[i].z = (float)(*u).Z;
			nos[i].largura = (float)(*u).Raio;


			size_t buffersize = wcslen((*u).Username);
			size_t num;
			char* returnValueChar = (char *)malloc( buffersize );

			wcstombs_s(&num,returnValueChar,buffersize+1,(*u).Username,buffersize+1);

			nos[i].username = returnValueChar;

			for(int k = 0; k< (*u).ProfileCount;k++){

				WCHAR * prof = (*u).Profile[k];

				buffersize = wcslen(prof);

				returnValueChar = (char *)malloc( buffersize );

				wcstombs_s(&num,returnValueChar,buffersize+1,prof,buffersize+1);

				nos[i].profile.push_back(returnValueChar);
			}

			for(int k = 0; k< (*u).TagsCount;k++){

				WCHAR * tag = (*u).Tags[k];

				buffersize = wcslen(tag);

				returnValueChar = (char *)malloc( buffersize );

				wcstombs_s(&num,returnValueChar,buffersize+1,tag,buffersize+1);

				nos[i].tags.push_back(returnValueChar);
			}

		}

		for(int i = 0;i< grafo.LigacoesCount; i++){
			//arcos[i].noi >> arcos[i].nof >> arcos[i].peso >> arcos[i].largura ;
			Ligacao * l = grafo.Ligacoes[i];

			arcos[i].noi = (*(*l).User1).Id;
			arcos[i].nof = (*(*l).User2).Id;

			arcos[i].largura = (float)(*l).Forca;
			arcos[i].peso = (float)(*l).Peso;

			size_t buffersize = wcslen((*l).Tag);
			size_t num;
			char* returnValueChar = (char *)malloc( buffersize );

			wcstombs_s(&num,returnValueChar,buffersize+1,(*l).Tag,buffersize+1);

			arcos[i].tagRelacao = returnValueChar;


		}

		return true;
	}catch(exception e){

		return false;
	}
}

