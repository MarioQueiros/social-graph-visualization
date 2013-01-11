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
#include <AL/alut.h>
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

GLint height = 512; 
GLint width = 640;
GLint check = 1;

typedef struct {
	ALuint buffer, source;
	ALboolean tecla_s;
} Audio;

typedef struct Eye
{
	GLfloat x;
	GLdouble y;
	GLdouble z;
}Eye;

typedef struct Camera
{
	GLfloat fov;
	GLdouble dir_lat;
	GLdouble dir_long;
	GLfloat dist;
	Vertice center;
	GLfloat velv;
	GLfloat velh;
	GLfloat vel;
	GLfloat distância_solo;
	Eye eye;
}Camera;

typedef struct pos_t{
	GLfloat    x,y,z;
}pos_t;

typedef struct camera_t{
	pos_t    eye;  
	GLfloat  dir_long;  // longitude olhar (esq-dir)
	GLfloat  dir_lat;   // latitude olhar	(cima-baixo)
	GLfloat  fov;
}camera_t;

typedef struct teclas_t
{
	GLboolean   up,down,left,right,a,q;
}teclas_t;

typedef struct Estado
{
	Camera		camera;
	camera_t    Camera;
	int			xMouse,yMouse;
	GLboolean	light;
	GLboolean	apresentaNormais;
	GLint		lightViewer;
	GLint		eixoTranslaccao;
	GLint		tooltip;
	GLdouble	eixo[3];
	teclas_t    teclas;
	GLint       timer;
	GLdouble	k;
	GLboolean	vooRasante;
	GLfloat     zmin;
	GLfloat     zmax;
	GLint       topSubwindow,navigateSubwindow;
	GLuint      vista[NUM_JANELAS];
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

Audio audio;
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
	/*estado.camera.center[0] = -130; 
	estado.camera.center[1] = 0;
	estado.camera.center[2] = 90;*/

	estado.light=GL_FALSE;
	estado.apresentaNormais=GL_FALSE;
	estado.lightViewer=2;
	estado.k = 1;
	estado.timer = 100;	
	estado.camera.velh = VELOCIDADE_HORIZONTAL;
	estado.camera.velv = 0;
	estado.camera.vel=sqrt(pow(estado.camera.velh,2)+pow(estado.camera.velv,2));
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

void Init()
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
	modelo.quad=gluNewQuadric();
	gluQuadricDrawStyle(modelo.quad, GLU_FILL);
	gluQuadricNormals(modelo.quad, GLU_OUTSIDE);
}

void InitAudio()
{
	audio.buffer = alutCreateBufferFromFile("David_Guetta_Baby_When_The_Light.wav");
	alGenSources(1, &audio.source);
	alSourcei (audio.source, AL_BUFFER, audio.buffer);
	audio.tecla_s = AL_TRUE;
}

void imprime_ajuda(void)
{
	printf("Desenho de um labirinto a partir de um grafo \n\n");
	printf("h,H - Ajuda \n");
	printf("s,S - Parar/Reproduzir Som \n");
	printf("i,I - Repor os valores iniciais \n");
	printf("ESC - Sair \n");

	printf("\n******* Grafo ******* \n");
	printf("F1  - Cria novo grafo\n");
	printf("F2  - Ler grafo de ficheiro \n");
	printf("F6  - Grava grafo em ficheiro \n");

	printf("\n****** Desenho ****** \n");
	printf("f,F - PolygonMode Fill \n");
	printf("w,W - PolygonMode Wireframe \n");
	printf("p,P - PolygonMode Point \n");

	printf("\n**** Iluminacao ***** \n");
	printf("l,L - Luz fixa em relacao a cena/viewport \n");
	printf("k,K - Alterna luz de camera com luz global \n");
	printf("c,C - Liga/Desliga Cull Face \n");

	printf("\n****** Camera ******* \n");
	printf("Botao esquerdo - Rodar camera \n");

	printf("\n Voo Livre \n");
	printf("q/Q/a/A - Subir/descer \n");
	printf("Up/Down - Avancar/recuar \n");
	printf("Left/Right - Rodar para a esquerda/direita \n");

	printf("\n Voo Rasante \n");
	printf("Up/Down - Avancar/recuar \n");
	printf("Left/Right - Rodar para a esquerda/direita \n");
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
	estado.camera.distância_solo  = nos[0].z * 35;

	if(check == 1 || check == -99)
	{
		/*estado.camera.center[0] = nos[0].y * nos[0].z; 
		estado.camera.center[1] = nos[0].x;
		estado.camera.center[2] = nos[0].z * 35;*/

		estado.camera.eye.x = nos[0].y * nos[0].z;
		estado.camera.eye.y = nos[0].x;
		estado.camera.eye.z = nos[0].z * 35;

		check++;
	}

	if(estado.zmin > nos[no].z)
	{
		estado.zmin = nos[no].z;
	}
	if(estado.zmax < nos[no].z)
	{
		estado.zmax = nos[no].z;
	}
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

/*void desenhaArco(Arco arco){  //desenha os caminhos de ligação entre os nos
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
cout << "arco diagonal... não será desenhado";
}
}
}*/

void desenhaLabirinto()
{
	estado.zmin = 0;
	estado.zmax = 0;
	glPushMatrix();
	glTranslatef(0,0,0.05);
	glScalef(5,5,5);

	for(int i=0; i<numNos; i++){
		glLoadName(NO + i);
		desenhaNo(i);
	}
	material(red_plastic);
	for(int i=0; i<numArcos; i++){
		glLoadName(ARCO + i);
		desenhaArco(arcos[i]);
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
	estado.camera.center[0] = estado.camera.eye.x + estado.camera.dist * cos(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	estado.camera.center[1] = estado.camera.eye.y + estado.camera.dist * sin(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	estado.camera.center[2] = estado.camera.eye.z + estado.camera.dist * sin(estado.camera.dir_lat);

	putLights((GLfloat*)white_light);
	gluLookAt(estado.camera.eye.x,estado.camera.eye.y,estado.camera.eye.z,estado.camera.center[0],estado.camera.center[1],estado.camera.center[2],0,0,1);

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

	//desenhaEixos();

	desenhaLabirinto();

	char msg[100];
	if(estado.vooRasante){
		strcpy(msg, "Voo Rasante");
	}
	else {
		strcpy(msg, "Voo Livre");
	}

	GLfloat mat_w[] = {1.0, 1.0, 1.0};
	glPushMatrix();
	glLoadIdentity();
	gluLookAt(0,0, 5, 0, 0, 0, 0, 1, 0);
	glColor3fv(mat_w);
	glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, mat_w);
	drawString(-3.5 + width/640, 2.65, 0, 0.0015, msg);
	glPopMatrix();

	glFlush();
	glutSwapBuffers();
}

void setProjection(int x, int y, GLboolean picking)
{
	glLoadIdentity();
	if (picking) { // se está no modo picking, lê viewport e define zona de picking
		GLint vport[4];
		glGetIntegerv(GL_VIEWPORT, vport);
		gluPickMatrix(x, glutGet(GLUT_WINDOW_HEIGHT)  - y, 4, 4, vport); // Inverte o y do rato para corresponder à jana
	}
	gluPerspective(estado.camera.fov,(GLfloat)glutGet(GLUT_WINDOW_WIDTH) /glutGet(GLUT_WINDOW_HEIGHT) ,1,500);
}

GLdouble colisaoLivre()
{
	int i, j, names;
	GLint n, objid=0;
	GLfloat zmin = 10.0, zmax = 10.0;
	GLuint buffer[500], *ptr;
	GLdouble newx=0, newy=0, newz=0;
	GLint vp[4];
	GLdouble proj[16], mv[16];

	estado.camera.vel = sqrt(pow(estado.camera.velh,2) + pow(estado.camera.velv,2));

	glSelectBuffer(500, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();
	glPushName(0);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projecção
	glLoadIdentity();
	glOrtho(-DIMEMSAO_CAMARA / 2.0, DIMEMSAO_CAMARA / 2.0,
		-DIMEMSAO_CAMARA / 2.0, DIMEMSAO_CAMARA / 2.0, 0.0, DIMEMSAO_CAMARA / 2.0 + estado.camera.vel);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRotatef(graus(-M_PI / 2.0 - atan2(estado.camera.velv, estado.camera.velh)),1,0,0);
	glRotatef(graus(M_PI / 2.0 - estado.camera.dir_long),0,0,1);
	glTranslatef(-estado.camera.eye.x,-estado.camera.eye.y,-estado.camera.eye.z);

	desenhaLabirinto();

	n = glRenderMode(GL_RENDER);
	ptr = (GLuint *) buffer;
	for (i = 0; i < n; i++) { /*  for each hit  */
		names = (int) *ptr;
		ptr++;
		if(zmin > (float)*ptr/UINT_MAX){
			zmin = (float)*ptr/UINT_MAX;
		}
		ptr++;
		ptr++;
		for (j = 0; j < names; j++) { /*  for each name */
			ptr++;
		}	
	}

	if(n!=0){
		glGetIntegerv(GL_VIEWPORT,vp);
		glGetDoublev(GL_PROJECTION_MATRIX,proj);
		glGetDoublev(GL_MODELVIEW_MATRIX, mv);
		gluUnProject(glutGet(GLUT_WINDOW_WIDTH)/2.0, glutGet(GLUT_WINDOW_HEIGHT)/2.0, (double) zmin / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);

		GLdouble d = sqrt(pow(newx-estado.camera.eye.x,2) + pow(newy-estado.camera.eye.y,2) + pow(newz-estado.camera.eye.z,2));

		GLfloat inf = 1e-50;

		estado.k = (d-DIMEMSAO_CAMARA / 2.0 - inf)/estado.camera.vel;
		if(estado.k<0) estado.k=0;
	}else{
		estado.k=1;
	}

	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return estado.k;
}

int colisaoRasante()
{
	int i;
	int n, objid=0;
	double zmin = 10.0, zmax = 10.0;
	estado.zmin =  (estado.zmin + 1) * 35;
	estado.zmax =  (estado.zmax + 1) * 35; 
	GLuint buffer[100], *ptr;

	GLdouble newx, newy, newz;
	GLint vp[4];
	GLdouble proj[16], mv[16];
	GLint farP = 0, nearP = 0; 
	nearP = estado.zmax - 1;
	farP  = estado.zmin + 1;

	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();
	glPushName(0);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projecção
	glLoadIdentity();
	glOrtho(estado.camera.center[0] - estado.camera.velh, estado.camera.center[0] + estado.camera.velh, 
		estado.camera.center[1] - estado.camera.velh, estado.camera.center[1] + estado.camera.velh, -nearP, -farP);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	desenhaLabirinto();

	n = glRenderMode(GL_RENDER);
	if (n > 0)
	{
		GLuint names;
		ptr = (GLuint *) buffer;
		for (i = 0; i < n; i++)
		{
			/*names = *ptr;
			printf (" number of names for hit = %d\n", names); ptr++;
			printf(" z1 is %g;", (float) *ptr/0x7fffffff); ptr++;
			printf(" z2 is %g\n", (float) *ptr/0x7fffffff); ptr++;
			printf (" the name is ");
			for (j = 0; j < names; j++)
			{ 
			// for each name
			printf ("%d ", *ptr); ptr++;
			}
			printf ("\n");*/

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

			gluUnProject(glutGet(GLUT_WINDOW_WIDTH), glutGet(GLUT_WINDOW_HEIGHT), (double) zmin / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);
			ptr += 3 + ptr[0]; // ptr[0] contem o número de nomes (normalmente 1); 3 corresponde a numnomes, zmin e zmax
		}
	}

	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return objid;
}

void redisplayAll(void)
{
	glutSetWindow(1);
	glutPostRedisplay();
	glutSetWindow(estado.navigateSubwindow);
	glutPostRedisplay();
}

void Timer(int value)
{
	GLuint curr = glutGet(GLUT_ELAPSED_TIME);
	GLdouble k=0;
	glutTimerFunc(estado.timer, Timer, 0);
	float nx,ny,nz;
	ALint state;

	alGetSourcei(audio.source, AL_SOURCE_STATE, &state);
	if (audio.tecla_s)
	{
		//reproduzir som
		if (state != AL_PLAYING){
			alutSleep (1);
			alSourcePlay(audio.source);
		}
	}
	else{
		//parar reprodução
		if (state == AL_PLAYING){
			alSourceStop(audio.source);
		}
	}	

	// ir p/ frente
	if(estado.teclas.up){
		// se voo livre
		if(!estado.vooRasante)
		{
			estado.camera.velh = VELOCIDADE_HORIZONTAL;
			estado.camera.velv = 0;
			k = colisaoLivre();

			nx = estado.camera.eye.x + k * estado.camera.velh * cos(estado.camera.dir_long);
			ny = estado.camera.eye.y + k * estado.camera.velh * sin(estado.camera.dir_long);

			estado.camera.eye.x = nx;
			estado.camera.eye.y = ny; 

			estado.camera.velh = 0;
			estado.k = 1;
		}else{
			// se voo rasante
			int rasante=colisaoRasante();
			if(rasante!=0)
			{
				estado.camera.velh = VELOCIDADE_HORIZONTAL;
				nx = estado.camera.eye.x + estado.camera.velh * cos(estado.camera.dir_long);
				ny = estado.camera.eye.y + estado.camera.velh * sin(estado.camera.dir_long);

				estado.camera.eye.x = nx;
				estado.camera.eye.y = ny; 

				//estado.camera.center[2] = estado.camera.center[2] + DISTANCIA_SOLO;
			}
		}
	}
	// ir p/ tras
	if(estado.teclas.down){
		// se voo livre
		if(!estado.vooRasante)
		{
			estado.camera.velh = VELOCIDADE_HORIZONTAL;
			estado.camera.velv = 0;
			k = colisaoLivre();

			nx = estado.camera.eye.x - k  * cos(estado.camera.dir_long);
			ny = estado.camera.eye.y - k * sin(estado.camera.dir_long);

			estado.camera.eye.x = nx;
			estado.camera.eye.y = ny; 

			estado.camera.velh = 0;
		}else{
			// se voo rasante
			int rasante=colisaoRasante();
			if(rasante!=0)
			{
				estado.camera.velh = VELOCIDADE_HORIZONTAL;

				nx = estado.camera.eye.x - estado.camera.velh * cos(estado.camera.dir_long);
				ny = estado.camera.eye.y - estado.camera.velh * sin(estado.camera.dir_long);

				estado.camera.eye.x = nx;
				estado.camera.eye.y = ny; 

				//estado.camera.center[2] = estado.camera.center[2] - DISTANCIA_SOLO;
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
			estado.camera.velh = 0;
			estado.camera.velv = VELOCIDADE_VERTICAL;
			k = colisaoLivre();

			nz = estado.camera.eye.z + k * estado.camera.velv * sin(estado.camera.dir_lat);
			estado.camera.eye.z = nz;

			estado.camera.velv = 0;
		}

		if(estado.teclas.a){
			// descer camara
			estado.camera.velh = 0;
			estado.camera.velv = VELOCIDADE_VERTICAL;
			k = colisaoLivre();

			if(estado.camera.center[2]>=4){
				nz = estado.camera.eye.z - k * estado.camera.velv * sin(estado.camera.dir_lat);
				estado.camera.eye.z = nz;
			}
			estado.camera.velv = 0;
		}
	}
	redisplayAll();
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
			initModelo();
			estado.camera.center[2] = estado.camera.distância_solo;
			check = -99;
			estado.vooRasante = GL_TRUE;
		}
		else{
			estado.vooRasante = GL_FALSE;
		}
		glutPostRedisplay();
		break;
	case 'i':
	case 'I':
		check = -99;
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
	case 's':
	case 'S':
		if(!audio.tecla_s){
			audio.tecla_s = AL_TRUE;
		}else{
			audio.tecla_s = AL_FALSE;
		}
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
	glLoadIdentity();
	setProjection(0,0,GL_FALSE);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	width = w;
	height = h;
	glutSetWindow (estado.navigateSubwindow);
	glutPositionWindow (10, height-200);
}

void Reshape(int w, int h)
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
	glPushMatrix(); // guarda a projecção
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


	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glutPostRedisplay();
}

void Square (void)
{
  const float u[3] = {0.2, 0, 0};
  const float v[3] = {0, 0.2, 0};

  glBegin (GL_QUADS);

	  //glTexCoord2i(0, 0); 
	  glVertex3f ( u[0] + v[0],  u[1] + v[1],  u[2] + v[2]);
	  //glTexCoord2i(1, 0); 
	  glVertex3f (-u[0] + v[0], -u[1] + v[1], -u[2] + v[2]);
	  //glTexCoord2i(1, 1); 
	  glVertex3f (-u[0] - v[0], -u[1] - v[1], -u[2] - v[2]);
	  //glTexCoord2i(0, 1); 
	  glVertex3f ( u[0] - v[0],  u[1] - v[1],  u[2] - v[2]);
  glEnd ();
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
	glPushMatrix(); // guarda a projecção
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
			ptr += 3 + ptr[0]; // ptr[0] contem o número de nomes (normalmente 1); 3 corresponde a numnomes, zmin e zmax
		}
	}


	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);

	return objid;
}

void processHits(GLint hits, GLuint buffer[])
{
	int i;
	unsigned int j;
	GLuint names, *ptr;

	printf("hits = %d\n", hits);
	ptr = (GLuint *) buffer;
	for (i = 0; i < hits; i++) {  /* for each hit  */
		names = *ptr;
		printf(" number of names for hit = %d\n", names);
		ptr++;
		printf("  z1 is %g;", (float) *ptr/0xffffffff);
		ptr++;
		printf(" z2 is %g\n", (float) *ptr/0xffffffff);
		ptr++;
		printf("   the name is ");
		for (j = 0; j < names; j++) {  /* for each name */
			printf("%d ", *ptr);
			ptr++;
		}
		printf("\n");
	}
}

int pickingToolTip(int x, int y)
{
	int i, n, objid=0;
	double zmin = 10.0;

	GLuint selectBuf[BUFSIZE];
	//GLint viewport[4];

	glSelectBuffer(BUFSIZE, selectBuf);
	glRenderMode(GL_SELECT);
	glInitNames();
	//glPushName((GLuint) ~0);
	//glGetIntegerv(GL_VIEWPORT, viewport);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projecção
	glLoadIdentity();
	setProjection(x,y,GL_TRUE);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	setCamera();
	//desenhar so os nos
	
	glPushMatrix();
		glTranslatef(0,0,0.05);
		glScalef(5,5,5);

		for(int i=0; i<numNos; i++){
			glPushName(i);
			desenhaNo(i);
		}
	glPopMatrix();
	
	//desenhaLabirinto();

	n = glRenderMode(GL_RENDER);

	if(n>0){
		glTranslatef(0,0,0.05);
		Square();
	}


	//processHits (n, selectBuf);
	
	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	myReshape(glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT));
	return n;
}

void desenhaAngVisao(camera_t *cam)
{
	material(azul);
	glEnable(GL_BLEND);
	glDepthMask(GL_FALSE);

	glPushMatrix();
	glTranslatef(estado.camera.center[0],estado.camera.center[1],estado.camera.center[2]+20);

	glRotatef(graus(estado.camera.dir_long)-40,0,0,1);

	glBegin(GL_TRIANGLES);
	glVertex2f(12,50);
	glVertex2f(50,12);
	glVertex2f(0,0);
	glEnd();

	glPopMatrix();

	glDepthMask(GL_TRUE);
	glDisable(GL_BLEND);
}

void setTopSubwindowCamera(camera_t *cam)
{
	cam->eye.x=estado.camera.center[0];
	cam->eye.z=estado.camera.center[1];
	if(estado.vista[JANELA_TOP])
		gluLookAt(estado.camera.center[0],CHAO_DIMENSAO*.4,estado.camera.center[1],estado.camera.center[0],estado.camera.center[2],estado.camera.center[1],0,0,1);
	else
		gluLookAt(estado.camera.center[0],CHAO_DIMENSAO*4,estado.camera.center[1],estado.camera.center[0],estado.camera.center[2],estado.camera.center[1],0,0,1);

	//gluLookAt(0,0,400,0,0.2,0,0,0,1);
}

void displayTopSubwindow()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	//gluLookAt(obj.pos.x,obj.pos.y,obj.pos.z,0,0,-1);

	gluLookAt(estado.camera.center[0],0,CHAO_DIMENSAO*4.5,estado.camera.center[0],0,estado.camera.center[1],0,1,0);
	putLights((GLfloat*)white_light);

	//glCallList(modelo.mini_mapa[JANELA_TOP]);

	material(slate);
	desenhaSolo();

	desenhaLabirinto();

	//desenhaNo1(5);
	desenhaAngVisao(&estado.Camera);

	//glTranslatef(-estado.camera.center[0],-estado.camera.center[1],-estado.camera.center[2]);
	glFlush();
	glutSwapBuffers();
}

void redisplayTopSubwindow(int width, int height)
{
	glViewport(0, 0, width, height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	//gluOrtho2D(0, width, height, 0);
	gluPerspective(estado.camera.fov+15,(GLfloat)glutGet(GLUT_WINDOW_WIDTH) /glutGet(GLUT_WINDOW_HEIGHT),1,500);
	glMatrixMode(GL_MODELVIEW);

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

void mouseToolTip(int x, int y){

	//estado.tooltip=pickingToolTip(x,y);

	cout << estado.tooltip << endl;

}

void main(int argc, char **argv)
{
	alutInit (&argc, argv);
	InitAudio();
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

	//glutPassiveMotionFunc(mouseToolTip);

	myInit();
	imprime_ajuda();

	// criar a sub window topSubwindow
	estado.navigateSubwindow=glutCreateSubWindow(1, 10, height-200, 200, 200);
	myInit();
	glutReshapeFunc(redisplayTopSubwindow);
	glutDisplayFunc(displayTopSubwindow);

	glutMainLoop();
}