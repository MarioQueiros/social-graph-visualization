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
#include <sstream>

#include "mathlib.h"
#include "studio.h"
#include "mdlviewer.h"

using namespace std;
#define graus(X) (double)((X)*180/M_PI)
#define rad(X)   (double)((X)*M_PI/180)
#define NO		1
#define ARCO	10000
#define PAREDE  100000
#define DoD		2000

extern "C" int read_JPEG_file(const char *, char **, int *, int *, int *);

// luzes e materiais
const GLfloat mat_ambient[][4] = {
	{0.33, 0.22, 0.03, 1.0},			// brass
	{0.0, 0.0, 0.0},					// red plastic
	{0.0215, 0.1745, 0.0215},			// emerald
	{0.02, 0.02, 0.02},					// slate
	{0.0, 0.0, 0.1745},					// azul
	{0.02, 0.02, 0.02},					// preto
	{0.1745, 0.1745, 0.1745},			// cinza
	{1.0,1.0,1.0}};						//white

const GLfloat mat_diffuse[][4] = {
	{0.78, 0.57, 0.11, 1.0},			// brass
	{0.5, 0.0, 0.0},					// red plastic
	{0.07568, 0.61424, 0.07568},		// emerald
	{0.78, 0.78, 0.78},					// slate
	{0.0, 0.0,  0.61424},				// azul
	{0.08, 0.08, 0.08},					// preto
	{0.61424, 0.61424, 0.61424},		// cinza
	{1.0,1.0,1.0}};						//white


const GLfloat mat_specular[][4] = {
	{0.99, 0.91, 0.81, 1.0},			// brass
	{0.7, 0.6, 0.6},					// red plastic
	{0.633, 0.727811, 0.633},			// emerald
	{0.14, 0.14, 0.14},					// slate
	{0.0, 0.0, 0.727811},				// azul
	{0.03, 0.03, 0.03},					// preto
	{0.727811, 0.727811, 0.727811},		// cinza
	{1.0,1.0,1.0}};						//white


const GLfloat mat_shininess[] = {
	27.8,								// brass
	32.0,								// red plastic
	76.8,								// emerald
	18.78,								// slate
	30.0,								// azul
	75.0,								// preto
	60.0};								// cinza

enum tipo_material {brass, red_plastic, emerald, slate, azul, preto, cinza,white};

#ifdef __cplusplus
inline tipo_material operator++(tipo_material &rs, int ) {
	return rs = (tipo_material)(rs + 1);
}
#endif

typedef	GLdouble Vertice[3];
typedef	GLdouble Vector[4];

GLint height = 512; 
GLint width = 640;
string username;
string pass;
int state = 0;
int valido = 0;
int linguagem=0;
int name1 = -1;
GLUquadricObj *quad = gluNewQuadric();

typedef enum {
	txUnknown	= 0,
	txBmp		= 1,
	txJpg		= 2,
	txPng		= 3,
	txTga		= 4,
	txGif		= 5,
	txIco		= 6,
	txEmf		= 7,
	txWmf		= 8,
} eglTexType;

typedef struct
{
	GLuint TextureID;   // Texture ID Used To Select A Texture
	eglTexType TexType; // Texture Format
	GLuint Width;       // Image Width
	GLuint Height;      // Image Height
	GLuint Type;        // Image Type (GL_RGB, GL_RGBA)
	GLuint Bpp;         // Image Color Depth In Bits Per Pixel
} glTexture;

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

typedef struct posMouse{
	GLint posMouseX;
	GLint posMouseY;
	GLint flag;
	GLint numeroNo;
} posMouse;

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
	posMouse	posMouse;
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
	GLint       topSubwindow,navigateSubwindow,barWindow;
	GLuint      vista[NUM_JANELAS];
}Estado;

typedef struct Modelo {
#ifdef __cplusplus
	tipo_material cor_cubo;
#else
	enum tipo_material cor_cubo;
#endif
	GLuint  texID[NUM_TEXTURAS];

	GLfloat g_pos_luz1[4];
	GLfloat g_pos_luz2[4];

	GLfloat escala;
	GLUquadric *quad;
	StudioModel   urban,homer,scientist,bugsbunny,hostage,nuku_Girl,Spiderman,anonymous;
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
	estado.camera.eye.x = 5.0 * nos[0].x + 20; 
	estado.camera.eye.y = 5.0 * nos[0].y + 20;
	estado.camera.eye.z = 5.0 * (nos[0].z + 10.0 + nos[0].largura + 1.25);
	estado.light=GL_FALSE;
	estado.apresentaNormais=GL_FALSE;
	estado.lightViewer=2;
	estado.k = 1;
	estado.timer = 20;	
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

void createTextures(GLuint texID[])
{
	char *image;
	int w, h, bpp;

	glGenTextures(NUM_TEXTURAS,texID);

	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

	if(read_JPEG_file(NOME_TEXTURA_CHAO, &image, &w, &h, &bpp))
	{
		glBindTexture(GL_TEXTURE_2D, texID[ID_TEXTURA_CHAO]);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST );
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, image);
	}else{
		printf("Textura %s not Found\n",NOME_TEXTURA_CHAO);
		exit(0);
	}

	if(read_JPEG_file(NOME_TEXTURA_BILLBOARD, &image, &w, &h, &bpp))
	{
		glBindTexture(GL_TEXTURE_2D, texID[ID_TEXTURA_BILLBOARD]);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST );
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, image);
	}else{
		printf("Textura %s not Found\n",NOME_TEXTURA_BILLBOARD);
		exit(0);
	}

	if(read_JPEG_file(NOME_TEXTURA_PAREDE, &image, &w, &h, &bpp))
	{
		glBindTexture(GL_TEXTURE_2D, texID[ID_TEXTURA_PAREDE]);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST );
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, image);
	}else{
		printf("Textura %s not Found\n",NOME_TEXTURA_PAREDE);
		exit(0);
	}
	glBindTexture(GL_TEXTURE_2D, NULL);
}

void myInit()
{
	GLfloat LuzAmbiente[]={0.5,0.5,0.5, 0.0};

	glClearColor (0.0, 0.0, 0.0, 0.0);

	glEnable(GL_LIGHTING);

	glEnable(GL_DEPTH_TEST);
	glShadeModel(GL_SMOOTH);
	glEnable(GL_POINT_SMOOTH);
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_POLYGON_SMOOTH);
	glEnable(GL_TEXTURE_2D);
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
	mdlviewer_init("urban.mdl", modelo.urban);
	mdlviewer_init("scientist.mdl", modelo.scientist);
	mdlviewer_init("bugsbunny.mdl", modelo.bugsbunny);
	mdlviewer_init("hostage.mdl", modelo.hostage);
	mdlviewer_init("nuku_Girl.mdl", modelo.nuku_Girl);
	mdlviewer_init("Spiderman.mdl", modelo.Spiderman);
	mdlviewer_init("anonymous.mdl", modelo.anonymous);
	mdlviewer_init("homer.mdl", modelo.homer);
}

void Init()
{
	GLfloat LuzAmbiente[]={0.5,0.5,0.5, 0.0};

	glClearColor (0.0, 0.0, 0.0, 0.0);

	glEnable(GL_SMOOTH); 
	glEnable(GL_LIGHTING); 
	glEnable(GL_DEPTH_TEST); 
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

void setProjection(int x, int y, GLboolean picking)
{
	glLoadIdentity();
	if (picking) { // se está no modo picking, lê viewport e define zona de picking
		GLint vport[4];
		glGetIntegerv(GL_VIEWPORT, vport);
		gluPickMatrix(x, glutGet(GLUT_WINDOW_HEIGHT)  - y, 4, 4, vport); // Inverte o y do rato para corresponder à jana
	}
	gluPerspective(estado.camera.fov,(GLfloat)glutGet(GLUT_WINDOW_WIDTH) /glutGet(GLUT_WINDOW_HEIGHT) ,1,DoD);
}

void myReshape2(int w, int h)
{	
	glViewport(0, 0, w, h);
	glMatrixMode(GL_PROJECTION);
	setProjection(0,0,GL_FALSE);
	glMatrixMode(GL_MODELVIEW);
}

void RenderString(void *fonte, string texto)
{  
	glColor3ub(0,0,0);			  // cor
	glRasterPos2i(-380,-40);     // posicao do texto na tooltip

	// string tmp( "tiago gay" );
	for( size_t i = 0; i < texto.size(); ++i )
	{
		glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, texto[i]);
	}
}

void desenhatooltip (int x, int y, GLuint texID)
{
	//material(azul);
	if(estado.posMouse.flag==1){

		glDisable(GL_LIGHTING);
		glColor3ub(255,0,0);
		glDisable(GL_DEPTH_TEST);
		glLoadIdentity();
		glViewport(x,y,400,400);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(-400,400,-400,400,0,100);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();

		glPushMatrix();


		glBindTexture(GL_TEXTURE_2D, texID);
		glColor3f(1.0f,1.0f,1.0f);
		glBegin(GL_POLYGON);
		glTexCoord2f(1,1);glVertex2f(0,0);
		glTexCoord2f(0,1);glVertex2f(-400,0);
		glTexCoord2f(0,0);glVertex2f(-400,-400);
		glTexCoord2f(1,0);glVertex2f(0,-400);
		glEnd();
		glBindTexture(GL_TEXTURE_2D, NULL);
		glPopMatrix();


		//glBindTexture(GL_TEXTURE_2D, NULL);
		std::string texto;
		std::stringstream out;
		out << estado.posMouse.numeroNo;
		texto = out.str();

		RenderString(GLUT_BITMAP_TIMES_ROMAN_24, texto);

		myReshape2(glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT));		
		glEnable(GL_DEPTH_TEST);	
	}

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
#define STEP 1200
	//desenhar solo
	glPushName(PAREDE + 5);
	glPushMatrix();
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_CHAO]);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-600;i<600;i+=STEP){
		for(int j=-600;j<600;j+=STEP){
			glTexCoord2f(1,1);glVertex2f(i,j);
			glTexCoord2f(0,1);glVertex2f(i+STEP,j);
			glTexCoord2f(0,0);glVertex2f(i+STEP,j+STEP);
			glTexCoord2f(1,0);glVertex2f(i,j+STEP);
		}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();


	glPushName(PAREDE + 1);
	glPushMatrix();
	glTranslatef(0,0,600);
	glRotatef(90,0,1,0);
	glRotatef(90,0,1,0);
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_PAREDE]);
	glColor3f(1.0f,1.0f,1.0f);
	gluQuadricDrawStyle(quad,GLU_FILL);
	gluQuadricTexture(quad,1.0);
	gluCylinder(quad, 500, 500, 600, 32,32);
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();

	/*
	//desenhar parede 1
	glPushName(PAREDE + 1);
	glPushMatrix();
	glRotatef(90,1,0,0);
	glTranslatef(0,600,0);
	glTranslatef(0,0,-600);
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_PAREDE]);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-600;i<600;i+=STEP){
	for(int j=-600;j<600;j+=STEP){
	glTexCoord2f(1,1);glVertex2f(i,j);
	glTexCoord2f(0,1);glVertex2f(i+STEP,j);
	glTexCoord2f(0,0);glVertex2f(i+STEP,j+STEP);
	glTexCoord2f(1,0);glVertex2f(i,j+STEP);
	}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();

	//desenhar parede 2
	glPushName(PAREDE + 2);
	glPushMatrix();
	glRotatef(90,1,0,0);
	glTranslatef(0,600,0);
	glTranslatef(0,0,600);
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_PAREDE]);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-600;i<600;i+=STEP){
	for(int j=-600;j<600;j+=STEP){
	glTexCoord2f(1,1);glVertex2f(i,j);
	glTexCoord2f(0,1);glVertex2f(i+STEP,j);
	glTexCoord2f(0,0);glVertex2f(i+STEP,j+STEP);
	glTexCoord2f(1,0);glVertex2f(i,j+STEP);
	}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();

	//desenhar parede 3
	glPushName(PAREDE + 3);
	glPushMatrix();
	glRotatef(90,0,1,0);
	glTranslatef(0,0,-600);
	glTranslatef(-600,0,0);
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_PAREDE]);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-600;i<600;i+=STEP){
	for(int j=-600;j<600;j+=STEP){
	glTexCoord2f(1,0);glVertex2f(i,j);
	glTexCoord2f(1,1);glVertex2f(i+STEP,j);
	glTexCoord2f(0,1);glVertex2f(i+STEP,j+STEP);
	glTexCoord2f(0,0);glVertex2f(i,j+STEP);
	}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();

	//desenhar parede 4
	glPushName(PAREDE + 4);
	glPushMatrix();
	glRotatef(90,0,1,0);
	glTranslatef(0,0,600);
	glTranslatef(-600,0,0);
	glBindTexture(GL_TEXTURE_2D, modelo.texID[ID_TEXTURA_PAREDE]);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_QUADS);
	glNormal3f(0,0,1);
	for(int i=-600;i<600;i+=STEP){
	for(int j=-600;j<600;j+=STEP){
	glTexCoord2f(1,0);glVertex2f(i,j);
	glTexCoord2f(1,1);glVertex2f(i+STEP,j);
	glTexCoord2f(0,1);glVertex2f(i+STEP,j+STEP);
	glTexCoord2f(0,0);glVertex2f(i,j+STEP);
	}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);
	glPopMatrix();
	glPopName();*/
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

/*
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
*/

void desenhaEsfera(int no,GLfloat xi, GLfloat yi, GLfloat zi, GLfloat raio)
{
	GLdouble cross[3];
	GLfloat valAng=0;
	GLint n=32;

	glPushMatrix();
	if(no==0)
		material(red_plastic);
	else
		material(azul);
	glNormal3f(0,0,1);
	glTranslatef(xi,yi,zi+10); //meter mais para cima

	glutSolidSphere(raio, 16, 16);

	glPopMatrix();
	material(white);
	if(estado.apresentaNormais) {
		cross[0]=0;
		cross[1]=0;
		cross[2]=1;
		desenhaNormal(xi,yi,zi,cross,azul);
	}
}

void desenhaNo(int no,int texID)
{
	GLboolean norte,sul,este,oeste;
	GLfloat larguraNorte,larguraSul,larguraEste,larguraOeste;
	Arco arco=arcos[0];
	No *noi=&nos[no],*nof;
	norte=sul=este=oeste=GL_TRUE;

	glPushMatrix();
	glTranslatef(nos[no].x,nos[no].y,(nos[no].z + 10.0 + nos[no].largura + 2.0));
	glRotatef(-90,0,0,1);
	glScalef(SCALE_HOMER,SCALE_HOMER,SCALE_HOMER);

	material(white);
	if(no==0/*avatar.compare("homer")==0*/)
		mdlviewer_display(modelo.homer);
	if(no==1/*avatar.compare("urban")==0*/)
		mdlviewer_display(modelo.urban);
	if(no==2/*avatar.compare("spiderman")==0*/)
		mdlviewer_display(modelo.Spiderman);
	if(no==3/*avatar.compare("anonymous")==0*/)
		mdlviewer_display(modelo.anonymous);
	if(no==4/*avatar.compare("bugsbunny")==0*/)
		mdlviewer_display(modelo.bugsbunny);
	if(no==5/*avatar.compare("hostage")==0*/)
		mdlviewer_display(modelo.hostage);
	if(no==6/*avatar.compare("nuku_Girl")==0*/)
		mdlviewer_display(modelo.nuku_Girl);
	if(no==7/*avatar.compare("scientist")==0*/)
		mdlviewer_display(modelo.scientist);

	glPopMatrix();

	glPushMatrix();
	glTranslatef(nos[no].x+1,nos[no].y,(nos[no].z + 14.0 + nos[no].largura + 2.0));
	glRotatef(-90,1,0,0);

	glBindTexture(GL_TEXTURE_2D, texID);
	glColor3f(1.0f,1.0f,1.0f);
	glBegin(GL_POLYGON);
	glTexCoord2f(1,1);glVertex2f(0,0);
	glTexCoord2f(0,1);glVertex2f(-3,0);
	glTexCoord2f(0,0);glVertex2f(-3,-3);
	glTexCoord2f(1,0);glVertex2f(0,-3);
	glEnd();
	glBindTexture(GL_TEXTURE_2D, NULL);


	glPopMatrix();

	desenhaEsfera(no,nos[no].x,nos[no].y,nos[no].z,nos[no].largura);

	if(estado.zmin > nos[no].z)
	{
		estado.zmin = nos[no].z;
	}
	if(estado.zmax < nos[no].z)
	{
		estado.zmax = nos[no].z;
	}
	glFlush();
}

void desenhaArco(Arco arco)
{
	No *noi,*nof;
	noi=&nos[arco.noi];
	nof=&nos[arco.nof];
	GLfloat d= sqrt(pow(nof->x-noi->x,2)+pow(nof->y-noi->y,2));
	GLfloat r= sqrt(pow(d,2)+pow(nof->z-noi->z,2));

	//recebe o no de destino 
	//o prolog determina o caminho mais curto entre dois users
	//se houver pinta de cor diferente
	if((arco.noi == 0 && arco.nof == name1 -1) || (arco.noi == name1 -1 && arco.nof == 0))
		material(brass);
	//senão 
	else		
		material(cinza);

	glPushMatrix();

	glTranslatef(noi->x,noi->y,noi->z+10); //meter mais para baixo
	glRotatef(graus(atan2(nof->y-noi->y,nof->x-noi->x)),0,0,1);
	glRotatef(graus((M_PI/2.0)-atan2(nof->z-noi->z,d)),0,1,0);
	gluCylinder(quad,arco.largura/2.0,arco.largura/2.0,r,32,32);

	glPopMatrix();	
}

void desenhaLabirinto()
{
	estado.zmin = 0;
	estado.zmax = 0;
	glPushMatrix();
	glTranslatef(0,0,0.05);
	glScalef(5,5,5);


	for(int i=0; i<numNos; i++){
		glPushName(NO + i);
		desenhaNo(i,modelo.texID[ID_TEXTURA_BILLBOARD]);
		glPopName();
	}
	for(int i=0; i<numArcos; i++){
		glPushName(ARCO + i);
		desenhaArco(arcos[i]);
		glPopName();
	}
	glPopMatrix();
	glFlush();
}

/*
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
*/

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

/*
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
*/

void setCamera()
{
	Vertice eye;
	estado.camera.center[0] = estado.camera.eye.x + estado.camera.dist * cos(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	estado.camera.center[1] = estado.camera.eye.y + estado.camera.dist * sin(estado.camera.dir_long) * cos(estado.camera.dir_lat);
	estado.camera.center[2] = estado.camera.eye.z + estado.camera.dist * sin(estado.camera.dir_lat);

	putLights((GLfloat*)white_light);
	//gluLookAt(estado.camera.eye.x,estado.camera.eye.y,estado.camera.eye.z,estado.camera.center[0],estado.camera.center[1],estado.camera.center[2],0,0,1);

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

void bitmapString(char *str, double x, double y, int s)
{
	int i,n;
	// fonte pode ser:
	// GLUT_BITMAP_8_BY_13
	// GLUT_BITMAP_9_BY_15
	// GLUT_BITMAP_TIMES_ROMAN_10
	// GLUT_BITMAP_TIMES_ROMAN_24
	// GLUT_BITMAP_HELVETICA_10
	// GLUT_BITMAP_HELVETICA_12
	// GLUT_BITMAP_HELVETICA_18

	n = (int)strlen(str);
	glRasterPos2d(x,y);
	for (i=0;i<n;i++)
		if(s==1)
			glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,(int)str[i]);
		else if(s==2)
			glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18,(int)str[i]);
		else if(s==3)
			glutBitmapCharacter(GLUT_BITMAP_9_BY_15,(int)str[i]);
		else 
			glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12,(int)str[i]);
}

char *convertstringtochar(string str)
{
	char * ch= new char[str.length()+1];
	strcpy (ch,str.c_str());
	return ch;
}

char *convertstringtocharCode(string str)
{
	string s = "";
	for(int i=0; i<str.size();i++){
		s += "*";
	}
	char * ch = new char[str.length()+1];
	strcpy (ch,s.c_str());
	return ch;
}

void desenhaTextBox(GLenum mode ,int wi, int wf, int hi, int hf, int name)
{
	if (mode == GL_SELECT){
		glPushName(name);
		glBegin(GL_POLYGON);
	}
	else{
		glBegin(GL_LINE_LOOP);
	}
	glVertex2f(wi,hi);
	glVertex2f(wf, hi);
	glVertex2f(wf, hf);
	glVertex2f(wi, hf);
	glEnd();
	glPopName();
}

void display(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	setCamera();

	material(slate);
	desenhaSolo();

	desenhaLabirinto();

	desenhatooltip(estado.posMouse.posMouseX,glutGet(GLUT_WINDOW_HEIGHT)-estado.posMouse.posMouseY,modelo.texID[ID_TEXTURA_CHAO]);

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

void Reshape2(int width, int height)
{
	glViewport(0, 0, (GLint) width, (GLint) height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0, width, 0, height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glutSetWindow (estado.barWindow);
	glutPositionWindow (0, 0);
	glutReshapeWindow(width,100);
}

void drawBar()
{
	glClearDepth(1.0);
	glClearColor(0.09,0.09,0.44,0);
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_LIGHTING);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_COLOR_MATERIAL);
	glPushMatrix();
	glColor3f(1.0,1.0,1.0);
	bitmapString("Graphs4Social", 50, glutGet(GLUT_WINDOW_HEIGHT)-50, 1);// glutGet(GLUT_WINDOW_HEIGHT)/1.15);
	glColor3f(0.75,0.75,1.0);
	desenhaTextBox(GL_SELECT, glutGet(GLUT_WINDOW_WIDTH)-380, glutGet(GLUT_WINDOW_WIDTH)-260, 
		glutGet(GLUT_WINDOW_HEIGHT)-30, glutGet(GLUT_WINDOW_HEIGHT)-60, 4);
	glColor3f(0.0,0.0,0.0);
	bitmapString("English", glutGet(GLUT_WINDOW_WIDTH)-350, glutGet(GLUT_WINDOW_HEIGHT)-50, 3);
	glColor3f(0.75,0.75,1.0);
	desenhaTextBox(GL_SELECT, glutGet(GLUT_WINDOW_WIDTH)-230, glutGet(GLUT_WINDOW_WIDTH)-80, 
		glutGet(GLUT_WINDOW_HEIGHT)-30, glutGet(GLUT_WINDOW_HEIGHT)-60, 5);
	glColor3f(0.0,0.0,0.0);
	bitmapString("Portuguese", glutGet(GLUT_WINDOW_WIDTH)-200, glutGet(GLUT_WINDOW_HEIGHT)-50, 3);
	glPopMatrix();
	glFlush();
	glutSwapBuffers();
}

void Draw(void)
{ 
	glClearDepth(1.0);
	glClearColor(0.75,0.75,1.0,0);
	glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_LIGHTING);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_COLOR_MATERIAL);
	glPushMatrix();
	if(linguagem==0 || linguagem==2){
		glColor3f(00.0,0.0,0.0);
		bitmapString("Utilizador:", 10, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 2);
		if(state==1){
			glColor3f(0.7,0.7,0.7);
			desenhaTextBox(GL_SELECT, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.4, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 1);
			glColor3f(0.0,0.0,0.0);
			bitmapString(convertstringtochar(username), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.46, 3);
		}else{
			glColor3f(0.2,0.2,0.2);
			bitmapString(convertstringtochar(username), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.46, 3);
			glColor3f(1.0,1.0,1.0);
			desenhaTextBox(GL_RENDER, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.4, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 1);
		}
		glColor3f(00.0,0.0,0.0);
		bitmapString("Palavra-passe:", 10, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
		if(state==2){
			glColor3f(0.7,0.7,0.7);
			desenhaTextBox(GL_SELECT, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.66, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
			glColor3f(0.0,0.0,0.0);
			bitmapString(convertstringtocharCode(pass), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.75, 3);
		}else{
			glColor3f(0.2,0.2,0.2);
			bitmapString(convertstringtocharCode(pass), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.75, 3);
			glColor3f(1.0,1.0,1.0);
			desenhaTextBox(GL_RENDER, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.66, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
		}
		glColor3f(0.09,0.09,0.44);
		desenhaTextBox(GL_SELECT, 150, 300, glutGet(GLUT_WINDOW_HEIGHT)/2.0, glutGet(GLUT_WINDOW_HEIGHT)/2.2, 3);
		glColor3f(1.0,1.0,1.0);
		bitmapString("Iniciar", 200, glutGet(GLUT_WINDOW_HEIGHT)/2.16, 2);
		if(valido == -1){
			glColor3f(0.5, 0.0, 0.0); 
			bitmapString("Utilizador invalido!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}else if(valido == -2){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Introduza o nome do utilizador e a palavra-passe!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
		else if(valido == -3){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Introduza a palavra-passe!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
		else if(valido == -4){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Introduza o nome do utilizador!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
	}else{
		glColor3f(00.0,0.0,0.0);
		bitmapString("User:", 10, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 2);
		if(state==1){
			glColor3f(0.7,0.7,0.7);
			desenhaTextBox(GL_SELECT, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.4, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 1);
			glColor3f(0.0,0.0,0.0);
			bitmapString(convertstringtochar(username), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.46, 3);
		}else{
			glColor3f(0.2,0.2,0.2);
			bitmapString(convertstringtochar(username), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.46, 3);
			glColor3f(1.0,1.0,1.0);
			desenhaTextBox(GL_RENDER, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.4, glutGet(GLUT_WINDOW_HEIGHT)/1.5, 1);
		}
		glColor3f(00.0,0.0,0.0);
		bitmapString("Password:", 10, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
		if(state==2){
			glColor3f(0.7,0.7,0.7);
			desenhaTextBox(GL_SELECT, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.66, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
			glColor3f(0.0,0.0,0.0);
			bitmapString(convertstringtocharCode(pass), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.75, 3);
		}else{
			glColor3f(0.2,0.2,0.2);
			bitmapString(convertstringtocharCode(pass), 160, glutGet(GLUT_WINDOW_HEIGHT)/1.75, 3);
			glColor3f(1.0,1.0,1.0);
			desenhaTextBox(GL_RENDER, 150, 350, glutGet(GLUT_WINDOW_HEIGHT)/1.66, glutGet(GLUT_WINDOW_HEIGHT)/1.8, 2);
		}
		glColor3f(0.09,0.09,0.44);
		desenhaTextBox(GL_SELECT, 150, 300, glutGet(GLUT_WINDOW_HEIGHT)/2.0, glutGet(GLUT_WINDOW_HEIGHT)/2.2, 3);
		glColor3f(1.0,1.0,1.0);
		bitmapString("Login", 200, glutGet(GLUT_WINDOW_HEIGHT)/2.16, 2);
		if(valido == -1){
			glColor3f(0.5, 0.0, 0.0); 
			bitmapString("Invalid user!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}else if(valido == -2){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Enter the username and password!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
		else if(valido == -3){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Enter the password!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
		else if(valido == -4){
			glColor3f(0.5, 0.0, 0.0);
			bitmapString("Enter the username!", 150, glutGet(GLUT_WINDOW_HEIGHT)/2.8, 3);
		}
	}
	glPopMatrix();
	glFlush();
	glutSwapBuffers();
	glutPostRedisplay();
}

void setProjectionLogin(int x, int y, GLboolean picking)
{
	glLoadIdentity();
	if (picking) { // se está no modo picking, lê viewport e define zona de picking
		GLint vport[4];
		glGetIntegerv(GL_VIEWPORT, vport);
		gluPickMatrix(x, glutGet(GLUT_WINDOW_HEIGHT)  - y, 4, 4, vport); // Inverte o y do rato para corresponder à jana
	}
	gluOrtho2D(0,glutGet(GLUT_WINDOW_WIDTH),0,glutGet(GLUT_WINDOW_HEIGHT));
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
	desenhaSolo();
	desenhaLabirinto();
	n = glRenderMode(GL_RENDER);
	ptr = (GLuint *) buffer;
	for (i = 0; i < n; i++) { /* for each hit */
		names = (int) *ptr;
		ptr++;
		if(zmin > (float)*ptr/UINT_MAX){
			zmin = (float)*ptr/UINT_MAX;
		}
		ptr++;
		ptr++;
		for (j = 0; j < names; j++) { /* for each name */
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
		estado.k = (d - DIMEMSAO_CAMARA / 2.0 - inf)/estado.camera.vel;
		if(estado.k<0) estado.k=0;
	}else{
		estado.k = 1;
	}
	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	return estado.k;
}

GLdouble colisaoRasante()
{
	int i, j, names;
	int n, objid=0;
	double zmin = 10.0, zmax = 10.0;
	estado.zmin = (estado.zmin + 1) * 35;
	estado.zmax = (estado.zmax + 1) * 35; 
	GLuint buffer[100], *ptr;
	GLdouble newx, newy, newz;
	GLint vp[4];
	GLdouble proj[16], mv[16];
	GLint farP = 0, nearP = 0; 
	nearP = estado.zmax - 1;
	farP = estado.zmin + 1;
	glSelectBuffer(100, buffer);
	glRenderMode(GL_SELECT);
	glInitNames();
	glPushName(0);
	glMatrixMode(GL_PROJECTION);
	glPushMatrix(); // guarda a projecção
	glLoadIdentity();
	/*gluPickMatrix(estado.camera.center[0],estado.camera.center[1],glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT),vp);
	glOrtho(estado.camera.center[0] - estado.camera.velh, estado.camera.center[0] + estado.camera.velh, 
	estado.camera.center[1] - estado.camera.velh, estado.camera.center[1] + estado.camera.velh, -nearP, -farP);*/
	gluPickMatrix(estado.camera.eye.x, estado.camera.eye.y,glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT),vp);
	glOrtho(estado.camera.eye.x - estado.camera.velh, estado.camera.eye.x + estado.camera.velh, 
		estado.camera.eye.y - estado.camera.velh, estado.camera.eye.y + estado.camera.velh, -nearP, -farP);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	desenhaLabirinto();
	/*n = glRenderMode(GL_RENDER);
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
	/*if (zmin > (double) ptr[1] / UINT_MAX) {
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
	}*/
	n = glRenderMode(GL_RENDER);
	ptr = (GLuint *) buffer;
	for (i = 0; i < n; i++) { /* for each hit */
		names = (int) *ptr;
		ptr++;
		if(zmin > (float)*ptr/UINT_MAX){
			zmin = (float)*ptr/UINT_MAX;
			objid = ptr[3];
		}
		ptr++;
		ptr++;
		for (j = 0; j < names; j++) { /* for each name */
			ptr++;
		}	
	}
	if(n!=0){
		glGetIntegerv(GL_VIEWPORT,vp);
		glGetDoublev(GL_PROJECTION_MATRIX,proj);
		glGetDoublev(GL_MODELVIEW_MATRIX, mv);
		gluUnProject(glutGet(GLUT_WINDOW_WIDTH)/2.0, glutGet(GLUT_WINDOW_HEIGHT)/2.0, (double) zmin / UINT_MAX, mv, proj, vp, &newx, &newy, &newz);
	}
	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	return newz;
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
			nx = estado.camera.eye.x + k * cos(estado.camera.dir_long);
			ny = estado.camera.eye.y + k * sin(estado.camera.dir_long);
			estado.camera.eye.x = nx;
			estado.camera.eye.y = ny;
			estado.camera.velh = 0;
			estado.k = 1;
		}else{
			// se voo rasante
			estado.camera.velh = VELOCIDADE_HORIZONTAL;
			estado.camera.velv = VELOCIDADE_VERTICAL;
			double rasante = colisaoRasante();
			if(rasante > 0)
			{
				nx = estado.camera.eye.x + estado.camera.velh * cos(estado.camera.dir_long);
				ny = estado.camera.eye.y + estado.camera.velh * sin(estado.camera.dir_long);
				//nz = rasante;
				estado.camera.eye.x = nx;
				estado.camera.eye.y = ny; 
				estado.camera.center[2] = rasante + DISTANCIA_SOLO;
				//estado.camera.eye.z = nz; 
				//estado.camera.center[2] = estado.camera.center[2] + DISTANCIA_SOLO;
			}
			estado.camera.velh = 0;
			estado.camera.velv = 0;
		}
	}
	// ir p/ tras
	if(estado.teclas.down){
		// se voo livre
		if(!estado.vooRasante)
		{
			estado.camera.velh = -VELOCIDADE_HORIZONTAL;
			estado.camera.velv = 0;
			k = colisaoLivre();
			nx = estado.camera.eye.x - k * cos(estado.camera.dir_long);
			ny = estado.camera.eye.y - k * sin(estado.camera.dir_long);
			estado.camera.eye.x = nx;
			estado.camera.eye.y = ny;
			estado.camera.velh = 0;
		}else{
			// se voo rasante
			estado.camera.velh = VELOCIDADE_HORIZONTAL;
			estado.camera.velv = VELOCIDADE_VERTICAL;
			double rasante = colisaoRasante();
			if(rasante > 0)
			{
				nx = estado.camera.eye.x - estado.camera.velh * cos(estado.camera.dir_long);
				ny = estado.camera.eye.y - estado.camera.velh * sin(estado.camera.dir_long);
				estado.camera.eye.x = nx;
				estado.camera.eye.y = ny; 
				estado.camera.center[2] = rasante + DISTANCIA_SOLO;
			}
			estado.camera.velh = 0;
			estado.camera.velv = 0;
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
			if(estado.camera.center[2] < 600)
				k = colisaoLivre();
			nz = estado.camera.eye.z + k * sin(estado.camera.dir_lat);
			estado.camera.eye.z = nz;
			estado.camera.velv = 0;
		}
		if(estado.teclas.a){
			// descer camara
			estado.camera.velh = 0;
			estado.camera.velv = -VELOCIDADE_VERTICAL;
			k = colisaoLivre();
			nz = estado.camera.eye.z - k * sin(estado.camera.dir_lat);
			estado.camera.eye.z = nz;
			estado.camera.velv = 0;
		}
	}
	redisplayAll();
}

void TimerLogin(int value)
{
	GLuint curr = glutGet(GLUT_ELAPSED_TIME);
	glutTimerFunc(estado.timer, TimerLogin, 0);
	glutPostRedisplay();
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
			estado.vooRasante = GL_TRUE;
		}
		else{
			estado.vooRasante = GL_FALSE;
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
	case 's':
	case 'S':
		if(!audio.tecla_s){
			audio.tecla_s = AL_TRUE;
		}else{
			audio.tecla_s = AL_FALSE;
		}
		break;
	default:
		username +=key;
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
		estado.teclas.up = GL_TRUE;
		break;
	case GLUT_KEY_DOWN:
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
	glutSetWindow (estado.navigateSubwindow);
	glutPositionWindow (10, height-200);
	glutReshapeWindow(200,200);
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

void motionRotate(int x, int y){
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
	//desenhaEixos();
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

	//printf("hits = %d\n", hits);
	ptr = (GLuint *) buffer;
	for (i = 0; i < hits; i++) {  /* for each hit  */
		names = *ptr;
		estado.posMouse.numeroNo=names;
		//printf(" number of names for hit = %d\n", names);
		ptr++;
		//printf("  z1 is %g;", (float) *ptr/0xffffffff);
		ptr++;
		//printf(" z2 is %g\n", (float) *ptr/0xffffffff);
		ptr++;
		//printf("   the name is ");
		for (j = 0; j < names; j++) {  /* for each name */
			//printf("%d ", *ptr);
			ptr++;
		}
		//printf("\n");
	}
}

int pickingToolTip(int x, int y)
{
	int numero,i, n, objid=0;
	double zmin = 10.0;
	GLint width,height;
	GLuint selectBuf[BUFSIZE];

	glSelectBuffer(BUFSIZE, selectBuf);
	glRenderMode(GL_SELECT);
	glInitNames();
	//glPushName((GLuint) ~0);
	//glGetIntegerv(GL_VIEWPORT, viewport);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
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
		desenhaNo(i,modelo.texID[ID_TEXTURA_CHAO]);
	}
	glPopMatrix();

	//desenhaLabirinto();
	estado.posMouse.posMouseX=x;
	estado.posMouse.posMouseY=y;

	n = glRenderMode(GL_RENDER);

	if (n>0){
		estado.posMouse.flag=1;
	}else{
		estado.posMouse.flag=0;
	}

	processHits (n, selectBuf);

	glMatrixMode(GL_PROJECTION); //repõe matriz projecção
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	myReshape2(glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT));
	return n;
}

void process(GLint hits, GLuint buffer[])
{
	int i;
	unsigned int j;
	GLuint names, *ptr, name=0;
	ptr = (GLuint *) buffer;
	for (i = 0; i < hits; i++) { /* for each hit */
		names = *ptr;
		ptr+=3;
		for (j = 0; j < names; j++) { /* for each name */
			try{
				name = *ptr;
			}catch(exception e)
			{}
			//ptr++;
		}
		ptr++;
	}
	if(name1 == -1){
		name1 = name;
	}
	else if(name1 != 1){
		name1 = name;
	}
}

void desenhaAngVisao(camera_t *cam)
{
	material(red_plastic);
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
}

void displayTopSubwindow()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	//gluLookAt(obj.pos.x,obj.pos.y,obj.pos.z,0,0,-1);

	gluLookAt(estado.camera.center[0],0,CHAO_DIMENSAO*4.5,estado.camera.center[0],0,estado.camera.center[1],0,1,0);
	putLights((GLfloat*)white_light);

	material(slate);
	desenhaSolo();

	desenhaLabirinto();

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
	gluPerspective(estado.camera.fov+15,(GLfloat)glutGet(GLUT_WINDOW_WIDTH) /glutGet(GLUT_WINDOW_HEIGHT),1,DoD);
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
		/*case GLUT_LEFT_BUTTON :
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
		/*	glutMotionFunc(NULL);
		estado.eixoTranslaccao=0;
		glutPostRedisplay();
		}*/
		//cout << "Right up\n";
		/*}
		break;*/
	case GLUT_LEFT_BUTTON :
		if(state == GLUT_DOWN){
			int numero,i, n, objid=0;
			double zmin = 10.0;
			GLint width,height;
			GLuint selectBuf[BUFSIZE];

			glSelectBuffer(BUFSIZE, selectBuf);
			glRenderMode(GL_SELECT);
			glInitNames();

			glMatrixMode(GL_PROJECTION);
			glPushMatrix();
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
				glPushName(NO+i);
				desenhaNo(i,modelo.texID[ID_TEXTURA_CHAO]);
				glPopName();
			}
			glPopMatrix();

			n = glRenderMode(GL_RENDER);

			if (n>0){
				process (n, selectBuf);
			}else{
				name1 = -1;
			}

			glMatrixMode(GL_PROJECTION); //repõe matriz projecção
			glPopMatrix();
			glMatrixMode(GL_MODELVIEW);
			myReshape2(glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT));
		}
	}
}

void mouseToolTip(int x, int y){

	estado.tooltip=pickingToolTip(x,y);

	//cout << estado.tooltip << endl;

}

void processaUser() 
{
	if(username.compare("leniker")==0 && pass.compare("gomes")==0)
	{
		glutDestroyWindow(estado.barWindow);
		glutDestroyWindow(1);
		glutInitWindowPosition(0, 0);
		glutInitWindowSize(width,height);	
		glutInitDisplayMode(GLUT_DOUBLE| GLUT_RGB);
		if (glutCreateWindow("Graphs4Social") == GL_FALSE)
			exit(1);
		createTextures(modelo.texID);
		//mdlviewer_init("urban.mdl", modelo.homer);
		glutReshapeFunc(myReshape);
		InitAudio();
		glutDisplayFunc(display);
		glutTimerFunc(estado.timer,Timer,0);
		glutKeyboardFunc(keyboard);
		glutKeyboardUpFunc(keyboardUp);
		glutSpecialFunc(Special);
		glutSpecialUpFunc(SpecialKeyUp);
		glutMouseFunc(mouse);
		glutMouseFunc(mouse);
		glutPassiveMotionFunc(mouseToolTip);
		myInit();
		imprime_ajuda();
		// criar a sub window topSubwindow
		estado.navigateSubwindow=glutCreateSubWindow(1, 10, height-200, 200, 200);
		myInit();
		glutReshapeFunc(redisplayTopSubwindow);
		glutDisplayFunc(displayTopSubwindow);
		valido = 1;
	}else{
		valido = -1;
	}
}

void processHits2(GLint hits, GLuint buffer[])
{
	int i;
	unsigned int j;
	GLuint names, *ptr, name=0;
	ptr = (GLuint *) buffer;
	for (i = 0; i < hits; i++) { /* for each hit */
		names = *ptr;
		ptr+=3;
		for (j = 0; j < names; j++) { /* for each name */
			try{
				name = *ptr;
			}catch(exception e)
			{}
			//ptr++;
		}
		ptr++;
	}
	if(name == 1){
		state = 1;
	}
	if(name == 2){
		state = 2;
	}
	if(name == 3){
		if(username.compare("")==0 && pass.compare("")==0){
			valido = -2;
		}else if(pass.compare("")==0){
			valido = -3;
		}else if(username.compare("")==0){
			valido = -4;
		}else{
			processaUser();
		}
	}
	if(name == 4){
		linguagem = 1;
	}
	if(name == 5){
		linguagem = 2;
	}
}

void enterKey(){
	if(username.compare("")==0 && pass.compare("")==0){
		valido = -2;
	}else if(pass.compare("")==0){
		valido = -3;
	}else if(username.compare("")==0){
		valido = -4;
	}else{
		processaUser();
	}
}

void escolheTextbox(int button, int state, int x, int y)
{
	GLuint selectBuf[BUFSIZE];
	GLint hits;
	if (button != GLUT_LEFT_BUTTON || state != GLUT_DOWN)
		return;
	glSelectBuffer(BUFSIZE, selectBuf);
	(void) glRenderMode(GL_SELECT);
	glInitNames();
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	setProjectionLogin(x,y,GL_TRUE);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	desenhaTextBox(GL_SELECT, 150,350, glutGet(GLUT_WINDOW_HEIGHT)/1.4, glutGet(GLUT_WINDOW_HEIGHT)/1.5,1);
	desenhaTextBox(GL_SELECT, 150,350, glutGet(GLUT_WINDOW_HEIGHT)/1.66, glutGet(GLUT_WINDOW_HEIGHT)/1.8,2);
	desenhaTextBox(GL_SELECT, 150,300, glutGet(GLUT_WINDOW_HEIGHT)/2.0, glutGet(GLUT_WINDOW_HEIGHT)/2.2,3);
	desenhaTextBox(GL_SELECT, glutGet(GLUT_WINDOW_WIDTH)-380, glutGet(GLUT_WINDOW_WIDTH)-260, 
		glutGet(GLUT_WINDOW_HEIGHT)-30, glutGet(GLUT_WINDOW_HEIGHT)-60, 4);
	desenhaTextBox(GL_SELECT, glutGet(GLUT_WINDOW_WIDTH)-230, glutGet(GLUT_WINDOW_WIDTH)-80, 
		glutGet(GLUT_WINDOW_HEIGHT)-30, glutGet(GLUT_WINDOW_HEIGHT)-60, 5);
	glPopMatrix();
	glFlush();
	hits = glRenderMode(GL_RENDER);
	processHits2(hits, selectBuf);
	Reshape2(glutGet(GLUT_WINDOW_WIDTH),glutGet(GLUT_WINDOW_HEIGHT));
	glutPostRedisplay();
}

void loginKey(unsigned char key, int x, int y)
{
	switch (key)
	{
	case 8:
		if(state==1 && username.size() > 0)
		{
			username.erase(username.size()-1);
		}
		else if(state==2 && pass.size() > 0)
		{
			pass.erase(pass.size()-1);
		}
		break;
	case 9:
		if(state==1)
		{
			state=2;
		}
		else if(state==2 || state==0)
		{
			state=1;
		}
		break;
	case 13:
		enterKey();
		break;
	case 27 :
		exit(0);
		break;
	default:
		if(state==1)
			if(username.size() < 20)
				username +=key;
		if(state==2)
			if(pass.size() < 20)
				pass += key;
		break;
	}
	glutPostRedisplay();
}

void specialLogin(int key, int x, int y)
{
	switch(key){
	case GLUT_KEY_UP :
		if(state==2){
			state=1;
		}
		break;
	case GLUT_KEY_DOWN :
		if(state==0){
			state=1;
		}
		else if(state==1){
			state=2;
		}
		break;
	}
}

void main(int argc, char **argv)
{
	alutInit (&argc, argv);
	InitAudio();
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	glutInitWindowSize(width, height);  
	glutCreateWindow("Graphs4Social");
	myInit();
	createTextures(modelo.texID);
	glutReshapeFunc(myReshape);
	glutDisplayFunc(display);

	glutTimerFunc(estado.timer,Timer,0);
	glutKeyboardFunc(keyboard);
	glutKeyboardUpFunc(keyboardUp);
	glutSpecialFunc(Special);
	glutSpecialUpFunc(SpecialKeyUp);
	glutMouseFunc(mouse);
	glutPassiveMotionFunc(mouseToolTip);
	imprime_ajuda();

	// criar a sub window topSubwindow
	estado.navigateSubwindow=glutCreateSubWindow(1, 10, height-200, 200, 200);
	myInit();
	glutReshapeFunc(redisplayTopSubwindow);
	glutDisplayFunc(displayTopSubwindow);
	glutKeyboardFunc(keyboard);
	glutKeyboardUpFunc(keyboardUp);
	glutSpecialFunc(Special);
	glutSpecialUpFunc(SpecialKeyUp);
	glutMouseFunc(mouse);
	createTextures(modelo.texID);
	glutMainLoop();
}

/*
void main(int argc, char **argv)
{
alutInit(&argc,argv);
glutInit(&argc, argv);
glutInitWindowPosition(width/2.0, 0);
glutInitWindowSize(width,height);
glutInitDisplayMode(GLUT_DOUBLE| GLUT_RGB);
if (glutCreateWindow("Graphs4Social") == GL_FALSE)
exit(1);

glutTimerFunc(estado.timer,TimerLogin,0);
glutMouseFunc(escolheTextbox);
glutReshapeFunc(Reshape2);
glutDisplayFunc(Draw);
glutKeyboardFunc(loginKey);
glutSpecialFunc(specialLogin);
myInit();
estado.barWindow=glutCreateSubWindow(1, 10, height-200, width, 100);
glutTimerFunc(estado.timer,TimerLogin,0);
glutMouseFunc(escolheTextbox);
glutReshapeFunc(Reshape2);
glutDisplayFunc(drawBar);
glutMainLoop();
}*/