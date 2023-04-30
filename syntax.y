%{
    #include <stdio.h>
    #include <stdlib.h>
	#include <string.h>
	#include "extras/hashtbl.h"
	#include "extras/semantic.h"

	#define TRUE 1
	#define FALSE 0

    extern FILE *yyin;
	extern int errorCounter;

    extern int yylex();
    extern void red();
    extern void reset();
    extern void yyerror(const char* error);
	extern void add_id(HASHTBL *hash, char *value, int scope);

	HASHTBL *hash;
	int scope = 0;
	int checkedButtonFound = FALSE;
%}

%define parse.error verbose

%union {
    int     intValue;
    char *  strValue;
}

%token              T_EQUAL                     "="
%token              T_SEMICOLON                 ":"
%token              T_END_ONE_LINE_ELEM         "/>"
%token              T_END_MANY_LINES_ELEM       ">"

%token              T_PROGRESS_BAR_S            "<ProgressBar"
%token              T_TEXT_VIEW_S               "<TextView"
%token              T_RADIO_BUTTON_S            "<RadioButton"
%token              T_RELATIVE_LAYOUT_S         "<RelativeLayout"
%token              T_IMAGE_VIEW_S              "<ImageView"
%token              T_BUTTON_S                  "<Button"
%token              T_LINEAR_LAYOUT_F           "</LinearLayout"
%token              T_RELATIVE_LAYOUT_F         "</RelativeLayout"
%token              T_RADIO_GROUP_F             "</RadioGroup"
%token              T_RADIO_GROUP_S             "<RadioGroup"
%token              T_LINEAR_LAYOUT_S           "<LinearLayout"

%token              T_ANDROID                   "android"  
%token              T_LAYOUT_HEIGHT             "token layout_height"
%token              T_LAYOUT_WIDTH              "token layout_width" 
%token              T_ORIENTATION               "token orientation"
%token              T_ID                        "token id"
%token              T_TEXT                      "token text"
%token              T_SRC                       "token src"
%token              T_PADDING                   "token padding"
%token              T_TEXT_COLOR                "token text_color"
%token              T_CHECKED_BUTTON            "token checked_button"
%token              T_MAX                       "token max"
%token              T_PROGRESS                  "token progress"
%token			 	T_LAYOUT_VALUES             "match_parent or wrap_content"

%token <strValue>   T_ALPHANUMERIC              "alphanumeric"
%token <intValue>   T_NUMBER                    "number"
%token <strValue>   T_VTEXT                     "text"
%token <strValue>   T_ALPHANUMERIC_             "alphanumeric or _"

%token              T_EOF                0		"end of file"

// %type <strValue> program body radioButtonAttributes imageViewAttributes textViewAttributes buttonAttributes progressBarAttributes radioGroupAttributes linearLayoutAttributes relativeLayoutAttributes radioButton imageView textView button progressBar radioGroup linearLayout relativeLayout layoutHeight layoutWidth orientation id text textColor source padding checkedButton max progress
%start program
%%

program:                        linearLayout
							  | relativeLayout
							  | radioButton					{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | imageView 					{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | textView 					{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | button 						{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | progress 					{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | radioGroup 					{ yyerror("Should start with RelativeLayout or LinearLayout"); }
							  | linearLayoutAttributes      { yyerror("Should start with RelativeLayout or LinearLayout"); }
							  ;
body:							{ scope++; } imageView 		{ scope--; } body
							  | { scope++; } textView 		{ scope--; } body
							  | { scope++; } button 		{ scope--; } body
							  | { scope++; } progressBar 	{ scope--; } body
							  | { scope++; } radioGroup 	{ scope--; } body
							  | { scope++; } linearLayout 	{ scope--; } body
							  | { scope++; } relativeLayout { scope--; } body
							  | %empty
							  ;
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
							  | text layoutWidth error                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | text error layoutWidth                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth text error                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth error text                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | error text layoutWidth                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | error layoutWidth text                         { yyerror("layout_height is mandatory"); yyerrok; }
							  | text error layoutHeight                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text layoutHeight error                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error text layoutHeight                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error layoutHeight text                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight text error                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight error text                        { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error layoutWidth layoutHeight                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | error layoutHeight layoutWidth                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | layoutWidth error layoutHeight                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | layoutWidth layoutHeight error                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | layoutHeight error layoutWidth                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | layoutHeight layoutWidth error                 { yyerror("text is mandatory"); 		 	yyerrok; }
							  | text layoutWidth error id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text layoutWidth id error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text error layoutWidth id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text error id layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text id layoutWidth error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text id error layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth text error id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth text id error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth error text id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth error id text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth id text error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | layoutWidth id error text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error text layoutWidth id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error text id layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error layoutWidth text id                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error layoutWidth id text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error id text layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | error id layoutWidth text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id text layoutWidth error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id text error layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id layoutWidth text error                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id layoutWidth error text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id error text layoutWidth                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | id error layoutWidth text                      { yyerror("layout_height is mandatory"); yyerrok; }
							  | text error layoutHeight id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text error id layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text layoutHeight error id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text layoutHeight id error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text id error layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | text id layoutHeight error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error text layoutHeight id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error text id layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error layoutHeight text id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error layoutHeight id text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error id text layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error id layoutHeight text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight text error id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight text id error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight error text id                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight error id text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight id text error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | layoutHeight id error text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id text error layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id text layoutHeight error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id error text layoutHeight                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id error layoutHeight text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id layoutHeight text error                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | id layoutHeight error text                     { yyerror("layout_width is mandatory"); 	yyerrok; }
							  | error layoutWidth layoutHeight id              { yyerror("text is mandatory"); 		yyerrok; }
							  | error layoutWidth id layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | error layoutHeight layoutWidth id              { yyerror("text is mandatory"); 		yyerrok; }
							  | error layoutHeight id layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | error id layoutWidth layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | error id layoutHeight layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth error layoutHeight id              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth error id layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth layoutHeight error id              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth layoutHeight id error              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth id error layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutWidth id layoutHeight error              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight error layoutWidth id              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight error id layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight layoutWidth error id              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight layoutWidth id error              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight id error layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | layoutHeight id layoutWidth error              { yyerror("text is mandatory"); 		yyerrok; }
							  | id error layoutWidth layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | id error layoutHeight layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | id layoutWidth error layoutHeight              { yyerror("text is mandatory"); 		yyerrok; }
							  | id layoutWidth layoutHeight error              { yyerror("text is mandatory"); 		yyerrok; }
							  | id layoutHeight error layoutWidth              { yyerror("text is mandatory"); 		yyerrok; }
							  | id layoutHeight layoutWidth error              { yyerror("text is mandatory"); 	    yyerrok; }
							  ;
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
							  |  source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; } 
							  |  error layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  source layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; } 
							  |  error layoutWidth id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  source layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; } 
							  |  error layoutWidth padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  source layoutWidth error id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source layoutWidth error padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth padding error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth padding id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error padding layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error padding id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source padding error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source padding id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id padding source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id padding error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source padding layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source padding id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id padding source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id padding layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth padding source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth padding error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error padding source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error padding layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source error layoutHeight padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error padding layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error padding id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight padding error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight padding id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source padding layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source padding id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id padding source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id padding layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source padding error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source padding id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id padding source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id padding error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error padding source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error padding layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight padding source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight padding error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id padding 			 { yyerror("android:src is mandatory"); yyerrok; } 
							  |  error layoutWidth layoutHeight padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutWidth id layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutWidth id padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutWidth padding layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutWidth padding id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight id padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight padding layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error layoutHeight padding id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutWidth padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id layoutHeight padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id padding layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error id padding layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutWidth layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutWidth id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutHeight layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding layoutHeight id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding id layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  error padding id layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error id padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error padding layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth error padding id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id error padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id padding error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth id padding layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding error layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding error id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding id error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutWidth padding id layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error id padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error padding layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight error padding id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error padding id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id error padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id padding error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight id padding layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding error layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding error id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding id error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  layoutHeight padding id layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutWidth padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error layoutHeight padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error padding layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id error padding layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth error padding layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth padding error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutWidth padding layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight error padding layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error padding 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth padding error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight padding error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id layoutHeight padding layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding error layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding error layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding layoutWidth error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding layoutWidth layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding layoutHeight error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  id padding layoutHeight layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutWidth layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutWidth id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutHeight layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error layoutHeight id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error id layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding error id layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth error layoutHeight id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth error id layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth id error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutWidth id layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight error layoutWidth id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight error id layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth error id 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth id error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight id error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding layoutHeight id layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id error layoutWidth layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id error layoutHeight layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id layoutWidth error layoutHeight 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id layoutWidth layoutHeight error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id layoutHeight error layoutWidth 			 { yyerror("android:src is mandatory"); yyerrok; }
							  |  padding id layoutHeight layoutWidth error 			 { yyerror("android:src is mandatory"); yyerrok; }
							  ;
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
							  |  text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  text layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  text layoutWidth error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text layoutWidth textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text textColor layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text textColor error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error textColor text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth textColor text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text error textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text textColor error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text textColor layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight textColor text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error textColor text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  source layoutWidth error id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source layoutWidth error textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth textColor error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth textColor id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error textColor layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error textColor id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id textColor layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id textColor error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source textColor id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source textColor error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source textColor id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error textColor source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error textColor id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id textColor source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id textColor error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth textColor id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source textColor layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source textColor id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source id textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source textColor id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth textColor source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth textColor id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id textColor source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id textColor layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error textColor id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source textColor layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source textColor error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source error textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source textColor error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth textColor source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth textColor error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source layoutWidth textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source textColor layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth source textColor 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth textColor source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error textColor source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error textColor layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id textColor error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor source id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor layoutWidth id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor error id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  textColor id error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source error layoutHeight textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error textColor layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error textColor id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight textColor error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight textColor id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id textColor error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id textColor layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source textColor id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source textColor layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source textColor id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight textColor source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight textColor id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id textColor source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id textColor layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error textColor id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source textColor error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source textColor id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source id textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source textColor id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error textColor source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error textColor id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id textColor source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id textColor error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight textColor id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source textColor error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source textColor layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source layoutHeight textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source textColor layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error textColor source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error textColor layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source error textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source textColor error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error source textColor 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error textColor source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight textColor source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight textColor error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id textColor layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor source id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor error id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor layoutHeight id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  textColor id layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id textColor 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth layoutHeight textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth id layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth id textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth textColor layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth textColor id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight textColor layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight textColor id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id textColor layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id textColor layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error textColor id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error textColor layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error textColor id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight textColor error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight textColor id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id textColor error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id textColor layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth textColor id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error textColor layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error textColor id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error textColor id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth textColor error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth textColor id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id textColor error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id textColor layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight textColor id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error textColor layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error textColor layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error textColor layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth textColor error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth textColor layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error textColor layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error textColor 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth textColor error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight textColor error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight textColor layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id textColor layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor error id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutWidth id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor layoutHeight id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  textColor id layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  ;
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
							  |  text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  text layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  text layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  text layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth text padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error text padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error text padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth text padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding text layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding text error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth text error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error text layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth text 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  text error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  text error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  text padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error text padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight text padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight text padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error text padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding text error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding text layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error text layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight text error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error text 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  source layoutWidth error id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  source layoutWidth error padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth id padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth padding error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source layoutWidth padding id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutWidth padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error id padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error padding layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error padding id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source id padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source padding id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source error padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source id padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source padding error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth source padding id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error source padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error padding id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id source padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id padding source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id padding error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth padding id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source layoutWidth padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source id padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source padding layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error source padding id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source id padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth source padding id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth padding id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id source padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id padding source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id padding layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error padding id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source layoutWidth padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source error padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source padding layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id source padding error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source error padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth source padding error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth padding source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth padding error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source layoutWidth padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error source padding layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth source padding 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth padding source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error padding source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error padding layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id padding error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding source id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth source error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth source id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth error id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth id source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding layoutWidth id error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error source layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error source id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth source id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error layoutWidth id source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error id source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding error id layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id source layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id source error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id layoutWidth source error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id layoutWidth error source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id error source layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  padding id error layoutWidth source 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  source error layoutHeight id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  source error layoutHeight padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error id padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error padding layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source error padding id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight error padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight id padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight padding error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source layoutHeight padding id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source id padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  source padding id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source layoutHeight padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source id padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source padding layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error source padding id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight source padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight padding id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id source padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id padding source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id padding layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error padding id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source error padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source id padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source padding error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight source padding id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source id padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error source padding id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error padding id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id source padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id padding source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id padding error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight padding id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source error padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source layoutHeight padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source padding error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id source padding layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source layoutHeight padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error source padding layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error padding source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error padding layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source error padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight source padding error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error source padding 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error padding source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight padding source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight padding error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id padding layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding source id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error source layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error source id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error layoutHeight id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error id source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding error id layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight source error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight source id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error source id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight error id source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight id source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding layoutHeight id error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id source error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id source layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id error source layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id error layoutHeight source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id layoutHeight source error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  padding id layoutHeight error source 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutWidth layoutHeight id padding 			 { yyerror("android:text is mandatory"); yyerrok; } 
							  |  error layoutWidth layoutHeight padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth id layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth id padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth padding layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutWidth padding id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth id padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight layoutWidth padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight id padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight padding layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error layoutHeight padding id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutWidth padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id layoutHeight padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id padding layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error id padding layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  error padding id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight id padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error layoutHeight padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error id padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error padding layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth error padding id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error id padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight error padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight id padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth layoutHeight padding id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id error padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id layoutHeight padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id padding error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth id padding layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutWidth padding id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth id padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error layoutWidth padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error id padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error padding layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight error padding id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error id padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth error padding id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth id padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight layoutWidth padding id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id error padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id layoutWidth padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id padding error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight id padding layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  layoutHeight padding id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutWidth padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error layoutHeight padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error padding layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id error padding layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error layoutHeight padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth error padding layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth layoutHeight padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth padding error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutWidth padding layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error layoutWidth padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight error padding layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth error padding 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight layoutWidth padding error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight padding error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id layoutHeight padding layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  id padding layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutWidth layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutWidth id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutHeight layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error layoutHeight id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error id layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding error id layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth error layoutHeight id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth error id layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth layoutHeight id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth id error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutWidth id layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight error layoutWidth id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight error id layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth error id 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight layoutWidth id error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight id error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding layoutHeight id layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id error layoutWidth layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id error layoutHeight layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id layoutWidth error layoutHeight 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id layoutWidth layoutHeight error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id layoutHeight error layoutWidth 			 { yyerror("android:text is mandatory"); yyerrok; }
							  |  padding id layoutHeight layoutWidth error 			 { yyerror("android:text is mandatory"); yyerrok; }
							  ;
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
							  | layoutWidth layoutHeight max progress 
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
							  |  layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  max error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  progress error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  progress layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error max progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error max id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error progress max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error progress id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max error progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max error id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max progress error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max progress id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max id error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth max id progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress error max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress error id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress max error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress max id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress id error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth progress id max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id max error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id max progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id progress error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id progress max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth max progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth max id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth progress max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth progress id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max layoutWidth progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max layoutWidth id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max progress layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max progress id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max id layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error max id progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress layoutWidth max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress layoutWidth id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress max layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress max id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress id layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error progress id max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id max layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id max progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id progress layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id progress max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth error progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth error id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth progress error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth progress id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth id error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max layoutWidth id progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error layoutWidth progress id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error layoutWidth id progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error progress layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error progress id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error id layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max error id progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max progress id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id layoutWidth error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id layoutWidth progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id error layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id error progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id progress layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  max id progress error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth error max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth error id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth max error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth max id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth id error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress layoutWidth id max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error layoutWidth max id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error layoutWidth id max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error max layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error max id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error id layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress error id max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress max id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id layoutWidth error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id layoutWidth max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id error layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id error max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id max layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  progress id max error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth max error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth max progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth progress error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth progress max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth max progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth progress max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error max layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error max progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error progress layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error progress max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max layoutWidth error progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max layoutWidth progress error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max error layoutWidth progress 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max error progress layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max progress layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id max progress error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress layoutWidth error max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress layoutWidth max error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress error layoutWidth max 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress error max layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress max layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id progress max error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight max progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight max id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight progress max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight progress id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max layoutHeight progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max layoutHeight id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max progress layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max progress id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max id layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error max id progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress layoutHeight max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress layoutHeight id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress max layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress max id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress id layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error progress id max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id max layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id max progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id progress layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id progress max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error max progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error max id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error progress max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error progress id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max error progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max error id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max progress error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max progress id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max id error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight max id progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress error max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress error id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress max error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress max id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress id error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight progress id max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id max error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id max progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id progress error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id progress max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error layoutHeight progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error layoutHeight id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error progress layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error progress id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error id layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max error id progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight error progress id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight error id progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight progress error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight progress id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight id error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max layoutHeight id progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max progress id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id error layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id error progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id layoutHeight error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id layoutHeight progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id progress error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  max id progress layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error layoutHeight max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error layoutHeight id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error max layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error max id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error id layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress error id max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight error max id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight error id max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight max error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight max id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight id error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress layoutHeight id max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress max id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id error layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id error max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id layoutHeight error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id layoutHeight max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id max error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  progress id max layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error max layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error max progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error progress layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error progress max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error max progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error progress max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight max error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight max progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight progress error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight progress max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max error layoutHeight progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max error progress layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max layoutHeight error progress 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max layoutHeight progress error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max progress error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id max progress layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress error layoutHeight max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress error max layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress layoutHeight error max 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress layoutHeight max error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress max error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id progress max layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  ;
radioGroupAttributes:			layoutWidth layoutHeight 
                              | layoutHeight layoutWidth 
                              | layoutWidth layoutHeight id 
                              | layoutWidth id layoutHeight 
                              | layoutHeight layoutWidth id 
                              | layoutHeight id layoutWidth 
                              | id layoutWidth layoutHeight 
                              | id layoutHeight layoutWidth 
                              | layoutWidth layoutHeight checkedButton 
                              | layoutWidth checkedButton layoutHeight 
                              | layoutHeight layoutWidth checkedButton 
                              | layoutHeight checkedButton layoutWidth 
                              | checkedButton layoutWidth layoutHeight 
                              | checkedButton layoutHeight layoutWidth 
                              | layoutWidth layoutHeight id checkedButton 
                              | layoutWidth layoutHeight checkedButton id 
                              | layoutWidth id layoutHeight checkedButton 
                              | layoutWidth id checkedButton layoutHeight 
                              | layoutWidth checkedButton layoutHeight id 
                              | layoutWidth checkedButton id layoutHeight 
                              | layoutHeight layoutWidth id checkedButton 
                              | layoutHeight layoutWidth checkedButton id 
                              | layoutHeight id layoutWidth checkedButton 
                              | layoutHeight id checkedButton layoutWidth 
                              | layoutHeight checkedButton layoutWidth id 
                              | layoutHeight checkedButton id layoutWidth 
                              | id layoutWidth layoutHeight checkedButton 
                              | id layoutWidth checkedButton layoutHeight 
                              | id layoutHeight layoutWidth checkedButton 
                              | id layoutHeight checkedButton layoutWidth 
                              | id checkedButton layoutWidth layoutHeight 
                              | id checkedButton layoutHeight layoutWidth 
                              | checkedButton layoutWidth layoutHeight id 
                              | checkedButton layoutWidth id layoutHeight 
                              | checkedButton layoutHeight layoutWidth id 
                              | checkedButton layoutHeight id layoutWidth 
                              | checkedButton id layoutWidth layoutHeight 
                              | checkedButton id layoutHeight layoutWidth
							  |  layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error checkedButton id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error id checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth checkedButton error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth checkedButton id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id checkedButton error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth checkedButton id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error checkedButton layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error checkedButton id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id checkedButton layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  checkedButton id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth checkedButton error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth checkedButton 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error checkedButton layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id checkedButton layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id checkedButton error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight checkedButton id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight id checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error checkedButton layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error checkedButton id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id checkedButton layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error checkedButton id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight checkedButton error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight checkedButton id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id checkedButton error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  checkedButton id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error checkedButton layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error checkedButton 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight checkedButton error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id checkedButton error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id checkedButton layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  ;
linearLayoutAttributes:			layoutWidth layoutHeight 
                              | layoutHeight layoutWidth 
                              | layoutWidth layoutHeight id 
                              | layoutWidth id layoutHeight 
                              | layoutHeight layoutWidth id 
                              | layoutHeight id layoutWidth 
                              | id layoutWidth layoutHeight 
                              | id layoutHeight layoutWidth 
                              | layoutWidth layoutHeight orientation 
                              | layoutWidth orientation layoutHeight 
                              | layoutHeight layoutWidth orientation 
                              | layoutHeight orientation layoutWidth 
                              | orientation layoutWidth layoutHeight 
                              | orientation layoutHeight layoutWidth 
                              | layoutWidth layoutHeight id orientation 
                              | layoutWidth layoutHeight orientation id 
                              | layoutWidth id layoutHeight orientation 
                              | layoutWidth id orientation layoutHeight 
                              | layoutWidth orientation layoutHeight id 
                              | layoutWidth orientation id layoutHeight 
                              | layoutHeight layoutWidth id orientation 
                              | layoutHeight layoutWidth orientation id 
                              | layoutHeight id layoutWidth orientation 
                              | layoutHeight id orientation layoutWidth 
                              | layoutHeight orientation layoutWidth id 
                              | layoutHeight orientation id layoutWidth 
                              | id layoutWidth layoutHeight orientation 
                              | id layoutWidth orientation layoutHeight 
                              | id layoutHeight layoutWidth orientation 
                              | id layoutHeight orientation layoutWidth 
                              | id orientation layoutWidth layoutHeight 
                              | id orientation layoutHeight layoutWidth 
                              | orientation layoutWidth layoutHeight id 
                              | orientation layoutWidth id layoutHeight 
                              | orientation layoutHeight layoutWidth id 
                              | orientation layoutHeight id layoutWidth 
                              | orientation id layoutWidth layoutHeight 
                              | orientation id layoutHeight layoutWidth
							  |  layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutWidth error orientation id 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  layoutWidth error id orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth orientation error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth orientation id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id orientation error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth orientation id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error orientation layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error orientation id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id orientation layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  orientation id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth error orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id layoutWidth orientation error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutWidth orientation 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error orientation layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id orientation layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id orientation error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight orientation id 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  error layoutHeight id orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error orientation layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error orientation id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id orientation layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error orientation id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight orientation error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight orientation id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id orientation error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  orientation id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error layoutHeight orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id error orientation layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight error orientation 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutHeight orientation error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id orientation error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id orientation layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }  
							  ;
relativeLayoutAttributes:		layoutWidth layoutHeight 
                              | layoutHeight layoutWidth 
                              | layoutWidth layoutHeight id 
                              | layoutWidth id layoutHeight 
                              | layoutHeight layoutWidth id 
                              | layoutHeight id layoutWidth 
                              | id layoutWidth layoutHeight 
                              | id layoutHeight layoutWidth 
							  |  layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  id layoutWidth error 			 { yyerror("android:layout_height is mandatory"); yyerrok; } 
							  |  id error layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth id error 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  layoutWidth error id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error id layoutWidth 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  error layoutWidth id 			 { yyerror("android:layout_height is mandatory"); yyerrok; }
							  |  id error layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; } 
							  |  id layoutHeight error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error id layoutHeight 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  error layoutHeight id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight id error 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  |  layoutHeight error id 			 { yyerror("android:layout_width is mandatory"); yyerrok; }
							  ;
radioButton:					T_RADIO_BUTTON_S radioButtonAttributes T_END_ONE_LINE_ELEM { check_radioGroup_checkedButton(hash, scope, &checkedButtonFound); } radioButton
							  | %empty
							  ;
imageView:						T_IMAGE_VIEW_S imageViewAttributes T_END_ONE_LINE_ELEM
							  ;
textView:						T_TEXT_VIEW_S textViewAttributes T_END_ONE_LINE_ELEM
							  ;
button:							T_BUTTON_S buttonAttributes T_END_ONE_LINE_ELEM
							  ;
progressBar:					T_PROGRESS_BAR_S progressBarAttributes T_END_ONE_LINE_ELEM		{ check_progress(hash, scope); }
							  ;
radioGroup:						T_RADIO_GROUP_S { checkedButtonFound = FALSE; } radioGroupAttributes T_END_MANY_LINES_ELEM radioButton T_RADIO_GROUP_F T_END_MANY_LINES_ELEM { if(!checkedButtonFound) yyerror("The value of checked_button should exists in radioButton inside radioGroup"); }
							  ;
linearLayout:					T_LINEAR_LAYOUT_S linearLayoutAttributes T_END_MANY_LINES_ELEM body T_LINEAR_LAYOUT_F T_END_MANY_LINES_ELEM
							  ;
relativeLayout:					T_RELATIVE_LAYOUT_S relativeLayoutAttributes T_END_ONE_LINE_ELEM
							  | T_RELATIVE_LAYOUT_S relativeLayoutAttributes T_END_MANY_LINES_ELEM body T_RELATIVE_LAYOUT_F T_END_MANY_LINES_ELEM
							  ;
layoutHeight:                   T_ANDROID T_SEMICOLON T_LAYOUT_HEIGHT T_EQUAL T_LAYOUT_VALUES
                              | T_ANDROID T_SEMICOLON T_LAYOUT_HEIGHT T_EQUAL T_NUMBER
							  ;
layoutWidth:                    T_ANDROID T_SEMICOLON T_LAYOUT_WIDTH T_EQUAL T_LAYOUT_VALUES
                              | T_ANDROID T_SEMICOLON T_LAYOUT_WIDTH T_EQUAL T_NUMBER 
							  ;
orientation:                    T_ANDROID T_SEMICOLON T_ORIENTATION T_EQUAL T_ALPHANUMERIC_
							  | T_ANDROID T_SEMICOLON T_ORIENTATION T_EQUAL T_ALPHANUMERIC
							  ;
id:                             T_ANDROID T_SEMICOLON T_ID T_EQUAL T_ALPHANUMERIC_		{ add_id(hash, $5, scope); }
                              | T_ANDROID T_SEMICOLON T_ID T_EQUAL T_ALPHANUMERIC		{ add_id(hash, $5, scope); }
							  ;
text:                           T_ANDROID T_SEMICOLON T_TEXT T_EQUAL T_VTEXT
							  | T_ANDROID T_SEMICOLON T_TEXT T_EQUAL T_ALPHANUMERIC
							  | T_ANDROID T_SEMICOLON T_TEXT T_EQUAL T_ALPHANUMERIC_
							  | T_ANDROID T_SEMICOLON T_TEXT T_EQUAL T_NUMBER
							  ;
textColor:                      T_ANDROID T_SEMICOLON T_TEXT_COLOR T_EQUAL T_ALPHANUMERIC_
							  | T_ANDROID T_SEMICOLON T_TEXT_COLOR T_EQUAL T_ALPHANUMERIC
							  ;
source:                         T_ANDROID T_SEMICOLON T_SRC T_EQUAL T_ALPHANUMERIC_
							  | T_ANDROID T_SEMICOLON T_SRC T_EQUAL T_ALPHANUMERIC
							  ;
padding:                        T_ANDROID T_SEMICOLON T_PADDING T_EQUAL T_NUMBER
							  ;
checkedButton:                  T_ANDROID T_SEMICOLON T_CHECKED_BUTTON T_EQUAL T_ALPHANUMERIC_ { checkedButton(hash, $5, scope); }
							  | T_ANDROID T_SEMICOLON T_CHECKED_BUTTON T_EQUAL T_ALPHANUMERIC  { checkedButton(hash, $5, scope); }
							  ;
max:                            T_ANDROID T_SEMICOLON T_MAX T_EQUAL T_NUMBER				{ add_max(hash, $5, scope); }
							  ;
progress:                       T_ANDROID T_SEMICOLON T_PROGRESS T_EQUAL T_NUMBER			{ add_progress(hash, $5, scope); }
							  ;


%%


int main(int argc, char* argv[])
{
	char c;
	hash = hashtbl_create(10, NULL);
    
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

	if(!errorCounter){
		printf("No errors found!\n\n");
		printf("The given code is:\n");
		printf("-------------------------\n");
		fseek(yyin, 0, SEEK_SET);
		c = fgetc(yyin);
    	while (c != EOF)
    	{
        	printf ("%c", c);
        	c = fgetc(yyin);
    	}
		printf("\n");
	}

    fclose(yyin);
    hashtbl_destroy(hash);

    return 0;
}
