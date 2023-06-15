%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    // #include "lexer.h"
    #include "syntax.tab.h"

    char msg[256];
    int errorCounter = 0;

    void token_print(int token_id);
    void yyerror(const char* error);
    void red();
    void reset();
%}

%x COMMENTS
%x ELEMENTS
%x STRING

%option noyywrap
%option yylineno

DIGIT           [0-9]
NUMBER          [1-9][0-9]*|0
LETTER          [a-zA-Z]
ALTHANUMERIC    {DIGIT}|{LETTER}
ALTHANUMERIC_   {DIGIT}|{LETTER}|_
TEXT            [^\"]

%%

"<!--"[^-]                          { BEGIN(COMMENTS);                                                                                          						}
<COMMENTS>[^-]"-->"                 { BEGIN(INITIAL);                                                                                           						}
<COMMENTS>[^-]--[^->]               { yyerror("Comments should not contain --");                                                                						}
<COMMENTS>[ \t\n]+                  {                         /* ignore whitespaces */                                                          						}
<COMMENTS><<EOF>>                   { yyerror("EOF without -->"); return T_EOF;                                                                  						}
<COMMENTS>.                         {                   /* ignore the text inside comments */                                                   						}

"<"[ \t\n]*                         { BEGIN(ELEMENTS);                                                                                          						}
<ELEMENTS>"LinearLayout"            { BEGIN(INITIAL); token_print(T_LINEAR_LAYOUT_S);                       return T_LINEAR_LAYOUT_S;           						}
<ELEMENTS>"RelativeLayout"          { BEGIN(INITIAL); token_print(T_RELATIVE_LAYOUT_S);                     return T_RELATIVE_LAYOUT_S;         						}
<ELEMENTS>"ImageView"               { BEGIN(INITIAL); token_print(T_IMAGE_VIEW_S);                          return T_IMAGE_VIEW_S;              						}
<ELEMENTS>"Button"                  { BEGIN(INITIAL); token_print(T_BUTTON_S);                              return T_BUTTON_S;                  						}
<ELEMENTS>"ProgressBar"             { BEGIN(INITIAL); token_print(T_PROGRESS_BAR_S);                        return T_PROGRESS_BAR_S;            						}
<ELEMENTS>"TextView"                { BEGIN(INITIAL); token_print(T_TEXT_VIEW_S);                           return T_TEXT_VIEW_S;               						}
<ELEMENTS>"RadioGroup"              { BEGIN(INITIAL); token_print(T_RADIO_GROUP_S);                         return T_RADIO_GROUP_S;             						}
<ELEMENTS>"RadioButton"             { BEGIN(INITIAL); token_print(T_RADIO_BUTTON_S);                        return T_RADIO_BUTTON_S;            						}
<ELEMENTS>"/RelativeLayout"         { BEGIN(INITIAL); token_print(T_RELATIVE_LAYOUT_F);                     return T_RELATIVE_LAYOUT_F;         						}
<ELEMENTS>"/LinearLayout"           { BEGIN(INITIAL); token_print(T_LINEAR_LAYOUT_F);                       return T_LINEAR_LAYOUT_F;           						}
<ELEMENTS>"/RadioGroup"             { BEGIN(INITIAL); token_print(T_RADIO_GROUP_F);                         return T_RADIO_GROUP_F;             						}
<ELEMENTS>{ALTHANUMERIC_}+          { BEGIN(INITIAL); sprintf(msg, "Unrecognised token \'%s\'", yytext);    yyerror(msg);                       						}
<ELEMENTS>[ \t\n]+                  { BEGIN(INITIAL);                                                                                           						}
<ELEMENTS><<EOF>>                   { yyerror("too soon EOF "); return T_EOF;                                                                  					    	}
<ELEMENTS>.                         { BEGIN(INITIAL); sprintf(msg, "Unrecognised token \'%s\'", yytext);    yyerror(msg);                       						}    

\"                                  { BEGIN(STRING);                                                                                            						}
<STRING>\"                          { BEGIN(INITIAL);                                                                                           						}
<STRING>"wrap_content\""            { BEGIN(INITIAL); token_print(T_LAYOUT_VALUES);                         return T_LAYOUT_VALUES;             						}
<STRING>"match_parent\""            { BEGIN(INITIAL); token_print(T_LAYOUT_VALUES);                         return T_LAYOUT_VALUES;             						}
<STRING>[-]{DIGIT}+\"               { BEGIN(INITIAL); yyerror("Negative Number");                                                               						}
<STRING>([+]?){NUMBER}\"            { BEGIN(INITIAL); yytext[strlen(yytext)-1] = '\0';  yylval.intValue=atoi(yytext); return T_NUMBER;          						}
<STRING>([+]?){DIGIT}+\"            { BEGIN(INITIAL); yyerror("Numbers should be >0 and have no zeros in front");                               						}
<STRING>{ALTHANUMERIC}+\"           { BEGIN(INITIAL); token_print(T_ALPHANUMERIC);      yylval.strValue=strdup(yytext);                       return T_ALPHANUMERIC;	}
<STRING>{ALTHANUMERIC_}+\"          { BEGIN(INITIAL); token_print(T_ALPHANUMERIC_);     yylval.strValue=strdup(yytext);                       return T_ALPHANUMERIC_;   }
<STRING>{TEXT}+\"                   { BEGIN(INITIAL); token_print(T_VTEXT);                                 return T_VTEXT;                     						}
<STRING><<EOF>>                     { yyerror("EOF without \""); return T_EOF;                                                                  						}                 
<STRING>[ \n\t]                     {                         /* ignore whitespaces */                                                          						}
<STRING>.                           { yyerror("DEFAULT");                                                                                       						}  

"id"                                { token_print(T_ID);                                                    return T_ID;                        						}
"text"                              { token_print(T_TEXT);                                                  return T_TEXT;                      						}
"src"                               { token_print(T_SRC);                                                   return T_SRC;                       						}
"padding"                           { token_print(T_PADDING);                                               return T_PADDING;                   						}
"text_color"                        { token_print(T_TEXT_COLOR);                                            return T_TEXT_COLOR;                						}
"checked_button"                    { token_print(T_CHECKED_BUTTON);                                        return T_CHECKED_BUTTON;            						}
"max"                               { token_print(T_MAX);                                                   return T_MAX;                       						}
"progress"                          { token_print(T_PROGRESS);                                              return T_PROGRESS;                  						}
"android"                           { token_print(T_ANDROID);                                               return T_ANDROID;                   						}
"layout_height"                     { token_print(T_LAYOUT_HEIGHT);                                         return T_LAYOUT_HEIGHT;             						}
"layout_width"                      { token_print(T_LAYOUT_WIDTH);                                          return T_LAYOUT_WIDTH;              						}
"orientation"                       { token_print(T_ORIENTATION);                                           return T_ORIENTATION;               						}
"max_children"                      { token_print(T_MAX_CHILDREN);                                          return T_MAX_CHILDREN;              						}
{ALTHANUMERIC_}+                    { sprintf(msg, "Unrecognised token \'%s\'", yytext);                    yyerror(msg);                       						}

"/>"                                { token_print(T_END_ONE_LINE_ELEM);                                     return T_END_ONE_LINE_ELEM;         						}
">"                                 { token_print(T_END_MANY_LINES_ELEM);                                   return T_END_MANY_LINES_ELEM;       						}
":"                                 { token_print(T_SEMICOLON);                                             return T_SEMICOLON;                 						}
"="                                 { token_print(T_EQUAL);                                                 return T_EQUAL;                     						}
<<EOF>>                             {                                                                       return T_EOF;                       						}
[ \t\n]+                            {                         /* ignore whitespaces */                                                          						}
.                                   { sprintf(msg, "Unrecognised token \'%s\'", yytext);                    yyerror(msg);                       						}

%%

/*
int main(int argc, char* argv[])
{
    int token;
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if(!yyin){
            perror("Error opening file");
            return -1;
        }
    }
    else{
        red();
        fprintf(stderr, "Error opening file: Please pass a file\n");
        reset();
        return -1;
    }

    do{
        token=yylex();
    }while(token != T_EOF);

    fclose(yyin);
    yyterminate();
}
*/

void token_print(int token_id)
{
    if(!DEBUG)
        return;

    printf("Found token \'%s\' (%d) at line %d\n", yytext, token_id, yylineno + 1);
}

void yyerror(const char* msg){
    errorCounter++;
    red();
    fprintf(stderr, "ERROR at line %d: ", yylineno + 1);
    reset();
    fprintf(stderr, "%s\n", msg);
}

void red() {
    fprintf(stderr, "\033[1;31m");
}

void reset () {
    fprintf(stderr, "\033[0m");
}