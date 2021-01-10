//------------------------------------ INCLUDES ------------------------------------//
#include "main.h"
//------------------------------------- MACROS --------------------------------------//

//-------------------------------- STRUCTS AND VARS ---------------------------------//

entity agent[];   // hold arm PRD
int Agentnum = 0;
entity passive[]; // hold block PRD
int Passivenum = 0;
// info to construct PDDL
PSS pss;
ACTOR arm;
OBJECT block;
RELATIONS domain;
STACK stack[];
int stackcounter = 0;
//------------------------------------ FUNCTIONS ------------------------------------//
// SPAGGHETI MARIO

void populateBuild(char * dirpath)
{
    DIR * prebuildDir;
    struct dirent * entry;
    prebuildDir = opendir(dirpath);
    char fileList[MAXFILENUM][ADDSIZE];
    int nfiles = 0;
    while((entry=readdir(prebuildDir)))
    {
        if(entry->d_name[0] == '.') continue;
        snprintf( fileList[nfiles], ADDSIZE, "%s", entry->d_name);
        //printf("fileList[%d] = %s\n",nfiles,fileList[nfiles]);
        ++nfiles;
    }
    closedir(prebuildDir);
    //
    while(nfiles > 0)
    {
        char * comparative[2] = {"arm","PSS"};
        --nfiles;
        if(strstr(fileList[nfiles],comparative[0]) != NULL)
        {
            char * filepath = malloc(ADDSIZE);
            snprintf(filepath, ADDSIZE, "%s%s", dirpath, fileList[nfiles]);
            getActorPredicates(filepath);
            continue;
        }
        else if(strstr(fileList[nfiles],comparative[1]) != NULL)
        {
            char * filepath = malloc(ADDSIZE);
            snprintf(filepath, ADDSIZE, "%s%s", dirpath, fileList[nfiles]);
            getPositionPredicates(filepath);
        }
    }
}

void getActorPredicates(char * filepath)
{
    //fprintf(stdout, "%s|%s->%d\n", __FILE__, __func__, __LINE__);
    FILE * armFile;
    armFile = fopen(filepath, "r");
    char aux[ARMSIZE];
    int ref = 0;
    char * comparative[9] = {":basic_info","ID(","}",":current","position(","}",":objective-0","position(","}"}; // working in triple-tuple
    while(fgets(aux,ARMSIZE,armFile) != NULL)
    {
        if(strstr(aux,comparative[ref]) != NULL)
        {
            //printf("%d,%s",ref,aux);
            ++ref;
        }
        if(ref == 2)
        {
            str_replace(aux,comparative[1],"");
            str_replace(aux,")","");
            snprintf(agent[Agentnum].id, ARMSIZE, "%s", aux);
        }
        if(ref == 5)
        {
            str_replace(aux,comparative[4],"");
            str_replace(aux,")","");
            snprintf(agent[Agentnum].current, ARMSIZE, "%s", aux);
        }
        if(ref == 8)
        {
            str_replace(aux,comparative[7],"");
            str_replace(aux,")","");
            snprintf(agent[Agentnum].objective, ARMSIZE, "%s", aux);
        }
    }
    fclose(armFile);
    //fprintf(stdout, "Agentnum:\t%d\nagent.id:%s\nagent.current:%s\nagent.objective:%s\n", Agentnum, agent[Agentnum].id, agent[Agentnum].current, agent[Agentnum].objective);
    ++Agentnum;
}

void getPositionPredicates(char * filepath)
{
    //fprintf(stdout, "%s|%s->%d\n", __FILE__, __func__, __LINE__);
    FILE * positionFile;
    positionFile = fopen(filepath, "r");
    char aux[PREDICATESIZE];
    int ref = 0;
    char * comparative[3] = {"(:objects",")","(:init"};
    strncat(pss.objects,"\t",PREDICATESIZE);
    while(fgets(aux,PREDICATESIZE,positionFile) != NULL)
    {
        //fprintf(stdout, "%s", aux);
        if(ref < 3 && strstr(aux,comparative[ref]) != NULL)
        {
            ++ref;
            continue;
        }
        else if(ref == 3 && aux[0] == ')') break;
        if(ref == 1) // inside first delimiter pair
        {
            aux[strlen(aux)-1] = ' ';
            strncat(pss.objects,aux,PREDICATESIZE);
        }
        else if(ref == 3) // inside second delimiter pair
        {
            strncat(pss.init,"\t",PREDICATESIZE);
            strncat(pss.init,aux,PREDICATESIZE);
        }
    }
    strncat(pss.init, "\n", PREDICATESIZE);
    strncat(pss.objects,"- place\n\n", PREDICATESIZE);
    fclose(positionFile);
    //fprintf(stdout, "REF:\t%d\nPSS.objects:\n%s\nPSS.init:\n%s\n", ref, pss.objects, pss.init);
}

void readEnvironment(char * dirpath)
{
    DIR * domain;
    struct dirent * entry;
    domain = opendir(dirpath);
    char fileList[MAXFILENUM][ADDSIZE];
    int nfiles = 0;
    while((entry=readdir(domain)))
    {
        if(entry->d_name[0] == '.') continue;
        snprintf( fileList[nfiles], ADDSIZE, "%s", entry->d_name);
        //printf("fileList[%d] = %s\n",nfiles,fileList[nfiles]);
        ++nfiles;
    }
    closedir(domain);
    //
    while(nfiles > 0)
    {
        char * comparative = {".in"};
        --nfiles;
        if(strstr(fileList[nfiles],comparative) != NULL)
        {
            char * filepath = malloc(ADDSIZE);
            snprintf(filepath, ADDSIZE, "%s%s", dirpath, fileList[nfiles]);
            getBlockPredicates(filepath);
            continue;
        }
    }
}

void getBlockPredicates(char * filepath)
{
    //fprintf(stdout, "%s|%s->%d\n", __FILE__, __func__, __LINE__);
    FILE * blockFile;
    blockFile = fopen(filepath, "r");
    char aux[BLOCKSIZE];
    int ref = 0;
    char * comparative[9] = {":basic_info","ID(","}",":current","position(","}",":objective-0","position(","}"}; // working in triple-tuple
    while(fgets(aux,BLOCKSIZE,blockFile) != NULL)
    {
        if(strstr(aux,comparative[ref]) != NULL)
        {
            //printf("%d,%s",ref,aux);
            ++ref;
        }
        if(ref == 2)
        {
            str_replace(aux,comparative[1],"");
            str_replace(aux,")","");
            snprintf(passive[Passivenum].id,BLOCKSIZE, "%s", aux);
        }
        if(ref == 5)
        {
            str_replace(aux,comparative[4],"");
            str_replace(aux,")","");
            snprintf(passive[Passivenum].current,BLOCKSIZE, "%s", aux);
        }
        if(ref == 8)
        {
            str_replace(aux,comparative[7],"");
            str_replace(aux,")","");
            snprintf(passive[Passivenum].objective,BLOCKSIZE, "%s", aux);
        }
    }
    fclose(blockFile);
    //fprintf(stdout, "Passivenum:\t%d\npassive.id:%s\npassive.current:%s\npassive.objective:%s\n", Passivenum, passive[Passivenum].id, passive[Passivenum].current, passive[Passivenum].objective);
    ++Passivenum;
}

//**************************************************************************************//

void populateELEMENTS(void)
{
    populateELEMENTS_OBJECTS();
    populateELEMENTS_GOAL();
    populateELEMENTS_INIT();
}

void populateELEMENTS_OBJECTS(void)
{
    int i;
    //printf("Agentnum:%d\n",Agentnum);
    snprintf(arm.objects, PREDICATESIZE, " "); // clean
    for(i=0;i<Agentnum;++i)
    {
        //fprintf(stdout, "%s", agent[i].id);
        strncat(arm.objects, agent[i].id, PREDICATESIZE);
    }
    str_replace(arm.objects, "\n", " ");
    strncat(arm.objects, " - arm\n\n", PREDICATESIZE);
    //fprintf(stdout, "arm.objects:%s\n", arm.objects);
    //
    //printf("Passivenum:%d\n",Passivenum);
    snprintf(block.objects, PREDICATESIZE, " "); // clean
    for(i=0;i<Passivenum;++i)
    {
        //fprintf(stdout, "%s", passive[i].id);
        strncat(block.objects, passive[i].id, PREDICATESIZE);
    }
    str_replace(block.objects, ",\n", " ");
    strncat(block.objects, " - block\n", PREDICATESIZE);
    //fprintf(stdout, "block.objects:%s\n", block.objects);
}

void populateELEMENTS_GOAL(void)
{
    int i;
    char CONCATAUX[PACKSIZE];
    //printf("Agentnum:%d\n",Agentnum);
    for(i=0;i<Agentnum;++i)
    {
        //fprintf(stdout, "%s", agent[i].objective);
        snprintf(CONCATAUX, PACKSIZE, "%s%s %s%s", "(holdarm ", agent[i].objective, agent[i].id, ") ");
        str_replace(CONCATAUX, "\n", " ");
        str_replace(CONCATAUX, "\t", " ");
        strncat(arm.goal, "\t", PREDICATESIZE);
        strncat(arm.goal, CONCATAUX, PREDICATESIZE);
        strncat(arm.goal, "\n", PREDICATESIZE);
    }
    strncat(arm.goal, "\n", PREDICATESIZE);
    //fprintf(stdout, "arm.goal:\n%s\n", arm.goal);
    char DELIMITERAUX[PACKSIZE];
    int j;
    for(i=0;i<Passivenum;++i)
    {
        //fprintf(stdout, "%s", agent[i].objective);
        // bug em passive[1].id -> solução grosseira (excluir a vírgula e tudo depois dela)
        for(j=0;j<strlen(passive[i].id);++j)
        {
            if(passive[i].id[j] == ',') break;
            DELIMITERAUX[j] = passive[i].id[j];
        }
        snprintf(passive[i].id, TEXTSIZE, "%s", DELIMITERAUX);
        snprintf(CONCATAUX, PACKSIZE, "%s%s %s%s", "(holdblock ", passive[i].objective, passive[i].id, ") ");
        str_replace(CONCATAUX, "\n", " ");
        str_replace(CONCATAUX, "\t", " ");
        strncat(block.goal, "\t", PREDICATESIZE);
        strncat(block.goal, CONCATAUX, PREDICATESIZE);
        strncat(block.goal, "\n", PREDICATESIZE);
    }
    
    //fprintf(stdout, "block.goal:\n%s\n", block.goal);
}

void populateELEMENTS_INIT(void) // shit hit the fan
{
    int i;
    char CONCATAUX[PACKSIZE];
    //printf("Agentnum:%d\n",Agentnum);
    snprintf(arm.init, PREDICATESIZE, ""); // clean
    for(i=0;i<Agentnum;++i)
    {
        //fprintf(stdout, "%s", agent[i].objective);
        snprintf(CONCATAUX, PACKSIZE, "%s%s %s%s", "(holdarm ", agent[i].current, agent[i].id, ") ");
        str_replace(CONCATAUX, "\n", " ");
        str_replace(CONCATAUX, "\t", " ");
        strncat(arm.init, "\t", PREDICATESIZE);
        strncat(arm.init, CONCATAUX, PREDICATESIZE);
        strncat(arm.init, "\n", PREDICATESIZE);
        //
        snprintf(CONCATAUX, PACKSIZE, "%s%s%s", "(freetopick ", agent[i].id, ")");
        str_replace(CONCATAUX, "\n", " ");
        str_replace(CONCATAUX, "\t", " ");
        strncat(arm.init, "\t", PREDICATESIZE);
        strncat(arm.init, CONCATAUX, PREDICATESIZE);
        strncat(arm.init, "\n", PREDICATESIZE);

    }
    strncat(arm.init, "\n", PREDICATESIZE);
    //fprintf(stdout, "arm.init:\n%s\n", arm.init);
    //
    snprintf(block.init, PREDICATESIZE, "");
    for(i=0;i<Passivenum;++i)
    {
        //fprintf(stdout, "%s", passive[i].current);
        snprintf(CONCATAUX, PACKSIZE, "%s%s %s%s", "(holdblock ", passive[i].current, passive[i].id, ") ");
        str_replace(CONCATAUX, ",", "");
        str_replace(CONCATAUX, "\n", " ");
        str_replace(CONCATAUX, "\t", " ");
        strncat(block.init, "\t", PREDICATESIZE);
        strncat(block.init, CONCATAUX, PREDICATESIZE);
        strncat(block.init, "\n", PREDICATESIZE);
    }
    strncat(block.init, "\n", PREDICATESIZE);
    //fprintf(stdout, "block.init:\n%s\n", block.init);
    // Brainy part
    int j,k;
    char GENAUX[PACKSIZE], COMPAUX[PACKSIZE];
    snprintf(domain.init, PREDICATESIZE, "");
    for(i=0;i<4;++i) // X
    {
        for(j=0;j<4;++j) // Y
        {
            snprintf(GENAUX, PACKSIZE,"place_%d_%d", i, (j+1));
            for(k=0;k<Passivenum;++k)
            {
                if(strstr(passive[k].current,GENAUX)!=NULL) // versão cara de strcmp(GENAUX,passive[i].current) == 0 mas mais robusta
                {
                    goto breakPlusContinue_1;
                }
            }
            snprintf(CONCATAUX, PACKSIZE, "%s%s%s", "(freetomoveblock ", GENAUX, ") ");
            strncat(domain.init, "\t", PREDICATESIZE);
            strncat(domain.init, CONCATAUX, PREDICATESIZE);
            strncat(domain.init, "\n", PREDICATESIZE);
            breakPlusContinue_1:
            continue;
        }
    }
    strncat(domain.init, "\n", PREDICATESIZE);
    //
    for(i=0;i<4;++i) // X
    {
        for(j=0;j<4;++j) // Y
        {
            snprintf(GENAUX, PACKSIZE,"place_%d_%d", i, (j+1));
            snprintf(COMPAUX, PACKSIZE,"place_%d_%d", i, (j+2));
            for(k=0;k<Passivenum;++k) // superior POS occupied?
            {
                if(strstr(passive[k].current,COMPAUX)!=NULL)
                {
                    snprintf(stack[stackcounter].topElement, TEXTSIZE, "%s", passive[k].id);
                    snprintf(stack[stackcounter].botPosition, TEXTSIZE, "%s", GENAUX);
                    //fprintf(stdout, "topElement:%s\nbotPosition:%s\n", stack[stackcounter].topElement, stack[stackcounter].botPosition);
                    ++stackcounter;
                    goto breakPlusContinue_2;
                }
            }
            snprintf(CONCATAUX, PACKSIZE, "%s%s%s", "(freetomove ", GENAUX, ") ");
            strncat(domain.init, "\t", PREDICATESIZE);
            strncat(domain.init, CONCATAUX, PREDICATESIZE);
            strncat(domain.init, "\n", PREDICATESIZE);
            breakPlusContinue_2:
            continue;
        }
    }
    strncat(domain.init, "\n", PREDICATESIZE);
    //
    for(i=0;i<4;++i) // X
    {
        for(j=0;j<4;++j) // Y
        {
            snprintf(GENAUX, PACKSIZE,"place_%d_%d", i, (j+1));
            for(k=0;k<Passivenum;++k)
            {
                if(strstr(agent[k].current,GENAUX)!=NULL)
                {
                    goto breakPlusContinue_3;
                }
            }
            snprintf(CONCATAUX, PACKSIZE, "%s%s%s", "(freetomovearm ", GENAUX, ") ");
            str_replace(CONCATAUX, "\n", " ");
            str_replace(CONCATAUX, "\t", " ");
            strncat(domain.init, "\t", PREDICATESIZE);
            strncat(domain.init, CONCATAUX, PREDICATESIZE);
            strncat(domain.init, "\n", PREDICATESIZE);
            breakPlusContinue_3:
            continue;
        }
    }
    strncat(domain.init, "\n", PREDICATESIZE);
    //fprintf(stdout, "domain.init:\n%s\n", domain.init);
    for(i=0;i<stackcounter;++i) // X
    {
        for(k=0;k<Passivenum;++k)
        {
            if(strstr(passive[k].current,stack[i].botPosition)!=NULL)
            {
                //fprintf(stdout, "passive: %s\nstack: %s\n", passive[k].current, stack[i].botPosition);
                snprintf(CONCATAUX, PACKSIZE, "%s%s %s%s", "(stackedblock ", stack[i].topElement, passive[k].id, ") ");
                str_replace(CONCATAUX, "\n", " ");
                str_replace(CONCATAUX, "\t", " ");
                strncat(domain.init, "\t", PREDICATESIZE);
                strncat(domain.init, CONCATAUX, PREDICATESIZE);
                strncat(domain.init, "\n", PREDICATESIZE);
            }
        }
    }
    //fprintf(stdout, "domain.init:\n%s\n", domain.init);
}

char * composeHeader(char * header)
{
    snprintf(header, COMPONENTSIZE, "%s%s%s%s%s", "(define (problem MultiActor)\n(:domain BlockWorld-Mecatronics)\n(:objects \n", pss.objects, arm.objects, block.objects, ")");
    //fprintf(stdout, "header:%s\n", header);
    return header;
}

char * composeGoal(char * goal)
{
    snprintf(goal, COMPONENTSIZE, "%s%s%s%s", "(:goal (and \n", arm.goal, block.goal, "\t)\n)\n)");
    //fprintf(stdout, "goal:%s\n", goal);
    return goal;
}

char * composeInit(char * init)
{
    snprintf(init, COMPONENTSIZE, "%s%s%s%s%s%s", "(:init \n", pss.init, arm.init, block.init, domain.init, ")\n");
    //fprintf(stdout, "init:%s\n", init);
    return init;
}

char * composeProblem(char * header, char * init, char * goal)
{
    char * prob = malloc(PROBLEMSIZE);
    snprintf(prob, PROBLEMSIZE, "%s\n%s\n%s", header, init, goal);
    return prob;
}

void generatePDDL(char * filename, char * problem)
{
    char * fullfilename = malloc(ADDSIZE);
    snprintf(fullfilename, ADDSIZE, "../output/%s.pddl", filename);
    //
    FILE * problemFile;
    problemFile = fopen(fullfilename, "w");
    fprintf(problemFile, "%s", problem);
    fclose(problemFile);
    //
    fprintf(stdout, "done\n");
}

//**************************************************************************************//

char * str_replace(char * text,char * rep, char * repw)
{ 
   int replen = strlen(rep),repwlen = strlen(repw),count;
   int i,j,l;
    for(i=0;i<strlen(text);i++){
        if(text[i] == rep[0]){
            count = 1;
            for(j=1;j<replen;j++){
                if(text[i+j] == rep[j]){
                    count++;
                }else{
                    break;
                }
            }
            if(count == replen){
                if(replen < repwlen){
                    for(l = strlen(text);l>i;l--){
                        text[l+repwlen-replen] = text[l];
                    }
                }
                if(replen > repwlen){
                    for(l=i+replen-repwlen;l<strlen(text);l++){
                        text[l-(replen-repwlen)] = text[l];
                    }
                    text[strlen(text)-(replen-repwlen)] = '\0';
                }
                for(l=0;l<repwlen;l++){
                    text[i+l] = repw[l];
                }
                if(replen != repwlen){
                    i+=repwlen-1;
                }
            }
        }
    }
    return text;
}