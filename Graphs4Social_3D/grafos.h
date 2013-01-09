#ifndef _GRAFO_INCLUDE
#define _GRAFO_INCLUDE

#define _MAX_NOS_GRAFO 100
#define _MAX_ARCOS_GRAFO 200

#define NORTE_SUL	0
#define ESTE_OESTE	1
#define PLANO		2

#define VELOCIDADE_VERTICAL 4
#define VELOCIDADE_HORIZONTAL 4
#define DIMEMSAO_CAMARA 4
#define DISTANCIA_SOLO 2
#define JANELA_TOP      0
#define NUM_JANELAS     2
#define	CHAO_DIMENSAO	100
#define	OBJECTO_ALTURA	0.8

typedef struct No{
	float x,y,z,largura;
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

#endif