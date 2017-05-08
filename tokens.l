%{
#include "y.tab.h"
%}
%%


"print"                {return print;}
"exit"                 {return exit_command;}
"se"    {return tokenIf;}
"entao"    {return tokenThen;}
"senao"    {return tokenElse;}
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
[-+=;]           	   {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

