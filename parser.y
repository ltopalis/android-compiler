%{
    #include <stdio.h>
    #include <stdlib.h>
%}

%token INTEGER
%token WORD
%token VALUE

%%

input: /* empty */
    | input line
    ;

line: expr '\n'      { printf("%d\n", $1); }
    ;

expr: INTEGER         { $$ = $1; }
    ;

%%

int main()
{
    yyparse();
    return 0;
}

int yyerror(const char *msg)
{
    printf("Error: %s\n", msg);
    return 1;
}
