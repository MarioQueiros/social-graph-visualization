#ifndef _GRAFO_INCLUDE
#define _GRAFO_INCLUDE

#define _MAX_NOS_GRAFO 100
#define _MAX_ARCOS_GRAFO 200

#define NORTE_SUL	0
#define ESTE_OESTE	1
#define PLANO		2

#define VELOCIDADE_VERTICAL 8
#define VELOCIDADE_HORIZONTAL 8
#define DIMEMSAO_CAMARA 4
#define DISTANCIA_SOLO 2
#define JANELA_TOP      0
#define NUM_JANELAS     2
#define	CHAO_DIMENSAO	100
#define	OBJECTO_ALTURA	0.8
#define BUFSIZE			100
#define SCALE_HOMER	    0.05

//texturas
#define NOME_TEXTURA_CHAO         "images/solo.jpg"
#define NOME_TEXTURA_UPSET		  "images/Upset.jpg"
#define NOME_TEXTURA_SMILEY		  "images/Smiley.jpg"
#define NOME_TEXTURA_BORED		  "images/Bored.jpg"
#define NOME_TEXTURA_PLEASED	  "images/Pleased.jpg"
#define NOME_TEXTURA_SAD		  "images/Sad.jpg"
#define NOME_TEXTURA_SLEPPY		  "images/Sleepy.jpg"
#define NOME_TEXTURA_TEARDS		  "images/Teards.jpg"
#define NOME_TEXTURA_PAREDE		  "images/wallpaper.jpg"
#define NOME_TEXTURA_TOOLTIP	  "images/tool.jpg"
#define NUM_TEXTURAS              10
#define ID_TEXTURA_CHAO           0
#define ID_TEXTURA_PAREDE		  2
#define ID_TEXTURA_TOOLTIP		  3
#define ID_TEXTURA_BORED		  1
#define ID_TEXTURA_SMILEY         4
#define ID_TEXTURA_UPSET	      5
#define ID_TEXTURA_PLEASED		  6
#define ID_TEXTURA_SAD		      7
#define ID_TEXTURA_SLEEPY	      8
#define ID_TEXTURA_TEARDS	      9

#define JANELA_TOP                0

#include <string>
#include <vector>
using namespace std;

typedef struct No{
	float x,y,z;
	float largura;

	string username;
	vector<string> tags;
	vector<string> profile;
}No;

typedef struct Arco{
	int noi,nof;
	float peso,largura;
}Arco;

extern No nos[];
extern Arco arcos[];
extern int numNos, numArcos;

void addNo(No);
void deleteNo(int);
void imprimeNo(No);
void listNos();
No criaNo(float, float, float);

void addArco(Arco);
void deleteArco(int);
void imprimeArco(Arco);
void listArcos();
Arco criaArco(int, int, float, float);

void gravaGrafo();
void leGrafo();
bool carregaGrafo(char* username);

#endif