%{
#include "y.tab.h"
%}
%%


"imprima"                {return print;}
"sair"                 {return exit_command;}
"se"    {return tokenIf;}
"entao"    {return tokenThen;}
"senao"    {return tokenElse;}
"enquanto" {return tokenWhile;}
"faca"  {return tokenDo;}
">="    {return tokenGE;}
"<="    {return tokenLE;}
">"    {return tokenG;}
"<"    {return tokenL;}
"=="    {return tokenEQ;}
"!="    {return tokenNE;}
"||"    {return tokenOR;}
"&&"    {return tokenAND;}
[a-zA-Z]               {yylval.id = yytext[0]; return identifier;}
[a-zA-Z]+              {yylval.str = yytext; return word;}
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
[-+=;*/^%]           	   {return yytext[0];}
.                      {ECHO; yyerror ("token nao reconhecido");}

%%
int yywrap (void) {return 1;}

