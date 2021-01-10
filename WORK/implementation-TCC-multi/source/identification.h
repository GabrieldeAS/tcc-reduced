#ifndef IDENTIFICATION_H
#define IDENTIFICATION_H
#include <dirent.h>
#include "main.h"
//------------------------------------- MACROS --------------------------------------//

#define TEXTSIZE 100
#define MAXFILENUM 5
// description size for each element
#define PREDICATESIZE 10000
#define ARMSIZE 2000
#define BLOCKSIZE 2000
#define PACKSIZE 200
// domainsize
#define DOMAINSIZE 16 // 4.4

//-------------------------------- STRUCTS AND VARS ---------------------------------//

typedef struct obj {
    char id[TEXTSIZE];
    char current[TEXTSIZE];
    char objective[TEXTSIZE]; // suporte a um único objetivo por enquanto
} entity;

typedef struct arm{
    char objects[PREDICATESIZE];
    char init[PREDICATESIZE];
    char goal[PREDICATESIZE];
} ACTOR;

typedef struct block{
    char objects[PREDICATESIZE];
    char init[PREDICATESIZE];
    char goal[PREDICATESIZE];
} OBJECT;

typedef struct position{
    char objects[PREDICATESIZE];
    char init[PREDICATESIZE];
} PSS;

typedef struct stk{
    char topElement[TEXTSIZE*5];
    char botPosition[TEXTSIZE*5];
} STACK;

typedef struct domainInit{
    char init[PREDICATESIZE];
    //struct stack stack[DOMAINSIZE];
} RELATIONS;

extern entity agent[];
extern entity passive[];
extern ACTOR arm;
extern OBJECT block;
extern PSS pss;
extern RELATIONS domain;
extern STACK stack[];

//------------------------------------ FUNCTIONS ------------------------------------//
// ID functions
void initElements(void);
void readEnvironment(char * dirpath);
    void getBlockPredicates(char * filepath);
    //void parsePopulate(entity * currentObj);
void populateBuild(char * dirpath);
    void getActorPredicates(char * filepath);
    void getPositionPredicates(char * filepath);
char * str_replace(char * text,char * rep, char * repw);
// Conversion functions
void populateELEMENTS(void);
    void populateELEMENTS_OBJECTS(void);
    void populateELEMENTS_GOAL(void);
    void populateELEMENTS_INIT(void);
char * composeProblem(char * header, char * init, char * goal);
    char * composeHeader(char * header);
    char * composeGoal(char * goal);
    char * composeInit(char * init);
// cometi sacrilégio aqui (global sem entrada como parâmetro)
void generatePDDL(char * filename, char * problem);
#endif