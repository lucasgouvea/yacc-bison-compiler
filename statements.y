%{
void yyerror (char *s);
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void updateSymbolValConditional(int condition, char symbol, int val);
int EQStatement(char symbol, int val);
int GEStatement(char symbol, int val);
int LEStatement(char symbol, int val);
int NEStatement(char symbol, int val);
int GStatement(char symbol, int val);
int LStatement(char symbol, int val);

%}

%union {int num; char id; char* str;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%token <str> word 


%token tokenIf tokenThen tokenLE tokenGE tokenEQ tokenNE tokenOR tokenAND tokenElse tokenG tokenL
%right '=' UMINUS
%right '^'
%left tokenG tokenL tokenLE tokenGE tokenEQ tokenNE tokenAND tokenOR '+''-' '*''/' '!' '<' '>' 


%type <num> line exp term
%type <id> assignment
%type <num> conditions

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
        | conditional ';'       {;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %d\n", $2);}
		| print word ';'        {printf("Printing %s\n", $2);}
		| line assignment ';'	{;}
		| line conditional ';'	{;}
		| line print exp ';'	{printf("Printing %d\n", $3);}
		| line print word ';'   {printf("Printing %s\n", $3);}
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
       	;
       	
term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
        ;

conditional : tokenIf conditions tokenThen identifier '=' exp     { updateSymbolValConditional($2,$4,$6); }        
            ;
                        
            
conditions : 

        identifier tokenEQ number        {$$ = EQStatement($1,$3);} 
       	| identifier tokenLE number      {$$ = LEStatement($1,$3);}
       	| identifier tokenGE number      {$$ = GEStatement($1,$3);}
       	| identifier tokenNE number      {$$ = NEStatement($1,$3);}
        | identifier tokenG number       {$$ = NEStatement($1,$3);}
        | identifier tokenL number       {$$ = NEStatement($1,$3);}
        ;


%%                     /* C code */




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

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
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
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

