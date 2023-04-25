%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "lexer.h"

    char value[255];

    void token_print(int token_id);
    void yyerror(const char* error);
    void red();
    void reset();
%}

%x COMMENTS
%x ATTRIBUTE
%x STRING

%option noyywrap
%option yylineno

DIGIT           [0-9]
LETTER          [a-zA-Z]
ALTHANUMERIC    {DIGIT}|{LETTER}
ALTHANUMERIC_   {DIGIT}|{LETTER}|_
TEXT            [^\"]

%%

"<!--"                  { BEGIN(COMMENTS);                                                      }
<COMMENTS>"-->"         { BEGIN(INITIAL);                                                       }
<COMMENTS>"--"          { yyerror("Invalid_Comment");                                           }
<COMMENTS>[ \t\n]+      {                         /* ignore whitespaces */                      }
<COMMENTS>.             {                   /* ignore the text inside comments */               }


"<"[ \t\n]*                       { BEGIN(ATTRIBUTE); strcpy(value, "<"); }
<ATTRIBUTE>"LinearLayout"         { BEGIN(INITIAL); token_print(T_LINEAR_LAYOUT_S);       return T_LINEAR_LAYOUT_S;       }
<ATTRIBUTE>"RelativeLayout"       { BEGIN(INITIAL); token_print(T_RELATIVE_LAYOUT_S);     return T_RELATIVE_LAYOUT_S;     }
<ATTRIBUTE>"ImageView"            { BEGIN(INITIAL); token_print(T_IMAGE_VIEW_S);          return T_IMAGE_VIEW_S;          }
<ATTRIBUTE>"Button"               { BEGIN(INITIAL); token_print(T_BUTTON_S);              return T_BUTTON_S;              }
<ATTRIBUTE>"ProgressBar"          { BEGIN(INITIAL); token_print(T_PROGRESS_BAR_S);        return T_PROGRESS_BAR_S;        }
<ATTRIBUTE>"TextView"             { BEGIN(INITIAL); token_print(T_TEXT_VIEW_S);           return T_TEXT_VIEW_S;           }
<ATTRIBUTE>"RadioGroup"           { BEGIN(INITIAL); token_print(T_RADIO_GROUP_S);         return T_RADIO_GROUP_S;         }
<ATTRIBUTE>"RadioButton"          { BEGIN(INITIAL); token_print(T_RADIO_BUTTON_S);        return T_RADIO_BUTTON_S;        }
<ATTRIBUTE>"/RelativeLayout"      { BEGIN(INITIAL); token_print(T_RELATIVE_LAYOUT_F);     return T_RELATIVE_LAYOUT_F;     }
<ATTRIBUTE>"/LinearLayout"        { BEGIN(INITIAL); token_print(T_LINEAR_LAYOUT_F);       return T_LINEAR_LAYOUT_F;       }
<ATTRIBUTE>"/RadioGroup"          { BEGIN(INITIAL); token_print(T_RADIO_GROUP_F);         return T_RADIO_GROUP_F;         }
<ATTRIBUTE>{ALTHANUMERIC_}+       { BEGIN(INITIAL); yyerror("DEFAULT"); }
<ATTRIBUTE>[ \t\n]+               { BEGIN(INITIAL); }
<ATTRIBUTE>.                      { BEGIN(INITIAL); yyerror("DEFAULT"); }

\"                                  { BEGIN(STRING); strcpy(value, "\"");         }
<STRING>\"                          { BEGIN(INITIAL); printf("END STRING\n"); }
<STRING>[-]{DIGIT}+\"               { BEGIN(INITIAL); yyerror("Negative Number"); }
<STRING>([+]?){DIGIT}+\"            { BEGIN(INITIAL); return T_NUMBER; }
<STRING>{ALTHANUMERIC}+\"           { BEGIN(INITIAL); printf("Found word: %s\n", yytext); return T_ALPHANUMERIC; }
<STRING>{ALTHANUMERIC_}+\"          { BEGIN(INITIAL); printf("Found word: %s\n", yytext); return T_ALPHANUMERIC; }
<STRING>{TEXT}+\"                   { BEGIN(INITIAL); printf("FOUND text: %s\n", yytext); return T_VTEXT;  }

<STRING><<EOF>>                 { yyerror("EOF without \""); return T_EOF; }
<STRING>.                       { yyerror("DEFAULT"); }                   

<STRING>[ \n\t]             { }

"id"                    { token_print(T_ID);                    return T_ID;                    }
"text"                  { token_print(T_TEXT);                  return T_TEXT;                  }
"src"                   { token_print(T_SRC);                   return T_SRC;                   }
"padding"               { token_print(T_PADDING);               return T_PADDING;               }
"text_color"            { token_print(T_TEXT_COLOR);            return T_TEXT_COLOR;            }
"checked_button"        { token_print(T_CHECKED_BUTTON);        return T_CHECKED_BUTTON;        }
"max"                   { token_print(T_MAX);                   return T_MAX;                   }
"progress"              { token_print(T_PROGRESS);              return T_PROGRESS;              }
"android"               { token_print(T_ANDROID);               return T_ANDROID;               }
"layout_height"         { token_print(T_LAYOUT_HEIGHT);         return T_LAYOUT_HEIGHT;         }
"layout_width"          { token_print(T_LAYOUT_WIDTH);          return T_LAYOUT_WIDTH;          }
"orientation"           { token_print(T_ORIENTATION);           return T_ORIENTATION;           }
{ALTHANUMERIC_}+        { yyerror("DEFAULT"); }

"/>"                    { token_print(T_END_ONE_LINE_ELEM);     return T_END_ONE_LINE_ELEM;     }
">"                     { token_print(T_END_MANY_LINES_ELEM);   return T_END_MANY_LINES_ELEM;   }
":"                     { token_print(T_SEMICOLON);             return T_SEMICOLON;             }
"="                     { token_print(T_EQUAL);                 return T_EQUAL;                 }

<<EOF>>                 {                                       return T_EOF;                   }
[ \t\n]+                {                         /* ignore whitespaces */                      }
.                       { yyerror("DEFAULT");                                                   }

%%

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

void token_print(int token_id)
{
    printf("Found token \'%s\' (%d) at line %d\n", yytext, token_id, yylineno);
}

void yyerror(const char* msg){
    
    red();
    if(!strcmp(msg, "Invalid_Comment"))
        fprintf(stderr, "Invalid comment format at line %d: Comments should not contain --\n", yylineno+1);
    else if(!strcmp(msg, "Negative Number"))
        fprintf(stderr, "Error at line %d: Only positive numbers\n", yylineno+1);
    else if(!strcmp(msg, "EOF without \""))
        fprintf(stderr, "Reached EOF without closing \" at line %d\n", yylineno+1);
    else
        fprintf(stderr, "Unrecognized token \'%s\' at line %d\n", yytext, yylineno+1);
    reset();

}

void red() {
    fprintf(stderr, "\033[1;31m");
}

void reset () {
    fprintf(stderr, "\033[0m");
}