#define _USE_MATH_DEFINES
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>  
#include <GL\glut.h>
#include <iostream>
#include "grafos.h"
#include <GL/glaux.h>
using namespace std;

#define graus(X) (double)((X)*180/M_PI)
#define rad(X)   (double)((X)*M_PI/180)
#define NO		1
#define ARCO	10000
// luzes e materiais

const GLfloat mat_ambient[][4] = {
	{0.33, 0.22, 0.03, 1.0},			// brass
	{0.0, 0.0, 0.0},					// red plastic
	{0.0215, 0.1745, 0.0215},			// emerald
	{0.02, 0.02, 0.02},					// slate
	{0.0, 0.0, 0.1745},					// azul
	{0.02, 0.02, 0.02},					// preto
	{0.1745, 0.1745, 0.1745}};			// cinza

const GLfloat mat_diffuse[][4] = {
	{0.78, 0.57, 0.11, 1.0},			// brass
	{0.5, 0.0, 0.0},					// red plastic
	{0.07568, 0.61424, 0.07568},		// emerald
	{0.78, 0.78, 0.78},					// slate
	{0.0, 0.0,  0.61424},				// azul
	{0.08, 0.08, 0.08},					// preto
	{0.61424, 0.61424, 0.61424}};		// cinza

const GLfloat mat_specular[][4] = {
	{0.99, 0.91, 0.81, 1.0},			// brass
	{0.7, 0.6, 0.6},					// red plastic
	{0.633, 0.727811, 0.633},			// emerald
	{0.14, 0.14, 0.14},					// slate
	{0.0, 0.0, 0.727811},				// azul
	{0.03, 0.03, 0.03},					// preto
	{0.727811, 0.727811, 0.727811}};	// cinza

const GLfloat mat_shininess[] = {
	27.8,								// brass
	32.0,								// red plastic
	76.8,								// emerald
	18.78,								// slate
	30.0,								// azul
	75.0,								// preto
	60.0};								// cinza

enum tipo_material {brass, red_plastic, emerald, slate, azul, preto, cinza};

#ifdef __cplusplus
inline tipo_material operator++(tipo_material &rs, int ) {
	return rs = (tipo_material)(rs + 1);
}
#endif

typedef	GLdouble Vertice[3];
typedef	GLdouble Vector[4];

GLfloat k = 1;
GLint  height = 512; 
GLint width = 640;

typedef struct Camera
{
	GLfloat fov;
	GLdouble dir_lat;
	GLdouble dir_long;
	GLfloat dist;
	Vertice center;
	GLfloat velv;
	GLfloat velh;
}Camera;

typedef struct teclas_t
{
	GLboolean   up,down,left,right,a,q;
}teclas_t;

typedef struct Estado
{
	Camera		camera;
	int			xMouse,yMouse;
	GLboolean	light;
	GLboolean	apresentaNormais;
	GLint		lightViewer;
	GLint		eixoTranslaccao;
	GLdouble	eixo[3];
	teclas_t    teclas;
	GLint       timer;
	GLint		k;
	GLboolean	vooRasante;
}Estado;

typedef struct Modelo {
#ifdef __cplusplus
	tipo_material cor_cubo;
#else
	enum tipo_material cor_cubo;
#endif

	GLfloat g_pos_luz1[4];
	GLfloat g_pos_luz2[4];

	GLfloat escala;
	GLUquadric *quad;
}Modelo;

Estado estado;
Modelo modelo;

void initEstado()
{
	estado.camera.dir_lat=M_PI/4;
	estado.camera.dir_long=-M_PI/4;
	estado.camera.fov=60;
	estado.camera.dist=0.01;
	estado.eixo[0]=0;
	estado.eixo[1]=0;
	estado.eixo[2]=0;
	estado.camera.center[0]=-130;
	estado.camera.center[1]=0;
	estado.camera.center[2]=90;
	estado.light=GL_FALSE;
	estado.apresentaNormais=GL_FALSE;
	estado.lightViewer=2;
	estado.k = 1;
	estado.camera.velh = VELOCIDADE_HORIZONTAL;
	estado.camera.velv = VELOCIDADE_VERTICAL;
}

void initModelo()
{
	modelo.escala=0.2;
	modelo.cor_cubo = brass;
	modelo.g_pos_luz1[0]=-5.0;
	modelo.g_pos_luz1[1]= 5.0;
	modelo.g_pos_luz1[2]= 5.0;
	modelo.g_pos_luz1[3]= 0.0;
	modelo.g_pos_luz2[0]= 5.0;
	modelo.g_pos_luz2[1]= -15.0;
	modelo.g_pos_luz2[2]= 5.0;
	modelo.g_pos_luz2[3]= 0.0;
}

void myInit()
{
	GLfloat LuzAmbiente[]={0.5,0.5,0.5, 0.0};

	glClearColor (0.0, 0.0, 0.0, 0.0);

	glEnable(GL_SMOOTH); /*enable smooth shading */
	glEnable(GL_LIGHTING); /* enable lighting */
	glEnable(GL_DEPTH_TEST); /* enable z buffer */
	glEnable(GL_NORMALIZE);

	glDepthFunc(GL_LESS);

	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, LuzAmbiente); 
	glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, estado.lightViewer); 
	glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE); 

	initModelo();
	initEstado();
	modelo.quad=gluNewQuadric();
	gluQuadricDrawStyle(modelo.quad, GLU_FILL);
	gluQuadricNormals(modelo.quad, GLU_OUTSIDE);

	leGrafo();
}

void imprime_ajuda(void)
{
	printf("Desenho de um labirinto a partir de um grafo\n\n");
	printf("h,H - Ajuda \n");
	printf("i,I - Repor os valores iniciais\n");
	printf("ESC - Sair \n");

	printf("\n******* Grafo ******* \n");
	printf("F1  - Cria novo grafo\n");
	printf("F2  - Ler grafo de ficheiro \n");
	printf("F6  - Grava grafo em ficheiro \n");

	printf("\n******* Desenho ******* \n");
	printf("f,F - PolygonMode Fill \n");
	printf("w,W - PolygonMode Wireframe \n");
	printf("p,P - PolygonMode Point \n");

	printf("\n******* Iluminacao ******* \n");
	printf("l,L - Luz fixa em relacao a cena/viewport\n");
	printf("k,K - Alerna luz de camera com luz global \n");
	printf("c,C - Liga/Desliga Cull Face \n");

	printf("\n******* Camera ******* \n");
	printf("Botao esquerdo - Rodar camera\n");

	printf("\nVoo Livre\n");
	printf("q/Q/a/A - Subir/descer\n");
	printf("Up/Down - Avancar/recuar\n");
	printf("Left/Right - Rodar para a esquerda/direita");

	printf("\nVoo Rasante\n");
	printf("Up/Down - Avancar/recuar\n");
	printf("Left/Right - Rodar para a esquerda/direita");
}

void material(enum tipo_material mat)
{
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, mat_ambient[mat]);
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, mat_diffuse[mat]);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_specular[mat]);
	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, mat_shininess[mat]);
}

const GLfloat red_light[] = {1.0, 0.0, 0.0, 1.0};
const GLfloat green_light[] = {0.0, 1.0, 0.0, 1.0};
const GLfloat blue_light[] = {0.0, 0.0, 1.0, 1.0};
const GLfloat white_light[] = {1.0, 1.0, 1.0, 1.0};

void putLights(GLfloat* diffuse)
{
	const GLfloat white_amb[] = {0.2, 0.2, 0.2, 1.0};

	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
	glLightfv(GL_LIGHT0, GL_SPECULAR, white_light);
	glLightfv(GL_LIGHT0, GL_AMBIENT, white_amb);
	glLightfv(GL_LIGHT0, GL_POSITION, modelo.g_pos_luz1);

	glLightfv(GL_LIGHT1, GL_DIFFUSE, diffuse);
	glLightfv(GL_LIGHT1, GL_SPECULAR, white_light);
	glLightfv(GL_LIGHT1, GL_AMBIENT, white_amb);
	glLightfv(GL_LIGHT1, GL_POSITION, modelo.g_pos_luz2);

	/* desenhar luz */
	material(red_plastic);
	glPushMatrix();
	glTranslatef(modelo.g_pos_luz1[0], modelo.g_pos_luz1[1], modelo.g_pos_luz1[2]);
	glDisable(GL_LIGHTING);
	glColor3f(1.0, 1.0, 1.0);
	glutSolidCube(0.1);
	glEnable(GL_LIGHTING);
	glPopMatrix();
	glPushMatrix();
	glTranslatef(modelo.g_pos_luz2[0], modelo.g_pos_luz2[1], modelo.g_pos_luz2[2]);
	glDisable(GL_LIGHTING);
	glColor3f(1.0, 1.0, 1.0);
	glutSolidCube(0.1);
	glEnable(GL_LIGHTING);
	glPopMatrix();

	glEnable(GL_LIGHT0);
	glEnable(GL_LIGHT1);
}

void desenhaSolo()
{
#define STEP 10
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-300;i<300;i+=STEP)
		for(int j=-300;j<300;j+=STEP){
			glVertex2f(i,j);
			glVertex2f(i+STEP,j);
			glVertex2f(i+STEP,j+STEP);
			glVertex2f(i,j+STEP);
		}
		glEnd();
}

void CrossProduct (GLdouble v1[], GLdouble v2[], GLdouble cross[])
{
	cross[0] = v1[1]*v2[2] - v1[2]*v2[1];
	cross[1] = v1[2]*v2[0] - v1[0]*v2[2];
	cross[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

GLdouble VectorNormalize (GLdouble v[])
{
	int		i;
	GLdouble	length;

	if ( fabs(v[1] - 0.000215956) < 0.0001)
		i=1;

	length = 0;
	for (i=0 ; i< 3 ; i++)
		length += v[i]*v[i];
	length = sqrt (length);
	if (length == 0)
		return 0;

	for (i=0 ; i< 3 ; i++)
		v[i] /= length;	

	return length;
}

void desenhaNormal(GLdouble x, GLdouble y, GLdouble z, GLdouble normal[], tipo_material mat)
{

	switch (mat){
	case red_plastic:
		glColor3f(1,0,0);
		break;
	case azul:
		glColor3f(0,0,1);
		break;
	case emerald:
		glColor3f(0,1,0);
		break;
	default:
		glColor3f(1,1,0);
	}
	glDisable(GL_LIGHTING);
	glPushMatrix();
	glTranslated(x,y,z);
	glScaled(0.4,0.4,0.4);
	glBegin(GL_LINES);
	glVertex3d(0,0,0);
	glVertex3dv(normal);
	glEnd();
	glPopMatrix();
	glEnable(GL_LIGHTING);
}

void desenhaChao(GLfloat xi, GLfloat yi, GLfloat zi, GLfloat xf, GLfloat yf, GLfloat zf, int orient)
{
	GLdouble v1[3],v2[3],cross[3];
	GLdouble length;
	v1[0]=xf-xi;
	v1[1]=0;
	v2[0]=0;
	v2[1]=yf-yi;

	switch(orient) {
	case NORTE_SUL :
		v1[2]=0;
		v2[2]=zf-zi;
		CrossProduct(v1,v2,cross);
		//printf("cross x=%lf y=%lf z=%lf",cross[0],cross[1],cross[2]);
		length=VectorNormalize(cross);
		//printf("Normal x=%lf y=%lf z=%lf length=%lf\n",cross[0],cross[1],cross[2]);

		material(red_plastic);
		glBegin(GL_QUADS);
		glNormal3dv(cross);
		glVertex3f(xi,yi,zi);
		glVertex3f(xf,yi,zi);
		glVertex3f(xf,yf,zf);
		glVertex3f(xi,yf,zf);
		glEnd();
		if(estado.apresentaNormais) {
			desenhaNormal(xi,yi,zi,cross,red_plastic);
			desenhaNormal(xf,yi,zi,cross,red_plastic);
			desenhaNormal(xf,yf,zf,cross,red_plastic);
			desenhaNormal(xi,yi,zf,cross,red_plastic);
		}
		break;
	case ESTE_OESTE :
		v1[2]=zf-zi;
		v2[2]=0;
		CrossProduct(v1,v2,cross);
		//printf("cross x=%lf y=%lf z=%lf",cross[0],cross[1],cross[2]);
		length=VectorNormalize(cross);
		//printf("Normal x=%lf y=%lf z=%lf length=%lf\n",cross[0],cross[1],cross[2]);
		material(red_plastic);
		glBegin(GL_QUADS);
		glNormal3dv(cross);
		glVertex3f(xi,yi,zi);
		glVertex3f(xf,yi,zf);
		glVertex3f(xf,yf,zf);
		glVertex3f(xi,yf,zi);
		glEnd();
		if(estado.apresentaNormais) {
			desenhaNormal(xi,yi,zi,cross,red_plastic);
			desenhaNormal(xf,yi,zf,cross,red_plastic);
			desenhaNormal(xf,yf,zf,cross,red_plastic);
			desenhaNormal(xi,yi,zi,cross,red_plastic);
		}
		break;
	default:
		cross[0]=0;
		cross[1]=0;
		cross[2]=1;
		material(azul);
		glBegin(GL_QUADS);
		glNormal3f(0,0,1);
		glVertex3f(xi,yi,zi);
		glVertex3f(xf,yi,zf);
		glVertex3f(xf,yf,zf);
		glVertex3f(xi,yf,zi);
		glEnd();
		if(estado.apresentaNormais) {
			desenhaNormal(xi,yi,zi,cross,azul);
			desenhaNormal(xf,yi,zf,cross,azul);
			desenhaNormal(xf,yf,zf,cross,azul);
			desenhaNormal(xi,yi,zi,cross,azul);
		}
		break;
	}
}

void desenhaEsfera(GLfloat xi, GLfloat yi, GLfloat zi, GLfloat raio)
{
	GLdouble cross[3];
	GLfloat valAng=0;
	GLint n=32;
	GLfloat nAng=2*M_PI/n;
	material(red_plastic);

	glPushMatrix();
	glNormal3f(0,0,1);
	glTranslatef(xi,yi,zi+10); //meter mais para cima
	for(int i=0;i<n;i++){
		glutSolidSphere(raio, 32, 32);
		valAng+=nAng;
	}

	glPopMatrix();
	if(estado.apresentaNormais) {
		cross[0]=0;
		cross[1]=0;
		cross[2]=1;
		desenhaNormal(xi,yi,zi,cross,azul);
		//	desenhaNormal(xf,yi,zf,cross,azul);
		//	desenhaNormal(xf,yf,zf,cross,azul);
		//	desenhaNormal(xi,yi,zi,cross,azul);
	}
}

void desenhaNo(int no)
{
	GLboolean norte,sul,este,oeste;
	GLfloat larguraNorte,larguraSul,larguraEste,larguraOeste;
	Arco arco=arcos[0];
	No *noi=&nos[no],*nof;
	norte=sul=este=oeste=GL_TRUE;
	desenhaEsfera(nos[no].x,nos[no].y,nos[no].z,nos[no].largura);
}

/*void desenhaNo(int no){
GLboolean norte,sul,este,oeste;
GLfloat larguraNorte,larguraSul,larguraEste,larguraOeste;
Arco arco=arcos[0];
No *noi=&nos[no],*nof;
norte=sul=este=oeste=GL_TRUE;
desenhaChao(nos[no].x-0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z,PLANO);
for(int i=0;i<numArcos; arco=arcos[++i]){
if(arco.noi==no)
nof=&nos[arco.nof];
else 
if(arco.nof==no)
nof=&nos[arco.noi];
else
continue;
if(noi->x==nof->x)
if(noi->y<nof->y){
norte=GL_FALSE;
larguraNorte=arco.largura;
}
else{
sul=GL_FALSE;
larguraSul=arco.largura;
}
else 
if(noi->y==nof->y)
if(noi->x<nof->x){
oeste=GL_FALSE;
larguraOeste=arco.largura;
}
else{
este=GL_FALSE;
larguraEste=arco.largura;
}
else
cout << "Arco dioagonal: " << arco.noi << " " << arco.nof << endl;
if (norte && sul && este && oeste)
return;
}		
if(norte)
desenhaParede(nos[no].x-0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z);
else
if (larguraNorte < noi->largura){
desenhaParede(nos[no].x-0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z,nos[no].x-0.5*larguraNorte,nos[no].y+0.5*noi->largura,nos[no].z);
desenhaParede(nos[no].x+0.5*larguraNorte,nos[no].y+0.5*noi->largura,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z);
}
if(sul)
desenhaParede(nos[no].x+0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x-0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z);
else
if (larguraSul < noi->largura){
desenhaParede(nos[no].x+0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x+0.5*larguraSul,nos[no].y-0.5*noi->largura,nos[no].z);
desenhaParede(nos[no].x-0.5*larguraSul,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x-0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z);
}
if(este)
desenhaParede(nos[no].x-0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x-0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z);
else
if (larguraEste < noi->largura){
desenhaParede(nos[no].x-0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z,nos[no].x-0.5*noi->largura,nos[no].y-0.5*larguraEste,nos[no].z);
desenhaParede(nos[no].x-0.5*noi->largura,nos[no].y+0.5*larguraEste,nos[no].z,nos[no].x-0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z);
}
if(oeste)
desenhaParede(nos[no].x+0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z);
else
if (larguraOeste < noi->largura){
desenhaParede(nos[no].x+0.5*noi->largura,nos[no].y+0.5*noi->largura,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y+0.5*larguraOeste,nos[no].z);
desenhaParede(nos[no].x+0.5*noi->largura,nos[no].y-0.5*larguraOeste,nos[no].z,nos[no].x+0.5*noi->largura,nos[no].y-0.5*noi->largura,nos[no].z);
}
}*/

void desenhaArco(Arco arco)
{
	No *noi,*nof;
	noi=&nos[arco.noi];
	nof=&nos[arco.nof];
	GLUquadricObj *quad;
	GLfloat d= sqrt(pow(nof->x-noi->x,2)+pow(nof->y-noi->y,2));
	GLfloat r= sqrt(pow(d,2)+pow(nof->z-noi->z,2));
	quad=gluNewQuadric();

	glPushMatrix();

	glTranslatef(noi->x,noi->y,noi->z+10); //meter mais para baixo
	glRotatef(graus(atan2(nof->y-noi->y,nof->x-noi->x)),0,0,1);
	glRotatef(graus((M_PI/2.0)-atan2(nof->z-noi->z,d)),0,1,0);
	gluCylinder(quad,arco.largura/2.0,arco.largura/2.0,r,32,32);

	glPopMatrix();	
}

/*void desenhaArco(Arco arco){  //desenha os caminhos de liga��o entre os nos
No *noi,*nof;

if(nos[arco.noi].x==nos[arco.nof].x){
// arco vertical
if(nos[arco.noi].y<nos[arco.nof].y){
noi=&nos[arco.noi];
nof=&nos[arco.nof];
}else{
nof=&nos[arco.noi];
noi=&nos[arco.nof];
}

desenhaChao(noi->x-0.5*arco.largura,noi->y+0.5*noi->largura,noi->z,nof->x+0.5*arco.largura,nof->y-0.5*nof->largura,nof->z, NORTE_SUL);
desenhaParede(noi->x-0.5*arco.largura,noi->y+0.5*noi->largura,noi->z,nof->x-0.5*arco.largura,nof->y-0.5*nof->largura,nof->z);
desenhaParede(nof->x+0.5*arco.largura,nof->y-0.5*nof->largura,nof->z,noi->x+0.5*arco.largura,noi->y+0.5*noi->largura,noi->z);
}else{
if(nos[arco.noi].y==nos[arco.nof].y){
//arco horizontal
if(nos[arco.noi].x<nos[arco.nof].x){
noi=&nos[arco.noi];
nof=&nos[arco.nof];
}else{
nof=&nos[arco.noi];
noi=&nos[arco.nof];
}
desenhaChao(noi->x+0.5*noi->largura,noi->y-0.5*arco.largura,noi->z,nof->x-0.5*nof->largura,nof->y+0.5*arco.largura,nof->z, ESTE_OESTE);
desenhaParede(noi->x+0.5*noi->largura,noi->y+0.5*arco.largura,noi->z,nof->x-0.5*nof->largura,nof->y+0.5*arco.largura,nof->z);
desenhaParede(nof->x-0.5*nof->largura,nof->y-0.5*arco.largura,nof->z,noi->x+0.5*noi->largura,noi->y-0.5*arco.largura,noi->z);
}
else{
cout << "arco diagonal... n�o ser� desenhado";
}
}
}*/

void desenhaLabirinto()
{
	glPushMatrix();
	glTranslatef(0,0,0.05);
	glScalef(5,5,5);

	for(int i=0; i<numNos; i++){
		glPushName(NO + i);
		desenhaNo(i);
		glPopName();
	}
	material(red_plastic);
	for(int i=0; i<numArcos; i++){
		glPushName(ARCO + i);
		desenhaArco(arcos[i]);
		glPopName();
	}
	glPopMatrix();
}

void desenhaEixo()
{
	gluCylinder(modelo.quad,0.5,0.5,20,16,15);
	glPushMatrix();
	glTranslatef(0,0,20);
	glPushMatrix();
	glRotatef(180,0,1,0);
	gluDisk(modelo.quad,0.5,2,16,6);
	glPopMatrix();
	gluCylinder(modelo.quad,2,0,5,16,15);
	glPopMatrix();
}

#define EIXO_X		1
#define EIXO_Y		2
#define EIXO_Z		3

void desenhaPlanoDrag(int eixo)
{
	glPushMatrix();
	glTranslated(estado.eixo[0],estado.eixo[1],estado.eixo[2]);
	switch (eixo) {
	case EIXO_Y :
		if(abs(estado.camera.dir_lat)<M_PI/4)
			glRotatef(-90,0,0,1);
		else
			glRotatef(90,1,0,0);
		material(red_plastic);
		break;
	case EIXO_X :
		if(abs(estado.camera.dir_lat)>M_PI/6)
			glRotatef(90,1,0,0);
		material(azul);
		break;
	case EIXO_Z :
		if(abs(cos(estado.camera.dir_long))>0.5)
			glRotatef(90,0,0,1);

		material(emerald);
		break;
	}
	glBegin(GL_QUADS);
	glNormal3f(0,1,0);
	glVertex3f(-100,0,-100);
	glVertex3f(100,0,-100);
	glVertex3f(100,0,100);
	glVertex3f(-100,0,100);
	glEnd();
	glPopMatrix();
}

void desenhaEixos()
{

	glPushMatrix();
	glTranslated(estado.eixo[0],estado.eixo[1],estado.eixo[2]);
	material(emerald);
	glPushName(EIXO_Z);
	desenhaEixo();
	glPopName();
	glPushName(EIXO_Y);
	glPushMatrix();
	glRotatef(-90,1,0,0);
	material(red_plastic);
	desenhaEixo();
	glPopMatrix();
	glPopName();
	glPushName(EIXO_X);
	glPushMatrix();
	glRotatef(90,0,1,0);
	material(azul);
	desenhaEixo();
	glPopMatrix();
	glPopName();
	glPopMatrix();
}

void setCamera()
{
	Vertice eye;

	eye[0]=estado.camera.center[0] + estado.camera.dist * cos(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	eye[1]=estado.camera.center[1] + estado.camera.dist * sin(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	eye[2]=estado.camera.center[2] + estado.camera.dist  *sin(estado.camera.dir_lat);

	putLights((GLfloat*)white_light);
	gluLookAt(eye[0],eye[1],eye[2],estado.camera.center[0],estado.camera.center[1],estado.camera.center[2],0,0,1);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRotatef(graus(-M_PI/2.0),1,0,0);
	glRotatef(graus(M_PI/2.0-estado.camera.dir_long),0,0,1);
	glTranslatef(-estado.camera.center[0],-estado.camera.center[1],-estado.camera.center[2]);
}

void drawString(GLfloat x, GLfloat y, GLfloat z, GLfloat scale, char* msg)
{
	glTranslatef(x, y, z);
	glScalef(scale, scale, scale);
	int n = strlen(msg);
	for (int i = 0; i < n; i++)
		glutStrokeCharacter(GLUT_STROKE_MONO_ROMAN, msg[i]);
}

void display(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	setCamera();

	material(slate);
	desenhaSolo();

	desenhaEixos();

	desenhaLabirinto();

	if(estado.eixoTranslaccao) {
		// desenha plano de translac��o
		//cout << "Translate... " << estado.eixoTranslaccao << endl; 
		//desenhaPlanoDrag(estado.eixoTranslaccao);
	}

	if(estado.vooRasante){
		char* msg = "Voo Rasante";
		GLfloat mat_w[] = {1.0, 1.0, 1.0};
		glPushMatrix();
		glLoadIdentity();
		gluLookAt(0,0, 5, 0, 0, 0, 0, 1, 0);
		glColor3fv(mat_w);
		glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, mat_w);
		drawString(-3.5 + width/640, 2.65, 0, 0.0015, msg);
		glPopMatrix();
	}
	else{
		char* msg = "Voo Livre";
		GLfloat mat_w[] = {1.0, 1.0, 1.0};
		glPushMatrix();
		glLoadIdentity();
		gluLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);
		glColor3fv(mat_w);
		glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, mat_w);
		drawString(-3.5 + width/640, 2.65, 0, 0.0015, msg);
		glPopMatrix();
	}
	glFlush();
	glutSwapBuffers();
}

void setProjection(int x, int y, GLboolean picking)
{
	glLoadIdentity();
	if (picking) { // se est� no modo picking, l� viewport e define zona de picking
		GLint vport[4];
		glGetIntegerv(GL_VIEWPORT, vport);
		gluPickMatrix(x, glutGet(GLUT_WINDOW_HEIGHT)  - y, 4, 4, vport); // Inverte o y do rato para corresponder � jana
	}
	gluPerspective(estado.camera.fov,(GLfloat)glutGet(GLUT_WINDOW_WIDTH) /glutGet(GLUT_WINDOW_HEIGHT) ,1,500);
}

int colisaoLivre()
{
	int i, n, objid=0;
	double zmin = 10.0, zmax = 0;
	GLuint buffer[100], *ptr;
	GLfloat vel = estado.camera.velh + estado.camera.velv;
	GLdouble newx, newy, newz;
	GLint vp[4];
	GLdouble proj[16], mv[16];

	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projec��o
	glLoadIdentity();
	glOrtho( -DIMEMSAO_CAMARA / 2.0, DIMEMSAO_CAMARA / 2.0,
		-DIMEMSAO_CAMARA / 2.0, DIMEMSAO_CAMARA / 2.0, 0.0, DIMEMSAO_CAMARA / 2.0 + vel*4);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRotatef(graus(-M_PI / 2.0 - atan2(estado.camera.velv, estado.camera.velh)),1,0,0);
	glRotatef(graus(M_PI / 2.0 - estado.camera.dir_long),0,0,1);
	glTranslatef(-estado.camera.center[0],-estado.camera.center[1],-estado.camera.center[2]);

	desenhaLabirinto();

	n = glRenderMode(GL_RENDER);
	if (n > 0)
	{
		ptr = buffer;
		for (i = 0; i < n; i++)
		{
			if (zmin > (double) ptr[1] / UINT_MAX) {
				zmin = (double) ptr[1] / UINT_MAX;
				objid = ptr[3];
			}
			if (zmax < (double) ptr[1] / UINT_MAX) {
				zmax = (double) ptr[1] / UINT_MAX;
			}
			ptr += 3 + ptr[0]; // ptr[0] contem o n�mero de nomes (normalmente 1); 3 corresponde a numnomes, zmin e zmax

			glGetIntegerv(GL_VIEWPORT, vp);
			glGetDoublev(GL_PROJECTION_MATRIX, proj);
			glGetDoublev(GL_MODELVIEW_MATRIX, mv);

			gluUnProject(estado.camera.center[0], glutGet(GLUT_WINDOW_HEIGHT) - estado.camera.center[2], (double) buffer[2] / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);

			GLfloat d = sqrt(pow(newx- estado.camera.center[0],2) + pow(newy-estado.camera.center[1],2) + pow(newz - estado.camera.center[2],2));

			float limit = std::numeric_limits<float>::infinity();

			k = (d - DIMEMSAO_CAMARA/2.0 - limit) / vel;
		}
	}
	else{
		estado.k = 1;
	}

	glMatrixMode(GL_PROJECTION); //rep�e matriz projec��o
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return objid;
}

int colisaoRasante()
{
	int i, n, objid=0;
	double zmin = 10.0, zmax = 10.0;;
	GLuint buffer[100], *ptr;
	GLfloat vel = estado.camera.velh + estado.camera.velv;
	GLdouble newx, newy, newz;
	GLint vp[4];
	GLdouble proj[16], mv[16];
	GLint farP = 0, nearP = 0; 

	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projec��o
	glLoadIdentity();
	glOrtho(estado.camera.center[0] - estado.camera.velh, estado.camera.center[0] + estado.camera.velh, 
		estado.camera.center[1] - estado.camera.velh, estado.camera.center[1] + estado.camera.velh, nearP, farP);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	desenhaLabirinto();

	n = glRenderMode(GL_RENDER);
	if (n > 0)
	{
		ptr = buffer;
		for (i = 0; i < n; i++)
		{
			if (zmin > (double) ptr[1] / UINT_MAX) {
				zmin = (double) ptr[1] / UINT_MAX;
				objid = ptr[3];
			}

			if (zmax < (double) ptr[1] / UINT_MAX) {
				zmax = (double) ptr[1] / UINT_MAX;
			}
			glGetIntegerv(GL_VIEWPORT, vp);
			glGetDoublev(GL_PROJECTION_MATRIX, proj);
			glGetDoublev(GL_MODELVIEW_MATRIX, mv);

			gluUnProject(estado.camera.center[0], glutGet(GLUT_WINDOW_HEIGHT) - estado.camera.center[2], (double) buffer[2] / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);
			ptr += 3 + ptr[0]; // ptr[0] contem o n�mero de nomes (normalmente 1); 3 corresponde a numnomes, zmin e zmax
		}
	}

	glMatrixMode(GL_PROJECTION); //rep�e matriz projec��o
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return objid;
}

void Timer(int value)
{
	GLuint curr = glutGet(GLUT_ELAPSED_TIME);
	GLfloat vel = estado.camera.velh + estado.camera.velv;

	glutTimerFunc(estado.timer, Timer, 0);
	// ir p/ frente
	if(estado.teclas.up){
		// se voo livre
		if(!estado.vooRasante)
		{
			estado.eixoTranslaccao=colisaoLivre();
			if(!estado.eixoTranslaccao){
				estado.camera.center[0] = estado.camera.center[0] + estado.k*estado.camera.velh * cos(estado.camera.dir_long);
				estado.camera.center[1] = estado.camera.center[1] + estado.k*estado.camera.velh * sin(estado.camera.dir_long);
				estado.camera.center[2] = estado.camera.center[2];
			}
		}else{
			// se voo rasante
			estado.eixoTranslaccao=colisaoRasante();
			if(estado.eixoTranslaccao!=0)
			{
				estado.camera.center[0] = estado.camera.center[0] + estado.camera.velh * cos(estado.camera.dir_long);
				estado.camera.center[1] = estado.camera.center[1] + estado.camera.velh * sin(estado.camera.dir_long);
				estado.camera.center[2] = estado.camera.center[2];
			}
		}
	}
	// ir p/ tras
	if(estado.teclas.down){
		// se voo livre
		if(!estado.vooRasante){
			estado.eixoTranslaccao=colisaoLivre();
			if(!estado.eixoTranslaccao)
			{
				estado.camera.center[0]=estado.camera.center[0]- estado.k*estado.camera.velh * cos(estado.camera.dir_long);
				estado.camera.center[1]=estado.camera.center[1]- estado.k*estado.camera.velh * sin(estado.camera.dir_long);
				estado.camera.center[2]=estado.camera.center[2];
			}
		}else{
			// se voo rasante
			estado.eixoTranslaccao=colisaoRasante();
			if(estado.eixoTranslaccao!=0)
			{
				estado.camera.center[0] = estado.camera.center[0] - estado.camera.velh * cos(estado.camera.dir_long);
				estado.camera.center[1] = estado.camera.center[1] - estado.camera.velh * sin(estado.camera.dir_long);
				estado.camera.center[2] = estado.camera.center[2];
			}
		}
	}

	if(estado.teclas.left){
		// rodar camara p/ esquerda
		estado.camera.dir_long+=M_PI/64;
	}

	if(estado.teclas.right){
		// rodar camara p/ direita
		estado.camera.dir_long-=M_PI/64;
	}

	if(!estado.vooRasante)
	{
		if(estado.teclas.q){
			// subir camara
			estado.eixoTranslaccao=colisaoLivre();
			if(estado.eixoTranslaccao)
			{
			}else{
				estado.camera.center[2]++;
			}
		}

		if(estado.teclas.a){
			// descer camara
			estado.eixoTranslaccao=colisaoLivre();
			if(estado.eixoTranslaccao)
			{
			}else{
				if(estado.camera.center[2]>=2)
					estado.camera.center[2]--;
			}
		}
	}
	glutPostRedisplay ();
}

void keyboard(unsigned char key, int x, int y)
{
	switch (key)
	{
	case 27 :
		exit(0);
		break;
	case 'h':
	case 'H':
		imprime_ajuda();
		break;
	case 'l':
	case 'L':
		if(estado.lightViewer)
			estado.lightViewer=0;
		else
			estado.lightViewer=1;
		glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, estado.lightViewer);
		glutPostRedisplay();
		break;
	case 'k':
	case 'K':
		estado.light=!estado.light;
		glutPostRedisplay();
		break;
	case 'w':
	case 'W':
		glDisable(GL_LIGHTING);
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		glutPostRedisplay();
		break;
	case 'p':
	case 'P':
		glDisable(GL_LIGHTING);
		glPolygonMode(GL_FRONT_AND_BACK, GL_POINT);
		glutPostRedisplay();
		break;
	case 'f':
	case 'F':
		glEnable(GL_LIGHTING);
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		glutPostRedisplay();
		break;
	case 'c':
	case 'C':
		if(glIsEnabled(GL_CULL_FACE))
			glDisable(GL_CULL_FACE);
		else
			glEnable(GL_CULL_FACE);
		glutPostRedisplay();
		break;    
	case 'r':
	case 'R':
		if(!estado.vooRasante){
			initEstado();
			estado.camera.center[2]=86;
			initModelo();
			estado.vooRasante = GL_TRUE;
		}
		else{
			estado.vooRasante = GL_FALSE;
			estado.camera.center[2]=90;
		}
		glutPostRedisplay();
		break;
	case 'i':
	case 'I':
		initEstado();
		initModelo();
		glutPostRedisplay();
		break;
	case 'q':
	case 'Q':
		estado.teclas.q = GL_TRUE;
		break;
	case 'a':
	case 'A':
		estado.teclas.a = GL_TRUE;
		break;
	}
}

void keyboardUp(unsigned char key, int x, int y)
{
	switch (key) {
	case 'q':
	case 'Q':
		estado.teclas.q = GL_FALSE;
		break;
	case 'a':
	case 'A':
		estado.teclas.a = GL_FALSE;
		break;
	}
}

void Special(int key, int x, int y)
{
#define DRAG_SCALE	0.01
	double lim=M_PI/2-0.1;
	switch(key){
	case GLUT_KEY_F6 :
		gravaGrafo();
		break;
	case GLUT_KEY_F2 :
		leGrafo();
		glutPostRedisplay();
		break;	
	case GLUT_KEY_F1 :
		numNos=numArcos=0;
		addNo(criaNo( 0, 10,0));  // 0
		addNo(criaNo( 0,  5,0));  // 1
		addNo(criaNo(-5,  5,0));  // 2
		addNo(criaNo( 5,  5,0));  // 3
		addNo(criaNo(-5,  0,0));  // 4
		addNo(criaNo( 5,  0,0));  // 5
		addNo(criaNo(-5, -5,0));  // 6
		addArco(criaArco(0,1,1,1));  // 0 - 1
		addArco(criaArco(1,2,1,1));  // 1 - 2
		addArco(criaArco(1,3,1,1));  // 1 - 3
		addArco(criaArco(2,4,1,1));  // 2 - 4
		addArco(criaArco(3,5,1,1));  // 3 - 5
		addArco(criaArco(4,5,1,1));  // 4 - 5
		addArco(criaArco(4,6,1,1));  // 4 - 6
		glutPostRedisplay();
		break;	
	case GLUT_KEY_PAGE_UP:
		break;
	case GLUT_KEY_PAGE_DOWN:
		break;
	case GLUT_KEY_UP:
		//estado.camera.dist+=1;
		estado.teclas.up = GL_TRUE;
		break;
	case GLUT_KEY_DOWN:
		//estado.camera.dist-=1;
		estado.teclas.down = GL_TRUE;
		break;	
	case GLUT_KEY_LEFT:
		estado.teclas.left = GL_TRUE;
		break;	
	case GLUT_KEY_RIGHT:
		estado.teclas.right = GL_TRUE;
		break;	
	}
}

void SpecialKeyUp(int key, int x, int y)
{
	switch (key) {
	case GLUT_KEY_UP: estado.teclas.up = GL_FALSE;
		break;
	case GLUT_KEY_DOWN: estado.teclas.down = GL_FALSE;
		break;
	case GLUT_KEY_LEFT: estado.teclas.left = GL_FALSE;
		break;
	case GLUT_KEY_RIGHT: estado.teclas.right = GL_FALSE;
		break;
	}
}

void myReshape(int w, int h)
{	
	glViewport(0, 0, w, h);
	glMatrixMode(GL_PROJECTION);
	setProjection(0,0,GL_FALSE);
	glMatrixMode(GL_MODELVIEW);
	width = w;
	height = h;
}

void motionRotate(int x, int y)
{
#define DRAG_SCALE	0.01
	double lim=M_PI/2-0.1;
	estado.camera.dir_long+=(estado.xMouse-x)*DRAG_SCALE;
	estado.camera.dir_lat-=(estado.yMouse-y)*DRAG_SCALE*0.5;
	if(estado.camera.dir_lat>lim)
		estado.camera.dir_lat=lim;
	else 
		if(estado.camera.dir_lat<-lim)
			estado.camera.dir_lat=-lim;
	estado.xMouse=x;
	estado.yMouse=y;
	glutPostRedisplay();
}

void motionZoom(int x, int y)
{
#define ZOOM_SCALE	0.5
	estado.camera.dist-=(estado.yMouse-y)*ZOOM_SCALE;
	if(estado.camera.dist<5)
		estado.camera.dist=5;
	else 
		if(estado.camera.dist>200)
			estado.camera.dist=200;
	estado.yMouse=y;
	glutPostRedisplay();
}

void motionDrag(int x, int y)
{
	GLuint buffer[100];
	GLint vp[4];
	GLdouble proj[16], mv[16];
	int n;
	GLdouble newx, newy, newz;

	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projec��o
	glLoadIdentity();
	setProjection(x,y,GL_TRUE);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	setCamera();
	desenhaPlanoDrag(estado.eixoTranslaccao);

	n = glRenderMode(GL_RENDER);
	if (n > 0) {
		glGetIntegerv(GL_VIEWPORT, vp);
		glGetDoublev(GL_PROJECTION_MATRIX, proj);
		glGetDoublev(GL_MODELVIEW_MATRIX, mv);
		gluUnProject(x, glutGet(GLUT_WINDOW_HEIGHT) - y, (double) buffer[2] / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);
		//printf("Novo x:%lf, y:%lf, z:%lf\n\n", newx, newy, newz);
		switch (estado.eixoTranslaccao) {
		case EIXO_X :
			estado.eixo[0]=newx;
			//estado.eixo[1]=newy;
			break;
		case EIXO_Y :
			estado.eixo[1]=newy;
			//estado.eixo[2]=newz;
			break;
		case EIXO_Z :
			//estado.eixo[0]=newx;
			estado.eixo[2]=newz;
			break;		
		}
		glutPostRedisplay();
	}


	glMatrixMode(GL_PROJECTION); //rep�e matriz projec��o
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glutPostRedisplay();
}

int picking(int x, int y)
{
	int i, n, objid=0;
	double zmin = 10.0;
	GLuint buffer[100], *ptr;

	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projec��o
	glLoadIdentity();
	setProjection(x,y,GL_TRUE);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	setCamera();
	desenhaEixos();
	desenhaLabirinto();

	n = glRenderMode(GL_RENDER);
	if (n > 0)
	{
		ptr = buffer;
		for (i = 0; i < n; i++)
		{
			if (zmin > (double) ptr[1] / UINT_MAX) {
				zmin = (double) ptr[1] / UINT_MAX;
				objid = ptr[3];
			}
			ptr += 3 + ptr[0]; // ptr[0] contem o n�mero de nomes (normalmente 1); 3 corresponde a numnomes, zmin e zmax
		}
	}


	glMatrixMode(GL_PROJECTION); //rep�e matriz projec��o
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return objid;
}

void mouse(int btn, int state, int x, int y)
{
	switch(btn) {
	case GLUT_RIGHT_BUTTON :
		if(state == GLUT_DOWN){
			estado.xMouse=x;
			estado.yMouse=y;
			if(glutGetModifiers() & GLUT_ACTIVE_CTRL)
				glutMotionFunc(motionZoom);
			else
				glutMotionFunc(motionRotate);
			//cout << "Left down\n";
		}
		else{
			glutMotionFunc(NULL);
			//cout << "Left up\n";
		}
		break;
	case GLUT_LEFT_BUTTON :
		if(state == GLUT_DOWN){
			estado.eixoTranslaccao=picking(x,y);
			if(estado.eixoTranslaccao)
				glutMotionFunc(motionDrag);
			//cout << "Right down - objecto:" << estado.eixoTranslaccao << endl;
		}
		else{
			if(estado.eixoTranslaccao!=0) {
				/*estado.camera.center[0]=estado.eixo[0];
				estado.camera.center[1]=estado.eixo[1];
				estado.camera.center[2]=estado.eixo[2];*/
				glutMotionFunc(NULL);
				estado.eixoTranslaccao=0;
				glutPostRedisplay();
			}
			//cout << "Right up\n";
		}
		break;
	}
}

void main(int argc, char **argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	glutInitWindowSize(width, height);  
	glutCreateWindow("Graphs4Social");
	glutReshapeFunc(myReshape);
	glutDisplayFunc(display);
	glutTimerFunc(estado.timer,Timer,0);
	glutKeyboardFunc(keyboard);
	glutKeyboardUpFunc(keyboardUp);
	glutSpecialFunc(Special);
	glutSpecialUpFunc(SpecialKeyUp);
	glutMouseFunc(mouse);
	myInit();

	imprime_ajuda();

	glutMainLoop();
}