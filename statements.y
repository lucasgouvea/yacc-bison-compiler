%{
void yyerror (char *s);
#include <stdio.h>    
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void updateSymbolValConditional(int condition, char symbol, int val);
void whileLoop(char id, int token, int condition, int op, int exp);
int switchop(char a, int op, int b);

int EQStatement(char symbol, int val);
int GEStatement(char symbol, int val);
int LEStatement(char symbol, int val);
int NEStatement(char symbol, int val);
int GStatement(char symbol, int val);
int LStatement(char symbol, int val);


%}

%union {int num; char id; char* str;}        
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%token <str> word 


%token tokenIf tokenThen tokenLE tokenGE tokenEQ tokenNE tokenOR tokenAND tokenElse tokenG tokenL tokenWhile tokenDo
%right '=' UMINUS
%left tokenG tokenL tokenLE tokenGE tokenEQ tokenNE tokenAND tokenOR '+''-' '*''/' '!' '<' '>' '%'


%type <num> line exp term
%type <id> assignment
%type <num> conditions
%type <num> op
%type <num> relationalToken
%%


line    : assignment ';'		{printf("\n Atribuicao  \n");}
        | conditional ';'       {printf("\n Condicional 'if' \n");}
        | whileloop ';'         {printf("\n Laco de repeticao 'while' \n");}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Saida : %d\n", $2);}
		| print word ';'        {printf("Saida : %s\n", $2);}
		| line assignment ';'	{printf("\n Atribuicao \n");}
		| line whileloop ';'    {printf("\n Laco de repetico 'while' \n");}
		| line conditional ';'	{printf("\n Condicional \n");}
		| line print exp ';'	{printf("Saida : %d\n", $3);}
		| line print word ';'   {printf("Saida : %s\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}

        ;

assignment : identifier '=' exp  { updateSymbolVal($1,$3);}
           ;
            
exp    	: term                           {$$ = $1;}
       	| exp '+' term                   {$$ = $1 + $3;}
       	| exp '-' term                   {$$ = $1 - $3;}
        | exp '*' term                   {$$ = $1 * $3;}
        | exp '/' term                   {$$ = $1 / $3;}
       	| exp '^' term                   {$$ = $1 ^ $3;}
       	| exp '%' term                   {$$ = $1 % $3;}
       	;
       	
term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
        ;

conditional : tokenIf conditions tokenThen identifier '=' exp     { updateSymbolValConditional($2,$4,$6); } 
            ;

whileloop   : tokenWhile identifier relationalToken exp tokenDo identifier '=' identifier op term    { whileLoop($2,$3,$4,$9,$10); }

            ;

relationalToken :     tokenEQ     {$$ = 1;} 
                    | tokenLE     {$$ = 2;}
                    | tokenGE     {$$ = 3;}
                    | tokenNE     {$$ = 4;}
                    | tokenG      {$$ = 5;}
                    | tokenL      {$$ = 6;}
                ;       

op :  '+'  {$$ = 1;} 
    | '-'  {$$ = 2;} 
    | '*'  {$$ = 3;}
    | '/'  {$$ = 4;}
    ;

conditions : 

          identifier tokenEQ exp      {$$ = EQStatement($1,$3);}  
       	| identifier tokenLE exp      {$$ = LEStatement($1,$3);}
       	| identifier tokenGE exp      {$$ = GEStatement($1,$3);}
       	| identifier tokenNE exp      {$$ = NEStatement($1,$3);}
        | identifier tokenG exp       {$$ = NEStatement($1,$3);}
        | identifier tokenL exp       {$$ = NEStatement($1,$3);}
        ;


    
        
%%                    


void whileLoop(char id, int token, int condition, int op, int exp)
{
    int idvalue = symbolVal(id);
    int aux;
    switch(token){
        //==
        case 1 :
            while(idvalue == condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
            }
        //<=
        case 2 :
            while(idvalue <= condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
                
            }            
        //>=
        case 3 :
            while(idvalue >= condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
            }     
        //!=
        case 4 :
            while(idvalue != condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
            } 
        //>
        case 5 :
            while(idvalue > condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
            } 
        //<
        case 6 :
            while(idvalue < condition)
            {   
                aux = switchop(id, op, exp);
                updateSymbolVal(id, aux);
                idvalue = symbolVal(id);
            }
            
    }
}

//pra nao ficar switch dentro de outro switch
int switchop(char a, int op, int b)
{
    int idvalue = symbolVal(a);
    switch(op){
        //+
        case 1 :  return idvalue + b;
        //-
        case 2 :  return idvalue - b;
        //*
        case 3 :  return idvalue * b;
        ///
        case 4 :  return idvalue / b;
    }
}


int EQStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket==val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int LEStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket<=val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int GEStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket>=val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int NEStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket!=val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int GStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket>val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int LStatement(char symbol, int val)
{

    int bucket = symbolVal(symbol);
    if(bucket<val){
        return 1;
    }
    else
    {
        return 0;
    }
    
}

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

void updateSymbolValConditional(int condition, char symbol, int val)
{   

    if(condition==1)
    {
        int bucket = computeSymbolIndex(symbol);
        symbols[bucket] = val;
    }
    else
    {
        printf("falso!");
    }
    
}


int main (void) {

	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}
    {printf("\n Iniciando compilador ! \n");}
	return yyparse ( );
}

void yyerror (char *s) {  fprintf (stderr, "%s\n", s); } 

