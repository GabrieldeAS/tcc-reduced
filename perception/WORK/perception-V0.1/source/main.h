#ifndef PROCESS_H
#define PROCESS_H
//------------------------------------ INCLUDES ------------------------------------//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "identification.h"
//------------------------------------- MACROS --------------------------------------//

#define PROBLEMSIZE 60000
#define COMPONENTSIZE 20000
#define TEXTSIZE 50
#define ADDSIZE 70

//-------------------------------- STRUCTS AND VARS ---------------------------------//
extern char * problem;
extern char * header;
extern char * init;
extern char * goal;

//------------------------------------ FUNCTIONS ------------------------------------//
void globalInit(char ** problem,char ** header,char ** init,char ** goal);

#endif