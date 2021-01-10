// written by Souza G A in 02/10/2020
//------------------------------------ INCLUDES ------------------------------------//
#include <stdio.h>
#include <stdlib.h>
#include "main.h"
//------------------------------------- MACROS --------------------------------------//

//-------------------------------- STRUCTS AND VARS ---------------------------------//
char * problem;
char * header;
char * init;
char * goal;

//------------------------------------ FUNCTIONS ------------------------------------//

inline void globalInit(char ** problem,char ** header,char ** init,char ** goal)
{
	* problem = malloc(PROBLEMSIZE);
	* header = malloc(COMPONENTSIZE);
	* init = malloc(COMPONENTSIZE);
	* goal = malloc(COMPONENTSIZE);
}

int main(int argc, char *argv[ ])
{
	if(argc !=2)
	{
		fprintf(stderr, "Please use only one argument\n");
		exit(EXIT_FAILURE);
	}
	//
	char * prebuiltpath = malloc(TEXTSIZE);
	snprintf(prebuiltpath, TEXTSIZE, "%s", "../prebuilt/");
	populateBuild(prebuiltpath);
	//
	char * domainpath = malloc(TEXTSIZE);
	snprintf(domainpath, TEXTSIZE, "%s", "../domain/");
	readEnvironment(domainpath);
	//
	globalInit(&problem,&header,&init,&goal);
	populateELEMENTS();
	header = composeHeader(header);
	goal = composeGoal(goal);
	init = composeInit(init);
	problem = composeProblem(header,init,goal);
	//snprintf(problem, PROBLEMSIZE, "%s", "yeet\n");
	generatePDDL(argv[1], problem);
	return 0;
}

