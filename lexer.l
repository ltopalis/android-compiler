%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "lexer.h"

    void token_print(int token_id);
%}

%option noyywrap
%option yylineno

%%

"<RelativeLayout"       { token_print(T_RELATIVE_LAYOUT_S);     return T_RELATIVE_LAYOUT_S;     }
"<ImageView"            { token_print(T_IMAGE_VIEW_S);          return T_IMAGE_VIEW_S;          }
"<Button"               { token_print(T_BUTTON_S);              return T_BUTTON_S;              }
"<ProgressBar"          { token_print(T_PROGRESS_BAR_S);        return T_PROGRESS_BAR_S;        }
"<TextView"             { token_print(T_TEXT_VIEW_S);           return T_TEXT_VIEW_S;           }
"<RadioButton"          { token_print(T_RADIO_BUTTON_S);        return T_RADIO_BUTTON_S;        }
"</RelativeLayout"      { token_print(T_RELATIVE_LAYOUT_F);     return T_RELATIVE_LAYOUT_F;     }
"</LinearLayout"        { token_print(T_LINEAR_LAYOUT_F);       return T_LINEAR_LAYOUT_F;       }
"</RadioGroup"          { token_print(T_RADIO_GROUP_F);         return T_RADIO_GROUP_F;         }
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
[[:digit:]]+            { token_print(T_NUMBER);                return T_NUMBER;                }
[[:alpha:][:digit:]]+   { token_print(T_ALPHARITHMETIC);        return T_ALPHARITHMETIC;        }

"/>"                    { token_print(T_END_ONE_LINE_ELEM);     return T_END_ONE_LINE_ELEM;     }
">"                     { token_print(T_END_MANY_LINES_ELEM);   return T_END_MANY_LINES_ELEM;   }
"<!--"                  { token_print(T_START_COMMENT);         return T_START_COMMENT;         }
"-->"                   { token_print(T_END_COMMENT);           return T_END_COMMENT;           }
":"                     { token_print(T_SEMICOLON);             return T_SEMICOLON;             }
"="                     { token_print(T_EQUAL);                 return T_EQUAL;                 }
"\""                    { token_print(T_QUOTATION);             return T_QUOTATION;             }
"--"                    { token_print(T_DOUBLE_MINUS);          return T_DOUBLE_MINUS;          }
"_"                     { token_print(T_UNDERSCORE);            return T_UNDERSCORE;            }
<<EOF>>                 {                                       return T_EOF;                   }
[ \t\n]+                {                         /* ignore whitespaces */                      }
[^--]                   { token_print(T_SYMBOL);                return T_SYMBOL;                }
.                       { printf("Unrecognized symbol \'%s\'\n", yytext);                       }

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