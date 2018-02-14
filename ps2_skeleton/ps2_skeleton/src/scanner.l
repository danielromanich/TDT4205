%{
#include <vslc.h>
%}
%option noyywrap
%option array
%option yylineno

whitespace  [\ \t\n\r\v]
digit   [0-9]
letter  [A-Za-z]
comment \/\/[^\n]*\n
string \".*\"

%%

BEGIN                           { return OPENBLOCK; }
END                             { return CLOSEBLOCK; }
RETURN                          { return RETURN; }
PRINT                           { return PRINT; }
CONTINUE                        { return CONTINUE; }
IF                              { return IF; }
THEN                            { return THEN; }
ELSE                            { return ELSE; }
WHILE                           { return WHILE; }
DO                              { return DO; }
VAR                             { return VAR; }
FUNC                            { return FUNC; }

'>>'                            { return RSHIFT; }
'<<'                            { return LSHIFT; }
'='                             { return '='; }
'+'                             { return '+'; }
'-'                             { return '-'; }
'*'                             { return '*'; }
'\/'                             { return '/'; }
'<'                             { return '<'; }
'>'                             { return '>'; }
'~'                             { return '~'; }
'&'                             { return '&'; }
'^'                             { return '^'; }
'\|'                             { return '|'; }
':='                            { return ASSIGN; }

{whitespace}+                   {  }
{comment}                       {  }
{digit}+                        { return NUMBER; }
{string}                        { return STRING; }
{letter}({letter}|{digit})*     { return IDENTIFIER; }

.                               { return yytext[0]; }
%%
