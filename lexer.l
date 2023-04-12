%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"

    int line = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
WHITESPACES [ \t\n\r]

%%

{DIGIT}+                                                        { yylval = atoi(yytext); return INTEGER; }
{LETTER}+                                                       { yylval = yytext; return WORD; }
{WHITESPACES}+                                                  { /* ignore whitespaces */ }
\b{LETTER}+\:{LETTER}+\=\"{LETTER}+\_{LETTER}+\"\b |
\b{LETTER}+\:{LETTER}+\=\"{DIGIT}+\"\b | 
\b{LETTER}+\:{LETTER}+\_{LETTER}+\=\"{DIGIT}+\"\b |
\b{LETTER}+\:{LETTER}+\_{LETTER}+\=\"{LETTER}+\_{LETTER}+\"\b   { yylval = yytext; return ATTRIBUTE; }
%{<!\-\-[LETTER|WHITESPACES|DIGIT]*\-\->%}                      { return COMMENTS; }
.                                                               { return ERROR; }

%%

int main(int argc, char** argv) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}

void yyerror(const char* msg) {
    fprintf(stderr, "Error on line %d: %s\n", line + 1, msg);
    exit(1);
}