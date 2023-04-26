%{
    #include <stdio.h>
    #include <stdlib.h>

    extern FILE *yyin;

    extern int yylex();
    extern void red();
    extern void reset();
    extern void yyerror(const char* error);
%}

%define parse.error verbose

%union {
    int     intValue;
    char *  strValue;
}

%token              T_EQUAL                     "="
%token              T_COMMENT                   "comment"
%token              T_SEMICOLON                 ":"
%token              T_END_ONE_LINE_ELEM         "/>"
%token              T_END_MANY_LINES_ELEM       ">"
%token              T_QUOTATION                 "quotation"

%token              T_PROGRESS_BAR_S            "<ProgressBar"
%token              T_TEXT_VIEW_S               "<TextView"
%token              T_RADIO_BUTTON_S            "<RadioButton"
%token              T_RELATIVE_LAYOUT_S         "<RelativeLayout"
%token              T_IMAGE_VIEW_S              "<ImageView"
%token              T_BUTTON_S                  "<Button"
%token              T_LINEAR_LAYOUT_F           "</LinearLayout"
%token              T_RELATIVE_LAYOUT_F         "</RelativeLayout"
%token              T_RADIO_GROUP_F             "</RadioButton"
%token              T_RADIO_GROUP_S             "<RadioGroup"
%token              T_LINEAR_LAYOUT_S           "<LinearLayout"

%token              T_ANDROID                   "android"  
%token              T_LAYOUT_HEIGHT             "layout_height"
%token              T_LAYOUT_WIDTH              "layout_width" 
%token              T_ORIENTATION               "orientation"
%token              T_ID                        "id"
%token              T_TEXT                      "text"
%token              T_SRC                       "src"
%token              T_PADDING                   "padding"
%token              T_TEXT_COLOR                "text_color"
%token              T_CHECKED_BUTTON            "checked_button"
%token              T_MAX                       "max"
%token              T_PROGRESS                  "progress"

%token <strValue>   T_ALPHANUMERIC              "alphanumeric"
%token <intValue>   T_NUMBER                    "number"
%token <strValue>   T_VTEXT                     "text as value"
%token <strValue>   T_ALPHANUMERIC_             "alphanumeric or _"

%token              T_EOF                       0

%%

program:                        radioButton program
                                | imageView program
								| textView program
								| button program
								| progressBar program
								| %empty

radioButtonAttributes:			text layoutWidth layoutHeight 
								| text layoutHeight layoutWidth 
								| layoutWidth text layoutHeight 
								| layoutWidth layoutHeight text 
								| layoutHeight text layoutWidth 
								| layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id 
								| text layoutWidth id layoutHeight 
								| text layoutHeight layoutWidth id 
								| text layoutHeight id layoutWidth 
								| text id layoutWidth layoutHeight 
								| text id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id 
								| layoutWidth text id layoutHeight 
								| layoutWidth layoutHeight text id 
								| layoutWidth layoutHeight id text 
								| layoutWidth id text layoutHeight 
								| layoutWidth id layoutHeight text 
								| layoutHeight text layoutWidth id 
								| layoutHeight text id layoutWidth 
								| layoutHeight layoutWidth text id 
								| layoutHeight layoutWidth id text 
								| layoutHeight id text layoutWidth 
								| layoutHeight id layoutWidth text 
								| id text layoutWidth layoutHeight 
								| id text layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight 
								| id layoutWidth layoutHeight text 
								| id layoutHeight text layoutWidth 
								| id layoutHeight layoutWidth text 

imageViewAttributes:			source layoutWidth layoutHeight 
								| source layoutHeight layoutWidth 
								| layoutWidth source layoutHeight 
								| layoutWidth layoutHeight source 
								| layoutHeight source layoutWidth 
								| layoutHeight layoutWidth source 
								| source layoutWidth layoutHeight id 
								| source layoutWidth id layoutHeight 
								| source layoutHeight layoutWidth id 
								| source layoutHeight id layoutWidth 
								| source id layoutWidth layoutHeight 
								| source id layoutHeight layoutWidth 
								| layoutWidth source layoutHeight id 
								| layoutWidth source id layoutHeight 
								| layoutWidth layoutHeight source id 
								| layoutWidth layoutHeight id source 
								| layoutWidth id source layoutHeight 
								| layoutWidth id layoutHeight source 
								| layoutHeight source layoutWidth id 
								| layoutHeight source id layoutWidth 
								| layoutHeight layoutWidth source id 
								| layoutHeight layoutWidth id source 
								| layoutHeight id source layoutWidth 
								| layoutHeight id layoutWidth source 
								| id source layoutWidth layoutHeight 
								| id source layoutHeight layoutWidth 
								| id layoutWidth source layoutHeight 
								| id layoutWidth layoutHeight source 
								| id layoutHeight source layoutWidth 
								| id layoutHeight layoutWidth source 
								| source layoutWidth layoutHeight padding 
								| source layoutWidth padding layoutHeight 
								| source layoutHeight layoutWidth padding 
								| source layoutHeight padding layoutWidth 
								| source padding layoutWidth layoutHeight 
								| source padding layoutHeight layoutWidth 
								| layoutWidth source layoutHeight padding 
								| layoutWidth source padding layoutHeight 
								| layoutWidth layoutHeight source padding 
								| layoutWidth layoutHeight padding source 
								| layoutWidth padding source layoutHeight 
								| layoutWidth padding layoutHeight source 
								| layoutHeight source layoutWidth padding 
								| layoutHeight source padding layoutWidth 
								| layoutHeight layoutWidth source padding 
								| layoutHeight layoutWidth padding source 
								| layoutHeight padding source layoutWidth 
								| layoutHeight padding layoutWidth source 
								| padding source layoutWidth layoutHeight 
								| padding source layoutHeight layoutWidth 
								| padding layoutWidth source layoutHeight 
								| padding layoutWidth layoutHeight source 
								| padding layoutHeight source layoutWidth 
								| padding layoutHeight layoutWidth source 
								| source layoutWidth layoutHeight id padding 
								| source layoutWidth layoutHeight padding id 
								| source layoutWidth id layoutHeight padding 
								| source layoutWidth id padding layoutHeight 
								| source layoutWidth padding layoutHeight id 
								| source layoutWidth padding id layoutHeight 
								| source layoutHeight layoutWidth id padding 
								| source layoutHeight layoutWidth padding id 
								| source layoutHeight id layoutWidth padding 
								| source layoutHeight id padding layoutWidth 
								| source layoutHeight padding layoutWidth id 
								| source layoutHeight padding id layoutWidth 
								| source id layoutWidth layoutHeight padding 
								| source id layoutWidth padding layoutHeight 
								| source id layoutHeight layoutWidth padding 
								| source id layoutHeight padding layoutWidth 
								| source id padding layoutWidth layoutHeight 
								| source id padding layoutHeight layoutWidth 
								| source padding layoutWidth layoutHeight id 
								| source padding layoutWidth id layoutHeight 
								| source padding layoutHeight layoutWidth id 
								| source padding layoutHeight id layoutWidth 
								| source padding id layoutWidth layoutHeight 
								| source padding id layoutHeight layoutWidth 
								| layoutWidth source layoutHeight id padding 
								| layoutWidth source layoutHeight padding id 
								| layoutWidth source id layoutHeight padding 
								| layoutWidth source id padding layoutHeight 
								| layoutWidth source padding layoutHeight id 
								| layoutWidth source padding id layoutHeight 
								| layoutWidth layoutHeight source id padding 
								| layoutWidth layoutHeight source padding id 
								| layoutWidth layoutHeight id source padding 
								| layoutWidth layoutHeight id padding source 
								| layoutWidth layoutHeight padding source id 
								| layoutWidth layoutHeight padding id source 
								| layoutWidth id source layoutHeight padding 
								| layoutWidth id source padding layoutHeight 
								| layoutWidth id layoutHeight source padding 
								| layoutWidth id layoutHeight padding source 
								| layoutWidth id padding source layoutHeight 
								| layoutWidth id padding layoutHeight source 
								| layoutWidth padding source layoutHeight id 
								| layoutWidth padding source id layoutHeight 
								| layoutWidth padding layoutHeight source id 
								| layoutWidth padding layoutHeight id source 
								| layoutWidth padding id source layoutHeight 
								| layoutWidth padding id layoutHeight source 
								| layoutHeight source layoutWidth id padding 
								| layoutHeight source layoutWidth padding id 
								| layoutHeight source id layoutWidth padding 
								| layoutHeight source id padding layoutWidth 
								| layoutHeight source padding layoutWidth id 
								| layoutHeight source padding id layoutWidth 
								| layoutHeight layoutWidth source id padding 
								| layoutHeight layoutWidth source padding id 
								| layoutHeight layoutWidth id source padding 
								| layoutHeight layoutWidth id padding source 
								| layoutHeight layoutWidth padding source id 
								| layoutHeight layoutWidth padding id source 
								| layoutHeight id source layoutWidth padding 
								| layoutHeight id source padding layoutWidth 
								| layoutHeight id layoutWidth source padding 
								| layoutHeight id layoutWidth padding source 
								| layoutHeight id padding source layoutWidth 
								| layoutHeight id padding layoutWidth source 
								| layoutHeight padding source layoutWidth id 
								| layoutHeight padding source id layoutWidth 
								| layoutHeight padding layoutWidth source id 
								| layoutHeight padding layoutWidth id source 
								| layoutHeight padding id source layoutWidth 
								| layoutHeight padding id layoutWidth source 
								| id source layoutWidth layoutHeight padding 
								| id source layoutWidth padding layoutHeight 
								| id source layoutHeight layoutWidth padding 
								| id source layoutHeight padding layoutWidth 
								| id source padding layoutWidth layoutHeight 
								| id source padding layoutHeight layoutWidth 
								| id layoutWidth source layoutHeight padding 
								| id layoutWidth source padding layoutHeight 
								| id layoutWidth layoutHeight source padding 
								| id layoutWidth layoutHeight padding source 
								| id layoutWidth padding source layoutHeight 
								| id layoutWidth padding layoutHeight source 
								| id layoutHeight source layoutWidth padding 
								| id layoutHeight source padding layoutWidth 
								| id layoutHeight layoutWidth source padding 
								| id layoutHeight layoutWidth padding source 
								| id layoutHeight padding source layoutWidth 
								| id layoutHeight padding layoutWidth source 
								| id padding source layoutWidth layoutHeight 
								| id padding source layoutHeight layoutWidth 
								| id padding layoutWidth source layoutHeight 
								| id padding layoutWidth layoutHeight source 
								| id padding layoutHeight source layoutWidth 
								| id padding layoutHeight layoutWidth source 
								| padding source layoutWidth layoutHeight id 
								| padding source layoutWidth id layoutHeight 
								| padding source layoutHeight layoutWidth id 
								| padding source layoutHeight id layoutWidth 
								| padding source id layoutWidth layoutHeight 
								| padding source id layoutHeight layoutWidth 
								| padding layoutWidth source layoutHeight id 
								| padding layoutWidth source id layoutHeight 
								| padding layoutWidth layoutHeight source id 
								| padding layoutWidth layoutHeight id source 
								| padding layoutWidth id source layoutHeight 
								| padding layoutWidth id layoutHeight source 
								| padding layoutHeight source layoutWidth id 
								| padding layoutHeight source id layoutWidth 
								| padding layoutHeight layoutWidth source id 
								| padding layoutHeight layoutWidth id source 
								| padding layoutHeight id source layoutWidth 
								| padding layoutHeight id layoutWidth source 
								| padding id source layoutWidth layoutHeight 
								| padding id source layoutHeight layoutWidth 
								| padding id layoutWidth source layoutHeight 
								| padding id layoutWidth layoutHeight source 
								| padding id layoutHeight source layoutWidth 
								| padding id layoutHeight layoutWidth source 

textViewAttributes:				text layoutWidth layoutHeight 
								| text layoutHeight layoutWidth 
								| layoutWidth text layoutHeight 
								| layoutWidth layoutHeight text 
								| layoutHeight text layoutWidth 
								| layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id 
								| text layoutWidth id layoutHeight 
								| text layoutHeight layoutWidth id 
								| text layoutHeight id layoutWidth 
								| text id layoutWidth layoutHeight 
								| text id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id 
								| layoutWidth text id layoutHeight 
								| layoutWidth layoutHeight text id 
								| layoutWidth layoutHeight id text 
								| layoutWidth id text layoutHeight 
								| layoutWidth id layoutHeight text 
								| layoutHeight text layoutWidth id 
								| layoutHeight text id layoutWidth 
								| layoutHeight layoutWidth text id 
								| layoutHeight layoutWidth id text 
								| layoutHeight id text layoutWidth 
								| layoutHeight id layoutWidth text 
								| id text layoutWidth layoutHeight 
								| id text layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight 
								| id layoutWidth layoutHeight text 
								| id layoutHeight text layoutWidth 
								| id layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight textColor 
								| text layoutWidth textColor layoutHeight 
								| text layoutHeight layoutWidth textColor 
								| text layoutHeight textColor layoutWidth 
								| text textColor layoutWidth layoutHeight 
								| text textColor layoutHeight layoutWidth 
								| layoutWidth text layoutHeight textColor 
								| layoutWidth text textColor layoutHeight 
								| layoutWidth layoutHeight text textColor 
								| layoutWidth layoutHeight textColor text 
								| layoutWidth textColor text layoutHeight 
								| layoutWidth textColor layoutHeight text 
								| layoutHeight text layoutWidth textColor 
								| layoutHeight text textColor layoutWidth 
								| layoutHeight layoutWidth text textColor 
								| layoutHeight layoutWidth textColor text 
								| layoutHeight textColor text layoutWidth 
								| layoutHeight textColor layoutWidth text 
								| textColor text layoutWidth layoutHeight 
								| textColor text layoutHeight layoutWidth 
								| textColor layoutWidth text layoutHeight 
								| textColor layoutWidth layoutHeight text 
								| textColor layoutHeight text layoutWidth 
								| textColor layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id textColor 
								| text layoutWidth layoutHeight textColor id 
								| text layoutWidth id layoutHeight textColor 
								| text layoutWidth id textColor layoutHeight 
								| text layoutWidth textColor layoutHeight id 
								| text layoutWidth textColor id layoutHeight 
								| text layoutHeight layoutWidth id textColor 
								| text layoutHeight layoutWidth textColor id 
								| text layoutHeight id layoutWidth textColor 
								| text layoutHeight id textColor layoutWidth 
								| text layoutHeight textColor layoutWidth id 
								| text layoutHeight textColor id layoutWidth 
								| text id layoutWidth layoutHeight textColor 
								| text id layoutWidth textColor layoutHeight 
								| text id layoutHeight layoutWidth textColor 
								| text id layoutHeight textColor layoutWidth 
								| text id textColor layoutWidth layoutHeight 
								| text id textColor layoutHeight layoutWidth 
								| text textColor layoutWidth layoutHeight id 
								| text textColor layoutWidth id layoutHeight 
								| text textColor layoutHeight layoutWidth id 
								| text textColor layoutHeight id layoutWidth 
								| text textColor id layoutWidth layoutHeight 
								| text textColor id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id textColor 
								| layoutWidth text layoutHeight textColor id 
								| layoutWidth text id layoutHeight textColor 
								| layoutWidth text id textColor layoutHeight 
								| layoutWidth text textColor layoutHeight id 
								| layoutWidth text textColor id layoutHeight 
								| layoutWidth layoutHeight text id textColor 
								| layoutWidth layoutHeight text textColor id 
								| layoutWidth layoutHeight id text textColor 
								| layoutWidth layoutHeight id textColor text 
								| layoutWidth layoutHeight textColor text id 
								| layoutWidth layoutHeight textColor id text 
								| layoutWidth id text layoutHeight textColor 
								| layoutWidth id text textColor layoutHeight 
								| layoutWidth id layoutHeight text textColor 
								| layoutWidth id layoutHeight textColor text 
								| layoutWidth id textColor text layoutHeight 
								| layoutWidth id textColor layoutHeight text 
								| layoutWidth textColor text layoutHeight id 
								| layoutWidth textColor text id layoutHeight 
								| layoutWidth textColor layoutHeight text id 
								| layoutWidth textColor layoutHeight id text 
								| layoutWidth textColor id text layoutHeight 
								| layoutWidth textColor id layoutHeight text 
								| layoutHeight text layoutWidth id textColor 
								| layoutHeight text layoutWidth textColor id 
								| layoutHeight text id layoutWidth textColor 
								| layoutHeight text id textColor layoutWidth 
								| layoutHeight text textColor layoutWidth id 
								| layoutHeight text textColor id layoutWidth 
								| layoutHeight layoutWidth text id textColor 
								| layoutHeight layoutWidth text textColor id 
								| layoutHeight layoutWidth id text textColor 
								| layoutHeight layoutWidth id textColor text 
								| layoutHeight layoutWidth textColor text id 
								| layoutHeight layoutWidth textColor id text 
								| layoutHeight id text layoutWidth textColor 
								| layoutHeight id text textColor layoutWidth 
								| layoutHeight id layoutWidth text textColor 
								| layoutHeight id layoutWidth textColor text 
								| layoutHeight id textColor text layoutWidth 
								| layoutHeight id textColor layoutWidth text 
								| layoutHeight textColor text layoutWidth id 
								| layoutHeight textColor text id layoutWidth 
								| layoutHeight textColor layoutWidth text id 
								| layoutHeight textColor layoutWidth id text 
								| layoutHeight textColor id text layoutWidth 
								| layoutHeight textColor id layoutWidth text 
								| id text layoutWidth layoutHeight textColor 
								| id text layoutWidth textColor layoutHeight 
								| id text layoutHeight layoutWidth textColor 
								| id text layoutHeight textColor layoutWidth 
								| id text textColor layoutWidth layoutHeight 
								| id text textColor layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight textColor 
								| id layoutWidth text textColor layoutHeight 
								| id layoutWidth layoutHeight text textColor 
								| id layoutWidth layoutHeight textColor text 
								| id layoutWidth textColor text layoutHeight 
								| id layoutWidth textColor layoutHeight text 
								| id layoutHeight text layoutWidth textColor 
								| id layoutHeight text textColor layoutWidth 
								| id layoutHeight layoutWidth text textColor 
								| id layoutHeight layoutWidth textColor text 
								| id layoutHeight textColor text layoutWidth 
								| id layoutHeight textColor layoutWidth text 
								| id textColor text layoutWidth layoutHeight 
								| id textColor text layoutHeight layoutWidth 
								| id textColor layoutWidth text layoutHeight 
								| id textColor layoutWidth layoutHeight text 
								| id textColor layoutHeight text layoutWidth 
								| id textColor layoutHeight layoutWidth text 
								| textColor text layoutWidth layoutHeight id 
								| textColor text layoutWidth id layoutHeight 
								| textColor text layoutHeight layoutWidth id 
								| textColor text layoutHeight id layoutWidth 
								| textColor text id layoutWidth layoutHeight 
								| textColor text id layoutHeight layoutWidth 
								| textColor layoutWidth text layoutHeight id 
								| textColor layoutWidth text id layoutHeight 
								| textColor layoutWidth layoutHeight text id 
								| textColor layoutWidth layoutHeight id text 
								| textColor layoutWidth id text layoutHeight 
								| textColor layoutWidth id layoutHeight text 
								| textColor layoutHeight text layoutWidth id 
								| textColor layoutHeight text id layoutWidth 
								| textColor layoutHeight layoutWidth text id 
								| textColor layoutHeight layoutWidth id text 
								| textColor layoutHeight id text layoutWidth 
								| textColor layoutHeight id layoutWidth text 
								| textColor id text layoutWidth layoutHeight 
								| textColor id text layoutHeight layoutWidth 
								| textColor id layoutWidth text layoutHeight 
								| textColor id layoutWidth layoutHeight text 
								| textColor id layoutHeight text layoutWidth 
								| textColor id layoutHeight layoutWidth text 

buttonAttributes:				text layoutWidth layoutHeight 
								| text layoutHeight layoutWidth 
								| layoutWidth text layoutHeight 
								| layoutWidth layoutHeight text 
								| layoutHeight text layoutWidth 
								| layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id 
								| text layoutWidth id layoutHeight 
								| text layoutHeight layoutWidth id 
								| text layoutHeight id layoutWidth 
								| text id layoutWidth layoutHeight 
								| text id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id 
								| layoutWidth text id layoutHeight 
								| layoutWidth layoutHeight text id 
								| layoutWidth layoutHeight id text 
								| layoutWidth id text layoutHeight 
								| layoutWidth id layoutHeight text 
								| layoutHeight text layoutWidth id 
								| layoutHeight text id layoutWidth 
								| layoutHeight layoutWidth text id 
								| layoutHeight layoutWidth id text 
								| layoutHeight id text layoutWidth 
								| layoutHeight id layoutWidth text 
								| id text layoutWidth layoutHeight 
								| id text layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight 
								| id layoutWidth layoutHeight text 
								| id layoutHeight text layoutWidth 
								| id layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight padding 
								| text layoutWidth padding layoutHeight 
								| text layoutHeight layoutWidth padding 
								| text layoutHeight padding layoutWidth 
								| text padding layoutWidth layoutHeight 
								| text padding layoutHeight layoutWidth 
								| layoutWidth text layoutHeight padding 
								| layoutWidth text padding layoutHeight 
								| layoutWidth layoutHeight text padding 
								| layoutWidth layoutHeight padding text 
								| layoutWidth padding text layoutHeight 
								| layoutWidth padding layoutHeight text 
								| layoutHeight text layoutWidth padding 
								| layoutHeight text padding layoutWidth 
								| layoutHeight layoutWidth text padding 
								| layoutHeight layoutWidth padding text 
								| layoutHeight padding text layoutWidth 
								| layoutHeight padding layoutWidth text 
								| padding text layoutWidth layoutHeight 
								| padding text layoutHeight layoutWidth 
								| padding layoutWidth text layoutHeight 
								| padding layoutWidth layoutHeight text 
								| padding layoutHeight text layoutWidth 
								| padding layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id padding 
								| text layoutWidth layoutHeight padding id 
								| text layoutWidth id layoutHeight padding 
								| text layoutWidth id padding layoutHeight 
								| text layoutWidth padding layoutHeight id 
								| text layoutWidth padding id layoutHeight 
								| text layoutHeight layoutWidth id padding 
								| text layoutHeight layoutWidth padding id 
								| text layoutHeight id layoutWidth padding 
								| text layoutHeight id padding layoutWidth 
								| text layoutHeight padding layoutWidth id 
								| text layoutHeight padding id layoutWidth 
								| text id layoutWidth layoutHeight padding 
								| text id layoutWidth padding layoutHeight 
								| text id layoutHeight layoutWidth padding 
								| text id layoutHeight padding layoutWidth 
								| text id padding layoutWidth layoutHeight 
								| text id padding layoutHeight layoutWidth 
								| text padding layoutWidth layoutHeight id 
								| text padding layoutWidth id layoutHeight 
								| text padding layoutHeight layoutWidth id 
								| text padding layoutHeight id layoutWidth 
								| text padding id layoutWidth layoutHeight 
								| text padding id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id padding 
								| layoutWidth text layoutHeight padding id 
								| layoutWidth text id layoutHeight padding 
								| layoutWidth text id padding layoutHeight 
								| layoutWidth text padding layoutHeight id 
								| layoutWidth text padding id layoutHeight 
								| layoutWidth layoutHeight text id padding 
								| layoutWidth layoutHeight text padding id 
								| layoutWidth layoutHeight id text padding 
								| layoutWidth layoutHeight id padding text 
								| layoutWidth layoutHeight padding text id 
								| layoutWidth layoutHeight padding id text 
								| layoutWidth id text layoutHeight padding 
								| layoutWidth id text padding layoutHeight 
								| layoutWidth id layoutHeight text padding 
								| layoutWidth id layoutHeight padding text 
								| layoutWidth id padding text layoutHeight 
								| layoutWidth id padding layoutHeight text 
								| layoutWidth padding text layoutHeight id 
								| layoutWidth padding text id layoutHeight 
								| layoutWidth padding layoutHeight text id 
								| layoutWidth padding layoutHeight id text 
								| layoutWidth padding id text layoutHeight 
								| layoutWidth padding id layoutHeight text 
								| layoutHeight text layoutWidth id padding 
								| layoutHeight text layoutWidth padding id 
								| layoutHeight text id layoutWidth padding 
								| layoutHeight text id padding layoutWidth 
								| layoutHeight text padding layoutWidth id 
								| layoutHeight text padding id layoutWidth 
								| layoutHeight layoutWidth text id padding 
								| layoutHeight layoutWidth text padding id 
								| layoutHeight layoutWidth id text padding 
								| layoutHeight layoutWidth id padding text 
								| layoutHeight layoutWidth padding text id 
								| layoutHeight layoutWidth padding id text 
								| layoutHeight id text layoutWidth padding 
								| layoutHeight id text padding layoutWidth 
								| layoutHeight id layoutWidth text padding 
								| layoutHeight id layoutWidth padding text 
								| layoutHeight id padding text layoutWidth 
								| layoutHeight id padding layoutWidth text 
								| layoutHeight padding text layoutWidth id 
								| layoutHeight padding text id layoutWidth 
								| layoutHeight padding layoutWidth text id 
								| layoutHeight padding layoutWidth id text 
								| layoutHeight padding id text layoutWidth 
								| layoutHeight padding id layoutWidth text 
								| id text layoutWidth layoutHeight padding 
								| id text layoutWidth padding layoutHeight 
								| id text layoutHeight layoutWidth padding 
								| id text layoutHeight padding layoutWidth 
								| id text padding layoutWidth layoutHeight 
								| id text padding layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight padding 
								| id layoutWidth text padding layoutHeight 
								| id layoutWidth layoutHeight text padding 
								| id layoutWidth layoutHeight padding text 
								| id layoutWidth padding text layoutHeight 
								| id layoutWidth padding layoutHeight text 
								| id layoutHeight text layoutWidth padding 
								| id layoutHeight text padding layoutWidth 
								| id layoutHeight layoutWidth text padding 
								| id layoutHeight layoutWidth padding text 
								| id layoutHeight padding text layoutWidth 
								| id layoutHeight padding layoutWidth text 
								| id padding text layoutWidth layoutHeight 
								| id padding text layoutHeight layoutWidth 
								| id padding layoutWidth text layoutHeight 
								| id padding layoutWidth layoutHeight text 
								| id padding layoutHeight text layoutWidth 
								| id padding layoutHeight layoutWidth text 
								| padding text layoutWidth layoutHeight id 
								| padding text layoutWidth id layoutHeight 
								| padding text layoutHeight layoutWidth id 
								| padding text layoutHeight id layoutWidth 
								| padding text id layoutWidth layoutHeight 
								| padding text id layoutHeight layoutWidth 
								| padding layoutWidth text layoutHeight id 
								| padding layoutWidth text id layoutHeight 
								| padding layoutWidth layoutHeight text id 
								| padding layoutWidth layoutHeight id text 
								| padding layoutWidth id text layoutHeight 
								| padding layoutWidth id layoutHeight text 
								| padding layoutHeight text layoutWidth id 
								| padding layoutHeight text id layoutWidth 
								| padding layoutHeight layoutWidth text id 
								| padding layoutHeight layoutWidth id text 
								| padding layoutHeight id text layoutWidth 
								| padding layoutHeight id layoutWidth text 
								| padding id text layoutWidth layoutHeight 
								| padding id text layoutHeight layoutWidth 
								| padding id layoutWidth text layoutHeight 
								| padding id layoutWidth layoutHeight text 
								| padding id layoutHeight text layoutWidth 
								| padding id layoutHeight layoutWidth text 

progressBarAttributes:			text layoutWidth layoutHeight 
								| text layoutHeight layoutWidth 
								| layoutWidth text layoutHeight 
								| layoutWidth layoutHeight text 
								| layoutHeight text layoutWidth 
								| layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id 
								| text layoutWidth id layoutHeight 
								| text layoutHeight layoutWidth id 
								| text layoutHeight id layoutWidth 
								| text id layoutWidth layoutHeight 
								| text id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id 
								| layoutWidth text id layoutHeight 
								| layoutWidth layoutHeight text id 
								| layoutWidth layoutHeight id text 
								| layoutWidth id text layoutHeight 
								| layoutWidth id layoutHeight text 
								| layoutHeight text layoutWidth id 
								| layoutHeight text id layoutWidth 
								| layoutHeight layoutWidth text id 
								| layoutHeight layoutWidth id text 
								| layoutHeight id text layoutWidth 
								| layoutHeight id layoutWidth text 
								| id text layoutWidth layoutHeight 
								| id text layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight 
								| id layoutWidth layoutHeight text 
								| id layoutHeight text layoutWidth 
								| id layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight max 
								| text layoutWidth max layoutHeight 
								| text layoutHeight layoutWidth max 
								| text layoutHeight max layoutWidth 
								| text max layoutWidth layoutHeight 
								| text max layoutHeight layoutWidth 
								| layoutWidth text layoutHeight max 
								| layoutWidth text max layoutHeight 
								| layoutWidth layoutHeight text max 
								| layoutWidth layoutHeight max text 
								| layoutWidth max text layoutHeight 
								| layoutWidth max layoutHeight text 
								| layoutHeight text layoutWidth max 
								| layoutHeight text max layoutWidth 
								| layoutHeight layoutWidth text max 
								| layoutHeight layoutWidth max text 
								| layoutHeight max text layoutWidth 
								| layoutHeight max layoutWidth text 
								| max text layoutWidth layoutHeight 
								| max text layoutHeight layoutWidth 
								| max layoutWidth text layoutHeight 
								| max layoutWidth layoutHeight text 
								| max layoutHeight text layoutWidth 
								| max layoutHeight layoutWidth text 
								| text layoutWidth layoutHeight id padding progress 
								| text layoutWidth layoutHeight id progress padding 
								| text layoutWidth layoutHeight padding id progress 
								| text layoutWidth layoutHeight padding progress id 
								| text layoutWidth layoutHeight progress id padding 
								| text layoutWidth layoutHeight progress padding id 
								| text layoutWidth id layoutHeight padding progress 
								| text layoutWidth id layoutHeight progress padding 
								| text layoutWidth id padding layoutHeight progress 
								| text layoutWidth id padding progress layoutHeight 
								| text layoutWidth id progress layoutHeight padding 
								| text layoutWidth id progress padding layoutHeight 
								| text layoutWidth padding layoutHeight id progress 
								| text layoutWidth padding layoutHeight progress id 
								| text layoutWidth padding id layoutHeight progress 
								| text layoutWidth padding id progress layoutHeight 
								| text layoutWidth padding progress layoutHeight id 
								| text layoutWidth padding progress id layoutHeight 
								| text layoutWidth progress layoutHeight id padding 
								| text layoutWidth progress layoutHeight padding id 
								| text layoutWidth progress id layoutHeight padding 
								| text layoutWidth progress id padding layoutHeight 
								| text layoutWidth progress padding layoutHeight id 
								| text layoutWidth progress padding id layoutHeight 
								| text layoutHeight layoutWidth id padding progress 
								| text layoutHeight layoutWidth id progress padding 
								| text layoutHeight layoutWidth padding id progress 
								| text layoutHeight layoutWidth padding progress id 
								| text layoutHeight layoutWidth progress id padding 
								| text layoutHeight layoutWidth progress padding id 
								| text layoutHeight id layoutWidth padding progress 
								| text layoutHeight id layoutWidth progress padding 
								| text layoutHeight id padding layoutWidth progress 
								| text layoutHeight id padding progress layoutWidth 
								| text layoutHeight id progress layoutWidth padding 
								| text layoutHeight id progress padding layoutWidth 
								| text layoutHeight padding layoutWidth id progress 
								| text layoutHeight padding layoutWidth progress id 
								| text layoutHeight padding id layoutWidth progress 
								| text layoutHeight padding id progress layoutWidth 
								| text layoutHeight padding progress layoutWidth id 
								| text layoutHeight padding progress id layoutWidth 
								| text layoutHeight progress layoutWidth id padding 
								| text layoutHeight progress layoutWidth padding id 
								| text layoutHeight progress id layoutWidth padding 
								| text layoutHeight progress id padding layoutWidth 
								| text layoutHeight progress padding layoutWidth id 
								| text layoutHeight progress padding id layoutWidth 
								| text id layoutWidth layoutHeight padding progress 
								| text id layoutWidth layoutHeight progress padding 
								| text id layoutWidth padding layoutHeight progress 
								| text id layoutWidth padding progress layoutHeight 
								| text id layoutWidth progress layoutHeight padding 
								| text id layoutWidth progress padding layoutHeight 
								| text id layoutHeight layoutWidth padding progress 
								| text id layoutHeight layoutWidth progress padding 
								| text id layoutHeight padding layoutWidth progress 
								| text id layoutHeight padding progress layoutWidth 
								| text id layoutHeight progress layoutWidth padding 
								| text id layoutHeight progress padding layoutWidth 
								| text id padding layoutWidth layoutHeight progress 
								| text id padding layoutWidth progress layoutHeight 
								| text id padding layoutHeight layoutWidth progress 
								| text id padding layoutHeight progress layoutWidth 
								| text id padding progress layoutWidth layoutHeight 
								| text id padding progress layoutHeight layoutWidth 
								| text id progress layoutWidth layoutHeight padding 
								| text id progress layoutWidth padding layoutHeight 
								| text id progress layoutHeight layoutWidth padding 
								| text id progress layoutHeight padding layoutWidth 
								| text id progress padding layoutWidth layoutHeight 
								| text id progress padding layoutHeight layoutWidth 
								| text padding layoutWidth layoutHeight id progress 
								| text padding layoutWidth layoutHeight progress id 
								| text padding layoutWidth id layoutHeight progress 
								| text padding layoutWidth id progress layoutHeight 
								| text padding layoutWidth progress layoutHeight id 
								| text padding layoutWidth progress id layoutHeight 
								| text padding layoutHeight layoutWidth id progress 
								| text padding layoutHeight layoutWidth progress id 
								| text padding layoutHeight id layoutWidth progress 
								| text padding layoutHeight id progress layoutWidth 
								| text padding layoutHeight progress layoutWidth id 
								| text padding layoutHeight progress id layoutWidth 
								| text padding id layoutWidth layoutHeight progress 
								| text padding id layoutWidth progress layoutHeight 
								| text padding id layoutHeight layoutWidth progress 
								| text padding id layoutHeight progress layoutWidth 
								| text padding id progress layoutWidth layoutHeight 
								| text padding id progress layoutHeight layoutWidth 
								| text padding progress layoutWidth layoutHeight id 
								| text padding progress layoutWidth id layoutHeight 
								| text padding progress layoutHeight layoutWidth id 
								| text padding progress layoutHeight id layoutWidth 
								| text padding progress id layoutWidth layoutHeight 
								| text padding progress id layoutHeight layoutWidth 
								| text progress layoutWidth layoutHeight id padding 
								| text progress layoutWidth layoutHeight padding id 
								| text progress layoutWidth id layoutHeight padding 
								| text progress layoutWidth id padding layoutHeight 
								| text progress layoutWidth padding layoutHeight id 
								| text progress layoutWidth padding id layoutHeight 
								| text progress layoutHeight layoutWidth id padding 
								| text progress layoutHeight layoutWidth padding id 
								| text progress layoutHeight id layoutWidth padding 
								| text progress layoutHeight id padding layoutWidth 
								| text progress layoutHeight padding layoutWidth id 
								| text progress layoutHeight padding id layoutWidth 
								| text progress id layoutWidth layoutHeight padding 
								| text progress id layoutWidth padding layoutHeight 
								| text progress id layoutHeight layoutWidth padding 
								| text progress id layoutHeight padding layoutWidth 
								| text progress id padding layoutWidth layoutHeight 
								| text progress id padding layoutHeight layoutWidth 
								| text progress padding layoutWidth layoutHeight id 
								| text progress padding layoutWidth id layoutHeight 
								| text progress padding layoutHeight layoutWidth id 
								| text progress padding layoutHeight id layoutWidth 
								| text progress padding id layoutWidth layoutHeight 
								| text progress padding id layoutHeight layoutWidth 
								| layoutWidth text layoutHeight id padding progress 
								| layoutWidth text layoutHeight id progress padding 
								| layoutWidth text layoutHeight padding id progress 
								| layoutWidth text layoutHeight padding progress id 
								| layoutWidth text layoutHeight progress id padding 
								| layoutWidth text layoutHeight progress padding id 
								| layoutWidth text id layoutHeight padding progress 
								| layoutWidth text id layoutHeight progress padding 
								| layoutWidth text id padding layoutHeight progress 
								| layoutWidth text id padding progress layoutHeight 
								| layoutWidth text id progress layoutHeight padding 
								| layoutWidth text id progress padding layoutHeight 
								| layoutWidth text padding layoutHeight id progress 
								| layoutWidth text padding layoutHeight progress id 
								| layoutWidth text padding id layoutHeight progress 
								| layoutWidth text padding id progress layoutHeight 
								| layoutWidth text padding progress layoutHeight id 
								| layoutWidth text padding progress id layoutHeight 
								| layoutWidth text progress layoutHeight id padding 
								| layoutWidth text progress layoutHeight padding id 
								| layoutWidth text progress id layoutHeight padding 
								| layoutWidth text progress id padding layoutHeight 
								| layoutWidth text progress padding layoutHeight id 
								| layoutWidth text progress padding id layoutHeight 
								| layoutWidth layoutHeight text id padding progress 
								| layoutWidth layoutHeight text id progress padding 
								| layoutWidth layoutHeight text padding id progress 
								| layoutWidth layoutHeight text padding progress id 
								| layoutWidth layoutHeight text progress id padding 
								| layoutWidth layoutHeight text progress padding id 
								| layoutWidth layoutHeight id text padding progress 
								| layoutWidth layoutHeight id text progress padding 
								| layoutWidth layoutHeight id padding text progress 
								| layoutWidth layoutHeight id padding progress text 
								| layoutWidth layoutHeight id progress text padding 
								| layoutWidth layoutHeight id progress padding text 
								| layoutWidth layoutHeight padding text id progress 
								| layoutWidth layoutHeight padding text progress id 
								| layoutWidth layoutHeight padding id text progress 
								| layoutWidth layoutHeight padding id progress text 
								| layoutWidth layoutHeight padding progress text id 
								| layoutWidth layoutHeight padding progress id text 
								| layoutWidth layoutHeight progress text id padding 
								| layoutWidth layoutHeight progress text padding id 
								| layoutWidth layoutHeight progress id text padding 
								| layoutWidth layoutHeight progress id padding text 
								| layoutWidth layoutHeight progress padding text id 
								| layoutWidth layoutHeight progress padding id text 
								| layoutWidth id text layoutHeight padding progress 
								| layoutWidth id text layoutHeight progress padding 
								| layoutWidth id text padding layoutHeight progress 
								| layoutWidth id text padding progress layoutHeight 
								| layoutWidth id text progress layoutHeight padding 
								| layoutWidth id text progress padding layoutHeight 
								| layoutWidth id layoutHeight text padding progress 
								| layoutWidth id layoutHeight text progress padding 
								| layoutWidth id layoutHeight padding text progress 
								| layoutWidth id layoutHeight padding progress text 
								| layoutWidth id layoutHeight progress text padding 
								| layoutWidth id layoutHeight progress padding text 
								| layoutWidth id padding text layoutHeight progress 
								| layoutWidth id padding text progress layoutHeight 
								| layoutWidth id padding layoutHeight text progress 
								| layoutWidth id padding layoutHeight progress text 
								| layoutWidth id padding progress text layoutHeight 
								| layoutWidth id padding progress layoutHeight text 
								| layoutWidth id progress text layoutHeight padding 
								| layoutWidth id progress text padding layoutHeight 
								| layoutWidth id progress layoutHeight text padding 
								| layoutWidth id progress layoutHeight padding text 
								| layoutWidth id progress padding text layoutHeight 
								| layoutWidth id progress padding layoutHeight text 
								| layoutWidth padding text layoutHeight id progress 
								| layoutWidth padding text layoutHeight progress id 
								| layoutWidth padding text id layoutHeight progress 
								| layoutWidth padding text id progress layoutHeight 
								| layoutWidth padding text progress layoutHeight id 
								| layoutWidth padding text progress id layoutHeight 
								| layoutWidth padding layoutHeight text id progress 
								| layoutWidth padding layoutHeight text progress id 
								| layoutWidth padding layoutHeight id text progress 
								| layoutWidth padding layoutHeight id progress text 
								| layoutWidth padding layoutHeight progress text id 
								| layoutWidth padding layoutHeight progress id text 
								| layoutWidth padding id text layoutHeight progress 
								| layoutWidth padding id text progress layoutHeight 
								| layoutWidth padding id layoutHeight text progress 
								| layoutWidth padding id layoutHeight progress text 
								| layoutWidth padding id progress text layoutHeight 
								| layoutWidth padding id progress layoutHeight text 
								| layoutWidth padding progress text layoutHeight id 
								| layoutWidth padding progress text id layoutHeight 
								| layoutWidth padding progress layoutHeight text id 
								| layoutWidth padding progress layoutHeight id text 
								| layoutWidth padding progress id text layoutHeight 
								| layoutWidth padding progress id layoutHeight text 
								| layoutWidth progress text layoutHeight id padding 
								| layoutWidth progress text layoutHeight padding id 
								| layoutWidth progress text id layoutHeight padding 
								| layoutWidth progress text id padding layoutHeight 
								| layoutWidth progress text padding layoutHeight id 
								| layoutWidth progress text padding id layoutHeight 
								| layoutWidth progress layoutHeight text id padding 
								| layoutWidth progress layoutHeight text padding id 
								| layoutWidth progress layoutHeight id text padding 
								| layoutWidth progress layoutHeight id padding text 
								| layoutWidth progress layoutHeight padding text id 
								| layoutWidth progress layoutHeight padding id text 
								| layoutWidth progress id text layoutHeight padding 
								| layoutWidth progress id text padding layoutHeight 
								| layoutWidth progress id layoutHeight text padding 
								| layoutWidth progress id layoutHeight padding text 
								| layoutWidth progress id padding text layoutHeight 
								| layoutWidth progress id padding layoutHeight text 
								| layoutWidth progress padding text layoutHeight id 
								| layoutWidth progress padding text id layoutHeight 
								| layoutWidth progress padding layoutHeight text id 
								| layoutWidth progress padding layoutHeight id text 
								| layoutWidth progress padding id text layoutHeight 
								| layoutWidth progress padding id layoutHeight text 
								| layoutHeight text layoutWidth id padding progress 
								| layoutHeight text layoutWidth id progress padding 
								| layoutHeight text layoutWidth padding id progress 
								| layoutHeight text layoutWidth padding progress id 
								| layoutHeight text layoutWidth progress id padding 
								| layoutHeight text layoutWidth progress padding id 
								| layoutHeight text id layoutWidth padding progress 
								| layoutHeight text id layoutWidth progress padding 
								| layoutHeight text id padding layoutWidth progress 
								| layoutHeight text id padding progress layoutWidth 
								| layoutHeight text id progress layoutWidth padding 
								| layoutHeight text id progress padding layoutWidth 
								| layoutHeight text padding layoutWidth id progress 
								| layoutHeight text padding layoutWidth progress id 
								| layoutHeight text padding id layoutWidth progress 
								| layoutHeight text padding id progress layoutWidth 
								| layoutHeight text padding progress layoutWidth id 
								| layoutHeight text padding progress id layoutWidth 
								| layoutHeight text progress layoutWidth id padding 
								| layoutHeight text progress layoutWidth padding id 
								| layoutHeight text progress id layoutWidth padding 
								| layoutHeight text progress id padding layoutWidth 
								| layoutHeight text progress padding layoutWidth id 
								| layoutHeight text progress padding id layoutWidth 
								| layoutHeight layoutWidth text id padding progress 
								| layoutHeight layoutWidth text id progress padding 
								| layoutHeight layoutWidth text padding id progress 
								| layoutHeight layoutWidth text padding progress id 
								| layoutHeight layoutWidth text progress id padding 
								| layoutHeight layoutWidth text progress padding id 
								| layoutHeight layoutWidth id text padding progress 
								| layoutHeight layoutWidth id text progress padding 
								| layoutHeight layoutWidth id padding text progress 
								| layoutHeight layoutWidth id padding progress text 
								| layoutHeight layoutWidth id progress text padding 
								| layoutHeight layoutWidth id progress padding text 
								| layoutHeight layoutWidth padding text id progress 
								| layoutHeight layoutWidth padding text progress id 
								| layoutHeight layoutWidth padding id text progress 
								| layoutHeight layoutWidth padding id progress text 
								| layoutHeight layoutWidth padding progress text id 
								| layoutHeight layoutWidth padding progress id text 
								| layoutHeight layoutWidth progress text id padding 
								| layoutHeight layoutWidth progress text padding id 
								| layoutHeight layoutWidth progress id text padding 
								| layoutHeight layoutWidth progress id padding text 
								| layoutHeight layoutWidth progress padding text id 
								| layoutHeight layoutWidth progress padding id text 
								| layoutHeight id text layoutWidth padding progress 
								| layoutHeight id text layoutWidth progress padding 
								| layoutHeight id text padding layoutWidth progress 
								| layoutHeight id text padding progress layoutWidth 
								| layoutHeight id text progress layoutWidth padding 
								| layoutHeight id text progress padding layoutWidth 
								| layoutHeight id layoutWidth text padding progress 
								| layoutHeight id layoutWidth text progress padding 
								| layoutHeight id layoutWidth padding text progress 
								| layoutHeight id layoutWidth padding progress text 
								| layoutHeight id layoutWidth progress text padding 
								| layoutHeight id layoutWidth progress padding text 
								| layoutHeight id padding text layoutWidth progress 
								| layoutHeight id padding text progress layoutWidth 
								| layoutHeight id padding layoutWidth text progress 
								| layoutHeight id padding layoutWidth progress text 
								| layoutHeight id padding progress text layoutWidth 
								| layoutHeight id padding progress layoutWidth text 
								| layoutHeight id progress text layoutWidth padding 
								| layoutHeight id progress text padding layoutWidth 
								| layoutHeight id progress layoutWidth text padding 
								| layoutHeight id progress layoutWidth padding text 
								| layoutHeight id progress padding text layoutWidth 
								| layoutHeight id progress padding layoutWidth text 
								| layoutHeight padding text layoutWidth id progress 
								| layoutHeight padding text layoutWidth progress id 
								| layoutHeight padding text id layoutWidth progress 
								| layoutHeight padding text id progress layoutWidth 
								| layoutHeight padding text progress layoutWidth id 
								| layoutHeight padding text progress id layoutWidth 
								| layoutHeight padding layoutWidth text id progress 
								| layoutHeight padding layoutWidth text progress id 
								| layoutHeight padding layoutWidth id text progress 
								| layoutHeight padding layoutWidth id progress text 
								| layoutHeight padding layoutWidth progress text id 
								| layoutHeight padding layoutWidth progress id text 
								| layoutHeight padding id text layoutWidth progress 
								| layoutHeight padding id text progress layoutWidth 
								| layoutHeight padding id layoutWidth text progress 
								| layoutHeight padding id layoutWidth progress text 
								| layoutHeight padding id progress text layoutWidth 
								| layoutHeight padding id progress layoutWidth text 
								| layoutHeight padding progress text layoutWidth id 
								| layoutHeight padding progress text id layoutWidth 
								| layoutHeight padding progress layoutWidth text id 
								| layoutHeight padding progress layoutWidth id text 
								| layoutHeight padding progress id text layoutWidth 
								| layoutHeight padding progress id layoutWidth text 
								| layoutHeight progress text layoutWidth id padding 
								| layoutHeight progress text layoutWidth padding id 
								| layoutHeight progress text id layoutWidth padding 
								| layoutHeight progress text id padding layoutWidth 
								| layoutHeight progress text padding layoutWidth id 
								| layoutHeight progress text padding id layoutWidth 
								| layoutHeight progress layoutWidth text id padding 
								| layoutHeight progress layoutWidth text padding id 
								| layoutHeight progress layoutWidth id text padding 
								| layoutHeight progress layoutWidth id padding text 
								| layoutHeight progress layoutWidth padding text id 
								| layoutHeight progress layoutWidth padding id text 
								| layoutHeight progress id text layoutWidth padding 
								| layoutHeight progress id text padding layoutWidth 
								| layoutHeight progress id layoutWidth text padding 
								| layoutHeight progress id layoutWidth padding text 
								| layoutHeight progress id padding text layoutWidth 
								| layoutHeight progress id padding layoutWidth text 
								| layoutHeight progress padding text layoutWidth id 
								| layoutHeight progress padding text id layoutWidth 
								| layoutHeight progress padding layoutWidth text id 
								| layoutHeight progress padding layoutWidth id text 
								| layoutHeight progress padding id text layoutWidth 
								| layoutHeight progress padding id layoutWidth text 
								| id text layoutWidth layoutHeight padding progress 
								| id text layoutWidth layoutHeight progress padding 
								| id text layoutWidth padding layoutHeight progress 
								| id text layoutWidth padding progress layoutHeight 
								| id text layoutWidth progress layoutHeight padding 
								| id text layoutWidth progress padding layoutHeight 
								| id text layoutHeight layoutWidth padding progress 
								| id text layoutHeight layoutWidth progress padding 
								| id text layoutHeight padding layoutWidth progress 
								| id text layoutHeight padding progress layoutWidth 
								| id text layoutHeight progress layoutWidth padding 
								| id text layoutHeight progress padding layoutWidth 
								| id text padding layoutWidth layoutHeight progress 
								| id text padding layoutWidth progress layoutHeight 
								| id text padding layoutHeight layoutWidth progress 
								| id text padding layoutHeight progress layoutWidth 
								| id text padding progress layoutWidth layoutHeight 
								| id text padding progress layoutHeight layoutWidth 
								| id text progress layoutWidth layoutHeight padding 
								| id text progress layoutWidth padding layoutHeight 
								| id text progress layoutHeight layoutWidth padding 
								| id text progress layoutHeight padding layoutWidth 
								| id text progress padding layoutWidth layoutHeight 
								| id text progress padding layoutHeight layoutWidth 
								| id layoutWidth text layoutHeight padding progress 
								| id layoutWidth text layoutHeight progress padding 
								| id layoutWidth text padding layoutHeight progress 
								| id layoutWidth text padding progress layoutHeight 
								| id layoutWidth text progress layoutHeight padding 
								| id layoutWidth text progress padding layoutHeight 
								| id layoutWidth layoutHeight text padding progress 
								| id layoutWidth layoutHeight text progress padding 
								| id layoutWidth layoutHeight padding text progress 
								| id layoutWidth layoutHeight padding progress text 
								| id layoutWidth layoutHeight progress text padding 
								| id layoutWidth layoutHeight progress padding text 
								| id layoutWidth padding text layoutHeight progress 
								| id layoutWidth padding text progress layoutHeight 
								| id layoutWidth padding layoutHeight text progress 
								| id layoutWidth padding layoutHeight progress text 
								| id layoutWidth padding progress text layoutHeight 
								| id layoutWidth padding progress layoutHeight text 
								| id layoutWidth progress text layoutHeight padding 
								| id layoutWidth progress text padding layoutHeight 
								| id layoutWidth progress layoutHeight text padding 
								| id layoutWidth progress layoutHeight padding text 
								| id layoutWidth progress padding text layoutHeight 
								| id layoutWidth progress padding layoutHeight text 
								| id layoutHeight text layoutWidth padding progress 
								| id layoutHeight text layoutWidth progress padding 
								| id layoutHeight text padding layoutWidth progress 
								| id layoutHeight text padding progress layoutWidth 
								| id layoutHeight text progress layoutWidth padding 
								| id layoutHeight text progress padding layoutWidth 
								| id layoutHeight layoutWidth text padding progress 
								| id layoutHeight layoutWidth text progress padding 
								| id layoutHeight layoutWidth padding text progress 
								| id layoutHeight layoutWidth padding progress text 
								| id layoutHeight layoutWidth progress text padding 
								| id layoutHeight layoutWidth progress padding text 
								| id layoutHeight padding text layoutWidth progress 
								| id layoutHeight padding text progress layoutWidth 
								| id layoutHeight padding layoutWidth text progress 
								| id layoutHeight padding layoutWidth progress text 
								| id layoutHeight padding progress text layoutWidth 
								| id layoutHeight padding progress layoutWidth text 
								| id layoutHeight progress text layoutWidth padding 
								| id layoutHeight progress text padding layoutWidth 
								| id layoutHeight progress layoutWidth text padding 
								| id layoutHeight progress layoutWidth padding text 
								| id layoutHeight progress padding text layoutWidth 
								| id layoutHeight progress padding layoutWidth text 
								| id padding text layoutWidth layoutHeight progress 
								| id padding text layoutWidth progress layoutHeight 
								| id padding text layoutHeight layoutWidth progress 
								| id padding text layoutHeight progress layoutWidth 
								| id padding text progress layoutWidth layoutHeight 
								| id padding text progress layoutHeight layoutWidth 
								| id padding layoutWidth text layoutHeight progress 
								| id padding layoutWidth text progress layoutHeight 
								| id padding layoutWidth layoutHeight text progress 
								| id padding layoutWidth layoutHeight progress text 
								| id padding layoutWidth progress text layoutHeight 
								| id padding layoutWidth progress layoutHeight text 
								| id padding layoutHeight text layoutWidth progress 
								| id padding layoutHeight text progress layoutWidth 
								| id padding layoutHeight layoutWidth text progress 
								| id padding layoutHeight layoutWidth progress text 
								| id padding layoutHeight progress text layoutWidth 
								| id padding layoutHeight progress layoutWidth text 
								| id padding progress text layoutWidth layoutHeight 
								| id padding progress text layoutHeight layoutWidth 
								| id padding progress layoutWidth text layoutHeight 
								| id padding progress layoutWidth layoutHeight text 
								| id padding progress layoutHeight text layoutWidth 
								| id padding progress layoutHeight layoutWidth text 
								| id progress text layoutWidth layoutHeight padding 
								| id progress text layoutWidth padding layoutHeight 
								| id progress text layoutHeight layoutWidth padding 
								| id progress text layoutHeight padding layoutWidth 
								| id progress text padding layoutWidth layoutHeight 
								| id progress text padding layoutHeight layoutWidth 
								| id progress layoutWidth text layoutHeight padding 
								| id progress layoutWidth text padding layoutHeight 
								| id progress layoutWidth layoutHeight text padding 
								| id progress layoutWidth layoutHeight padding text 
								| id progress layoutWidth padding text layoutHeight 
								| id progress layoutWidth padding layoutHeight text 
								| id progress layoutHeight text layoutWidth padding 
								| id progress layoutHeight text padding layoutWidth 
								| id progress layoutHeight layoutWidth text padding 
								| id progress layoutHeight layoutWidth padding text 
								| id progress layoutHeight padding text layoutWidth 
								| id progress layoutHeight padding layoutWidth text 
								| id progress padding text layoutWidth layoutHeight 
								| id progress padding text layoutHeight layoutWidth 
								| id progress padding layoutWidth text layoutHeight 
								| id progress padding layoutWidth layoutHeight text 
								| id progress padding layoutHeight text layoutWidth 
								| id progress padding layoutHeight layoutWidth text 
								| padding text layoutWidth layoutHeight id progress 
								| padding text layoutWidth layoutHeight progress id 
								| padding text layoutWidth id layoutHeight progress 
								| padding text layoutWidth id progress layoutHeight 
								| padding text layoutWidth progress layoutHeight id 
								| padding text layoutWidth progress id layoutHeight 
								| padding text layoutHeight layoutWidth id progress 
								| padding text layoutHeight layoutWidth progress id 
								| padding text layoutHeight id layoutWidth progress 
								| padding text layoutHeight id progress layoutWidth 
								| padding text layoutHeight progress layoutWidth id 
								| padding text layoutHeight progress id layoutWidth 
								| padding text id layoutWidth layoutHeight progress 
								| padding text id layoutWidth progress layoutHeight 
								| padding text id layoutHeight layoutWidth progress 
								| padding text id layoutHeight progress layoutWidth 
								| padding text id progress layoutWidth layoutHeight 
								| padding text id progress layoutHeight layoutWidth 
								| padding text progress layoutWidth layoutHeight id 
								| padding text progress layoutWidth id layoutHeight 
								| padding text progress layoutHeight layoutWidth id 
								| padding text progress layoutHeight id layoutWidth 
								| padding text progress id layoutWidth layoutHeight 
								| padding text progress id layoutHeight layoutWidth 
								| padding layoutWidth text layoutHeight id progress 
								| padding layoutWidth text layoutHeight progress id 
								| padding layoutWidth text id layoutHeight progress 
								| padding layoutWidth text id progress layoutHeight 
								| padding layoutWidth text progress layoutHeight id 
								| padding layoutWidth text progress id layoutHeight 
								| padding layoutWidth layoutHeight text id progress 
								| padding layoutWidth layoutHeight text progress id 
								| padding layoutWidth layoutHeight id text progress 
								| padding layoutWidth layoutHeight id progress text 
								| padding layoutWidth layoutHeight progress text id 
								| padding layoutWidth layoutHeight progress id text 
								| padding layoutWidth id text layoutHeight progress 
								| padding layoutWidth id text progress layoutHeight 
								| padding layoutWidth id layoutHeight text progress 
								| padding layoutWidth id layoutHeight progress text 
								| padding layoutWidth id progress text layoutHeight 
								| padding layoutWidth id progress layoutHeight text 
								| padding layoutWidth progress text layoutHeight id 
								| padding layoutWidth progress text id layoutHeight 
								| padding layoutWidth progress layoutHeight text id 
								| padding layoutWidth progress layoutHeight id text 
								| padding layoutWidth progress id text layoutHeight 
								| padding layoutWidth progress id layoutHeight text 
								| padding layoutHeight text layoutWidth id progress 
								| padding layoutHeight text layoutWidth progress id 
								| padding layoutHeight text id layoutWidth progress 
								| padding layoutHeight text id progress layoutWidth 
								| padding layoutHeight text progress layoutWidth id 
								| padding layoutHeight text progress id layoutWidth 
								| padding layoutHeight layoutWidth text id progress 
								| padding layoutHeight layoutWidth text progress id 
								| padding layoutHeight layoutWidth id text progress 
								| padding layoutHeight layoutWidth id progress text 
								| padding layoutHeight layoutWidth progress text id 
								| padding layoutHeight layoutWidth progress id text 
								| padding layoutHeight id text layoutWidth progress 
								| padding layoutHeight id text progress layoutWidth 
								| padding layoutHeight id layoutWidth text progress 
								| padding layoutHeight id layoutWidth progress text 
								| padding layoutHeight id progress text layoutWidth 
								| padding layoutHeight id progress layoutWidth text 
								| padding layoutHeight progress text layoutWidth id 
								| padding layoutHeight progress text id layoutWidth 
								| padding layoutHeight progress layoutWidth text id 
								| padding layoutHeight progress layoutWidth id text 
								| padding layoutHeight progress id text layoutWidth 
								| padding layoutHeight progress id layoutWidth text 
								| padding id text layoutWidth layoutHeight progress 
								| padding id text layoutWidth progress layoutHeight 
								| padding id text layoutHeight layoutWidth progress 
								| padding id text layoutHeight progress layoutWidth 
								| padding id text progress layoutWidth layoutHeight 
								| padding id text progress layoutHeight layoutWidth 
								| padding id layoutWidth text layoutHeight progress 
								| padding id layoutWidth text progress layoutHeight 
								| padding id layoutWidth layoutHeight text progress 
								| padding id layoutWidth layoutHeight progress text 
								| padding id layoutWidth progress text layoutHeight 
								| padding id layoutWidth progress layoutHeight text 
								| padding id layoutHeight text layoutWidth progress 
								| padding id layoutHeight text progress layoutWidth 
								| padding id layoutHeight layoutWidth text progress 
								| padding id layoutHeight layoutWidth progress text 
								| padding id layoutHeight progress text layoutWidth 
								| padding id layoutHeight progress layoutWidth text 
								| padding id progress text layoutWidth layoutHeight 
								| padding id progress text layoutHeight layoutWidth 
								| padding id progress layoutWidth text layoutHeight 
								| padding id progress layoutWidth layoutHeight text 
								| padding id progress layoutHeight text layoutWidth 
								| padding id progress layoutHeight layoutWidth text 
								| padding progress text layoutWidth layoutHeight id 
								| padding progress text layoutWidth id layoutHeight 
								| padding progress text layoutHeight layoutWidth id 
								| padding progress text layoutHeight id layoutWidth 
								| padding progress text id layoutWidth layoutHeight 
								| padding progress text id layoutHeight layoutWidth 
								| padding progress layoutWidth text layoutHeight id 
								| padding progress layoutWidth text id layoutHeight 
								| padding progress layoutWidth layoutHeight text id 
								| padding progress layoutWidth layoutHeight id text 
								| padding progress layoutWidth id text layoutHeight 
								| padding progress layoutWidth id layoutHeight text 
								| padding progress layoutHeight text layoutWidth id 
								| padding progress layoutHeight text id layoutWidth 
								| padding progress layoutHeight layoutWidth text id 
								| padding progress layoutHeight layoutWidth id text 
								| padding progress layoutHeight id text layoutWidth 
								| padding progress layoutHeight id layoutWidth text 
								| padding progress id text layoutWidth layoutHeight 
								| padding progress id text layoutHeight layoutWidth 
								| padding progress id layoutWidth text layoutHeight 
								| padding progress id layoutWidth layoutHeight text 
								| padding progress id layoutHeight text layoutWidth 
								| padding progress id layoutHeight layoutWidth text 
								| progress text layoutWidth layoutHeight id padding 
								| progress text layoutWidth layoutHeight padding id 
								| progress text layoutWidth id layoutHeight padding 
								| progress text layoutWidth id padding layoutHeight 
								| progress text layoutWidth padding layoutHeight id 
								| progress text layoutWidth padding id layoutHeight 
								| progress text layoutHeight layoutWidth id padding 
								| progress text layoutHeight layoutWidth padding id 
								| progress text layoutHeight id layoutWidth padding 
								| progress text layoutHeight id padding layoutWidth 
								| progress text layoutHeight padding layoutWidth id 
								| progress text layoutHeight padding id layoutWidth 
								| progress text id layoutWidth layoutHeight padding 
								| progress text id layoutWidth padding layoutHeight 
								| progress text id layoutHeight layoutWidth padding 
								| progress text id layoutHeight padding layoutWidth 
								| progress text id padding layoutWidth layoutHeight 
								| progress text id padding layoutHeight layoutWidth 
								| progress text padding layoutWidth layoutHeight id 
								| progress text padding layoutWidth id layoutHeight 
								| progress text padding layoutHeight layoutWidth id 
								| progress text padding layoutHeight id layoutWidth 
								| progress text padding id layoutWidth layoutHeight 
								| progress text padding id layoutHeight layoutWidth 
								| progress layoutWidth text layoutHeight id padding 
								| progress layoutWidth text layoutHeight padding id 
								| progress layoutWidth text id layoutHeight padding 
								| progress layoutWidth text id padding layoutHeight 
								| progress layoutWidth text padding layoutHeight id 
								| progress layoutWidth text padding id layoutHeight 
								| progress layoutWidth layoutHeight text id padding 
								| progress layoutWidth layoutHeight text padding id 
								| progress layoutWidth layoutHeight id text padding 
								| progress layoutWidth layoutHeight id padding text 
								| progress layoutWidth layoutHeight padding text id 
								| progress layoutWidth layoutHeight padding id text 
								| progress layoutWidth id text layoutHeight padding 
								| progress layoutWidth id text padding layoutHeight 
								| progress layoutWidth id layoutHeight text padding 
								| progress layoutWidth id layoutHeight padding text 
								| progress layoutWidth id padding text layoutHeight 
								| progress layoutWidth id padding layoutHeight text 
								| progress layoutWidth padding text layoutHeight id 
								| progress layoutWidth padding text id layoutHeight 
								| progress layoutWidth padding layoutHeight text id 
								| progress layoutWidth padding layoutHeight id text 
								| progress layoutWidth padding id text layoutHeight 
								| progress layoutWidth padding id layoutHeight text 
								| progress layoutHeight text layoutWidth id padding 
								| progress layoutHeight text layoutWidth padding id 
								| progress layoutHeight text id layoutWidth padding 
								| progress layoutHeight text id padding layoutWidth 
								| progress layoutHeight text padding layoutWidth id 
								| progress layoutHeight text padding id layoutWidth 
								| progress layoutHeight layoutWidth text id padding 
								| progress layoutHeight layoutWidth text padding id 
								| progress layoutHeight layoutWidth id text padding 
								| progress layoutHeight layoutWidth id padding text 
								| progress layoutHeight layoutWidth padding text id 
								| progress layoutHeight layoutWidth padding id text 
								| progress layoutHeight id text layoutWidth padding 
								| progress layoutHeight id text padding layoutWidth 
								| progress layoutHeight id layoutWidth text padding 
								| progress layoutHeight id layoutWidth padding text 
								| progress layoutHeight id padding text layoutWidth 
								| progress layoutHeight id padding layoutWidth text 
								| progress layoutHeight padding text layoutWidth id 
								| progress layoutHeight padding text id layoutWidth 
								| progress layoutHeight padding layoutWidth text id 
								| progress layoutHeight padding layoutWidth id text 
								| progress layoutHeight padding id text layoutWidth 
								| progress layoutHeight padding id layoutWidth text 
								| progress id text layoutWidth layoutHeight padding 
								| progress id text layoutWidth padding layoutHeight 
								| progress id text layoutHeight layoutWidth padding 
								| progress id text layoutHeight padding layoutWidth 
								| progress id text padding layoutWidth layoutHeight 
								| progress id text padding layoutHeight layoutWidth 
								| progress id layoutWidth text layoutHeight padding 
								| progress id layoutWidth text padding layoutHeight 
								| progress id layoutWidth layoutHeight text padding 
								| progress id layoutWidth layoutHeight padding text 
								| progress id layoutWidth padding text layoutHeight 
								| progress id layoutWidth padding layoutHeight text 
								| progress id layoutHeight text layoutWidth padding 
								| progress id layoutHeight text padding layoutWidth 
								| progress id layoutHeight layoutWidth text padding 
								| progress id layoutHeight layoutWidth padding text 
								| progress id layoutHeight padding text layoutWidth 
								| progress id layoutHeight padding layoutWidth text 
								| progress id padding text layoutWidth layoutHeight 
								| progress id padding text layoutHeight layoutWidth 
								| progress id padding layoutWidth text layoutHeight 
								| progress id padding layoutWidth layoutHeight text 
								| progress id padding layoutHeight text layoutWidth 
								| progress id padding layoutHeight layoutWidth text 
								| progress padding text layoutWidth layoutHeight id 
								| progress padding text layoutWidth id layoutHeight 
								| progress padding text layoutHeight layoutWidth id 
								| progress padding text layoutHeight id layoutWidth 
								| progress padding text id layoutWidth layoutHeight 
								| progress padding text id layoutHeight layoutWidth 
								| progress padding layoutWidth text layoutHeight id 
								| progress padding layoutWidth text id layoutHeight 
								| progress padding layoutWidth layoutHeight text id 
								| progress padding layoutWidth layoutHeight id text 
								| progress padding layoutWidth id text layoutHeight 
								| progress padding layoutWidth id layoutHeight text 
								| progress padding layoutHeight text layoutWidth id 
								| progress padding layoutHeight text id layoutWidth 
								| progress padding layoutHeight layoutWidth text id 
								| progress padding layoutHeight layoutWidth id text 
								| progress padding layoutHeight id text layoutWidth 
								| progress padding layoutHeight id layoutWidth text 
								| progress padding id text layoutWidth layoutHeight 
								| progress padding id text layoutHeight layoutWidth 
								| progress padding id layoutWidth text layoutHeight 
								| progress padding id layoutWidth layoutHeight text 
								| progress padding id layoutHeight text layoutWidth 
								| progress padding id layoutHeight layoutWidth text 

radioButton:					T_RADIO_BUTTON_S radioButtonAttributes T_END_ONE_LINE_ELEM
imageView:						T_IMAGE_VIEW_S imageViewAttributes T_END_ONE_LINE_ELEM
textView:						T_TEXT_VIEW_S textViewAttributes T_END_ONE_LINE_ELEM
button:							T_BUTTON_S buttonAttributes T_END_ONE_LINE_ELEM
progressBar:					T_PROGRESS_BAR_S progressBarAttributes T_END_ONE_LINE_ELEM

layoutHeight:                   T_ANDROID T_SEMICOLON T_LAYOUT_HEIGHT T_EQUAL T_ALPHANUMERIC_
                                | T_ANDROID T_SEMICOLON T_LAYOUT_HEIGHT T_EQUAL T_ALPHANUMERIC 
                                | T_ANDROID T_SEMICOLON T_LAYOUT_HEIGHT T_EQUAL T_NUMBER
layoutWidth:                    T_ANDROID T_SEMICOLON T_LAYOUT_WIDTH T_EQUAL T_ALPHANUMERIC_
                                | T_ANDROID T_SEMICOLON T_LAYOUT_WIDTH T_EQUAL T_ALPHANUMERIC 
                                | T_ANDROID T_SEMICOLON T_LAYOUT_WIDTH T_EQUAL T_NUMBER 
orientation:                    T_ANDROID T_SEMICOLON T_ORIENTATION T_EQUAL T_ALPHANUMERIC_
id:                             T_ANDROID T_SEMICOLON T_ID T_EQUAL T_ALPHANUMERIC_
                                | T_ANDROID T_SEMICOLON T_ID T_EQUAL T_ALPHANUMERIC
text:                           T_ANDROID T_SEMICOLON T_TEXT T_EQUAL T_VTEXT
textColor:                      T_ANDROID T_SEMICOLON T_TEXT_COLOR T_EQUAL T_ALPHANUMERIC_
source:                         T_ANDROID T_SEMICOLON T_SRC T_EQUAL T_ALPHANUMERIC_
padding:                        T_ANDROID T_SEMICOLON T_PADDING T_EQUAL T_NUMBER
checkedButton:                  T_ANDROID T_SEMICOLON T_CHECKED_BUTTON T_EQUAL T_ALPHANUMERIC_
max:                            T_ANDROID T_SEMICOLON T_MAX T_EQUAL T_NUMBER
progress:                       T_ANDROID T_SEMICOLON T_PROGRESS T_EQUAL T_NUMBER

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

    // Συντακτική Ανάλυση
    yyparse();

    fclose(yyin);
    
    return 0;
}
