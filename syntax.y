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
	int radioButton_counter = 0;
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
%token 				T_MAX_CHILDREN				"android:max_children"

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
radioButtonAttributes:								layoutHeight layoutWidth text
                      								| layoutHeight text layoutWidth
                      								| layoutWidth layoutHeight text
                      								| layoutWidth text layoutHeight
                      								| text layoutHeight layoutWidth
                      								| text layoutWidth layoutHeight
                      								| layoutHeight layoutWidth text id
                      								| layoutHeight layoutWidth id text
                      								| layoutHeight text layoutWidth id
                      								| layoutHeight text id layoutWidth
                      								| layoutHeight id layoutWidth text
                      								| layoutHeight id text layoutWidth
                      								| layoutWidth layoutHeight text id
                      								| layoutWidth layoutHeight id text
                      								| layoutWidth text layoutHeight id
                      								| layoutWidth text id layoutHeight
                      								| layoutWidth id layoutHeight text
                      								| layoutWidth id text layoutHeight
                      								| text layoutHeight layoutWidth id
                      								| text layoutHeight id layoutWidth
                      								| text layoutWidth layoutHeight id
                      								| text layoutWidth id layoutHeight
                      								| text id layoutHeight layoutWidth
                      								| text id layoutWidth layoutHeight
                      								| id layoutHeight layoutWidth text
                      								| id layoutHeight text layoutWidth
                      								| id layoutWidth layoutHeight text
                      								| id layoutWidth text layoutHeight
                      								| id text layoutHeight layoutWidth
                      								| id text layoutWidth layoutHeight
                      							    |  error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error text layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error text id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth text error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth text id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  text id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight text error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight text id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error text layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error text id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  text id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight layoutWidth error id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight layoutWidth id error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight error layoutWidth id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight id layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth layoutHeight error id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth layoutHeight id error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth error layoutHeight id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth id layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutHeight layoutWidth id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutWidth layoutHeight id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id layoutHeight layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id layoutWidth layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
							  ;
imageViewAttributes:								layoutHeight layoutWidth source
                    								| layoutHeight source layoutWidth
                    								| layoutWidth layoutHeight source
                    								| layoutWidth source layoutHeight
                    								| source layoutHeight layoutWidth
                    								| source layoutWidth layoutHeight
                    								| layoutHeight layoutWidth source id
                    								| layoutHeight layoutWidth id source
                    								| layoutHeight source layoutWidth id
                    								| layoutHeight source id layoutWidth
                    								| layoutHeight id layoutWidth source
                    								| layoutHeight id source layoutWidth
                    								| layoutWidth layoutHeight source id
                    								| layoutWidth layoutHeight id source
                    								| layoutWidth source layoutHeight id
                    								| layoutWidth source id layoutHeight
                    								| layoutWidth id layoutHeight source
                    								| layoutWidth id source layoutHeight
                    								| source layoutHeight layoutWidth id
                    								| source layoutHeight id layoutWidth
                    								| source layoutWidth layoutHeight id
                    								| source layoutWidth id layoutHeight
                    								| source id layoutHeight layoutWidth
                    								| source id layoutWidth layoutHeight
                    								| id layoutHeight layoutWidth source
                    								| id layoutHeight source layoutWidth
                    								| id layoutWidth layoutHeight source
                    								| id layoutWidth source layoutHeight
                    								| id source layoutHeight layoutWidth
                    								| id source layoutWidth layoutHeight
                    								| layoutHeight layoutWidth source padding
                    								| layoutHeight layoutWidth padding source
                    								| layoutHeight source layoutWidth padding
                    								| layoutHeight source padding layoutWidth
                    								| layoutHeight padding layoutWidth source
                    								| layoutHeight padding source layoutWidth
                    								| layoutWidth layoutHeight source padding
                    								| layoutWidth layoutHeight padding source
                    								| layoutWidth source layoutHeight padding
                    								| layoutWidth source padding layoutHeight
                    								| layoutWidth padding layoutHeight source
                    								| layoutWidth padding source layoutHeight
                    								| source layoutHeight layoutWidth padding
                    								| source layoutHeight padding layoutWidth
                    								| source layoutWidth layoutHeight padding
                    								| source layoutWidth padding layoutHeight
                    								| source padding layoutHeight layoutWidth
                    								| source padding layoutWidth layoutHeight
                    								| padding layoutHeight layoutWidth source
                    								| padding layoutHeight source layoutWidth
                    								| padding layoutWidth layoutHeight source
                    								| padding layoutWidth source layoutHeight
                    								| padding source layoutHeight layoutWidth
                    								| padding source layoutWidth layoutHeight
                    							    |  error layoutWidth source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error source layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth error source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth source error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error layoutWidth source id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error layoutWidth id source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error source layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error source id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error id layoutWidth source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error id source layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth error source id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth error id source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth source error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth source id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth id error source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth id source error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id error layoutWidth source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id error source layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id layoutWidth error source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id layoutWidth source error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id source error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  id source layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error layoutWidth source padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error layoutWidth padding source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error source layoutWidth padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error source padding layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error padding layoutWidth source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  error padding source layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth error source padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth error padding source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth source error padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth source padding error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth padding error source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutWidth padding source error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source error layoutWidth padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source error padding layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source layoutWidth error padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source layoutWidth padding error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source padding error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  source padding layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding error layoutWidth source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding error source layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding layoutWidth error source 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding layoutWidth source error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding source error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  padding source layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                    							    |  layoutHeight error source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight source error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error layoutHeight source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error source layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight error id source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight error source id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight id error source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight id source error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight source error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight source id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error layoutHeight id source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error layoutHeight source id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error id layoutHeight source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error id source layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error source layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error source id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id layoutHeight error source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id layoutHeight source error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id error layoutHeight source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id error source layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id source layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  id source error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error layoutHeight source padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error layoutHeight padding source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error source layoutHeight padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error source padding layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error padding layoutHeight source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  error padding source layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight error source padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight error padding source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight source error padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight source padding error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight padding error source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight padding source error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source error layoutHeight padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source error padding layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source layoutHeight error padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source layoutHeight padding error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source padding error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  source padding layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding error layoutHeight source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding error source layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding layoutHeight error source 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding layoutHeight source error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding source error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  padding source layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                    							    |  layoutHeight layoutWidth error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight error layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth layoutHeight error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth error layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutHeight layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutWidth layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight layoutWidth error id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight layoutWidth id error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight error layoutWidth id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight error id layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight id layoutWidth error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight id error layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth layoutHeight error id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth layoutHeight id error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth error layoutHeight id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth error id layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth id layoutHeight error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth id error layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutHeight layoutWidth id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutHeight id layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutWidth layoutHeight id 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutWidth id layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error id layoutHeight layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error id layoutWidth layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id layoutHeight layoutWidth error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id layoutHeight error layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id layoutWidth layoutHeight error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id layoutWidth error layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id error layoutHeight layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  id error layoutWidth layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight layoutWidth error padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight layoutWidth padding error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight error layoutWidth padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight error padding layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight padding layoutWidth error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutHeight padding error layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth layoutHeight error padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth layoutHeight padding error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth error layoutHeight padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth error padding layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth padding layoutHeight error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  layoutWidth padding error layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutHeight layoutWidth padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutHeight padding layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutWidth layoutHeight padding 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error layoutWidth padding layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error padding layoutHeight layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  error padding layoutWidth layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding layoutHeight layoutWidth error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding layoutHeight error layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding layoutWidth layoutHeight error 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding layoutWidth error layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding error layoutHeight layoutWidth 				 { yyerror("android:padding is mandatory!"); yyerrok;}
                    							    |  padding error layoutWidth layoutHeight 				 { yyerror("android:padding is mandatory!"); yyerrok;}

							    ;
textViewAttributes:								layoutHeight layoutWidth text
                   								| layoutHeight text layoutWidth
                   								| layoutWidth layoutHeight text
                   								| layoutWidth text layoutHeight
                   								| text layoutHeight layoutWidth
                   								| text layoutWidth layoutHeight
                   								| layoutHeight layoutWidth text id
                   								| layoutHeight layoutWidth id text
                   								| layoutHeight text layoutWidth id
                   								| layoutHeight text id layoutWidth
                   								| layoutHeight id layoutWidth text
                   								| layoutHeight id text layoutWidth
                   								| layoutWidth layoutHeight text id
                   								| layoutWidth layoutHeight id text
                   								| layoutWidth text layoutHeight id
                   								| layoutWidth text id layoutHeight
                   								| layoutWidth id layoutHeight text
                   								| layoutWidth id text layoutHeight
                   								| text layoutHeight layoutWidth id
                   								| text layoutHeight id layoutWidth
                   								| text layoutWidth layoutHeight id
                   								| text layoutWidth id layoutHeight
                   								| text id layoutHeight layoutWidth
                   								| text id layoutWidth layoutHeight
                   								| id layoutHeight layoutWidth text
                   								| id layoutHeight text layoutWidth
                   								| id layoutWidth layoutHeight text
                   								| id layoutWidth text layoutHeight
                   								| id text layoutHeight layoutWidth
                   								| id text layoutWidth layoutHeight
                   								| layoutHeight layoutWidth text textColor
                   								| layoutHeight layoutWidth textColor text
                   								| layoutHeight text layoutWidth textColor
                   								| layoutHeight text textColor layoutWidth
                   								| layoutHeight textColor layoutWidth text
                   								| layoutHeight textColor text layoutWidth
                   								| layoutWidth layoutHeight text textColor
                   								| layoutWidth layoutHeight textColor text
                   								| layoutWidth text layoutHeight textColor
                   								| layoutWidth text textColor layoutHeight
                   								| layoutWidth textColor layoutHeight text
                   								| layoutWidth textColor text layoutHeight
                   								| text layoutHeight layoutWidth textColor
                   								| text layoutHeight textColor layoutWidth
                   								| text layoutWidth layoutHeight textColor
                   								| text layoutWidth textColor layoutHeight
                   								| text textColor layoutHeight layoutWidth
                   								| text textColor layoutWidth layoutHeight
                   								| textColor layoutHeight layoutWidth text
                   								| textColor layoutHeight text layoutWidth
                   								| textColor layoutWidth layoutHeight text
                   								| textColor layoutWidth text layoutHeight
                   								| textColor text layoutHeight layoutWidth
                   								| textColor text layoutWidth layoutHeight
                   								| layoutHeight layoutWidth text textColor id
                   								| layoutHeight layoutWidth text id textColor
                   								| layoutHeight layoutWidth textColor text id
                   								| layoutHeight layoutWidth textColor id text
                   								| layoutHeight layoutWidth id text textColor
                   								| layoutHeight layoutWidth id textColor text
                   								| layoutHeight text layoutWidth textColor id
                   								| layoutHeight text layoutWidth id textColor
                   								| layoutHeight text textColor layoutWidth id
                   								| layoutHeight text textColor id layoutWidth
                   								| layoutHeight text id layoutWidth textColor
                   								| layoutHeight text id textColor layoutWidth
                   								| layoutHeight textColor layoutWidth text id
                   								| layoutHeight textColor layoutWidth id text
                   								| layoutHeight textColor text layoutWidth id
                   								| layoutHeight textColor text id layoutWidth
                   								| layoutHeight textColor id layoutWidth text
                   								| layoutHeight textColor id text layoutWidth
                   								| layoutHeight id layoutWidth text textColor
                   								| layoutHeight id layoutWidth textColor text
                   								| layoutHeight id text layoutWidth textColor
                   								| layoutHeight id text textColor layoutWidth
                   								| layoutHeight id textColor layoutWidth text
                   								| layoutHeight id textColor text layoutWidth
                   								| layoutWidth layoutHeight text textColor id
                   								| layoutWidth layoutHeight text id textColor
                   								| layoutWidth layoutHeight textColor text id
                   								| layoutWidth layoutHeight textColor id text
                   								| layoutWidth layoutHeight id text textColor
                   								| layoutWidth layoutHeight id textColor text
                   								| layoutWidth text layoutHeight textColor id
                   								| layoutWidth text layoutHeight id textColor
                   								| layoutWidth text textColor layoutHeight id
                   								| layoutWidth text textColor id layoutHeight
                   								| layoutWidth text id layoutHeight textColor
                   								| layoutWidth text id textColor layoutHeight
                   								| layoutWidth textColor layoutHeight text id
                   								| layoutWidth textColor layoutHeight id text
                   								| layoutWidth textColor text layoutHeight id
                   								| layoutWidth textColor text id layoutHeight
                   								| layoutWidth textColor id layoutHeight text
                   								| layoutWidth textColor id text layoutHeight
                   								| layoutWidth id layoutHeight text textColor
                   								| layoutWidth id layoutHeight textColor text
                   								| layoutWidth id text layoutHeight textColor
                   								| layoutWidth id text textColor layoutHeight
                   								| layoutWidth id textColor layoutHeight text
                   								| layoutWidth id textColor text layoutHeight
                   								| text layoutHeight layoutWidth textColor id
                   								| text layoutHeight layoutWidth id textColor
                   								| text layoutHeight textColor layoutWidth id
                   								| text layoutHeight textColor id layoutWidth
                   								| text layoutHeight id layoutWidth textColor
                   								| text layoutHeight id textColor layoutWidth
                   								| text layoutWidth layoutHeight textColor id
                   								| text layoutWidth layoutHeight id textColor
                   								| text layoutWidth textColor layoutHeight id
                   								| text layoutWidth textColor id layoutHeight
                   								| text layoutWidth id layoutHeight textColor
                   								| text layoutWidth id textColor layoutHeight
                   								| text textColor layoutHeight layoutWidth id
                   								| text textColor layoutHeight id layoutWidth
                   								| text textColor layoutWidth layoutHeight id
                   								| text textColor layoutWidth id layoutHeight
                   								| text textColor id layoutHeight layoutWidth
                   								| text textColor id layoutWidth layoutHeight
                   								| text id layoutHeight layoutWidth textColor
                   								| text id layoutHeight textColor layoutWidth
                   								| text id layoutWidth layoutHeight textColor
                   								| text id layoutWidth textColor layoutHeight
                   								| text id textColor layoutHeight layoutWidth
                   								| text id textColor layoutWidth layoutHeight
                   								| textColor layoutHeight layoutWidth text id
                   								| textColor layoutHeight layoutWidth id text
                   								| textColor layoutHeight text layoutWidth id
                   								| textColor layoutHeight text id layoutWidth
                   								| textColor layoutHeight id layoutWidth text
                   								| textColor layoutHeight id text layoutWidth
                   								| textColor layoutWidth layoutHeight text id
                   								| textColor layoutWidth layoutHeight id text
                   								| textColor layoutWidth text layoutHeight id
                   								| textColor layoutWidth text id layoutHeight
                   								| textColor layoutWidth id layoutHeight text
                   								| textColor layoutWidth id text layoutHeight
                   								| textColor text layoutHeight layoutWidth id
                   								| textColor text layoutHeight id layoutWidth
                   								| textColor text layoutWidth layoutHeight id
                   								| textColor text layoutWidth id layoutHeight
                   								| textColor text id layoutHeight layoutWidth
                   								| textColor text id layoutWidth layoutHeight
                   								| textColor id layoutHeight layoutWidth text
                   								| textColor id layoutHeight text layoutWidth
                   								| textColor id layoutWidth layoutHeight text
                   								| textColor id layoutWidth text layoutHeight
                   								| textColor id text layoutHeight layoutWidth
                   								| textColor id text layoutWidth layoutHeight
                   								| id layoutHeight layoutWidth text textColor
                   								| id layoutHeight layoutWidth textColor text
                   								| id layoutHeight text layoutWidth textColor
                   								| id layoutHeight text textColor layoutWidth
                   								| id layoutHeight textColor layoutWidth text
                   								| id layoutHeight textColor text layoutWidth
                   								| id layoutWidth layoutHeight text textColor
                   								| id layoutWidth layoutHeight textColor text
                   								| id layoutWidth text layoutHeight textColor
                   								| id layoutWidth text textColor layoutHeight
                   								| id layoutWidth textColor layoutHeight text
                   								| id layoutWidth textColor text layoutHeight
                   								| id text layoutHeight layoutWidth textColor
                   								| id text layoutHeight textColor layoutWidth
                   								| id text layoutWidth layoutHeight textColor
                   								| id text layoutWidth textColor layoutHeight
                   								| id text textColor layoutHeight layoutWidth
                   								| id text textColor layoutWidth layoutHeight
                   								| id textColor layoutHeight layoutWidth text
                   								| id textColor layoutHeight text layoutWidth
                   								| id textColor layoutWidth layoutHeight text
                   								| id textColor layoutWidth text layoutHeight
                   								| id textColor text layoutHeight layoutWidth
                   								| id textColor text layoutWidth layoutHeight
                   							    |  error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth text textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth text id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth textColor text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth textColor id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth id text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error layoutWidth id textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text layoutWidth textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text layoutWidth id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text textColor layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text textColor id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text id layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error text id textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor layoutWidth text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor layoutWidth id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor text layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor text id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor id layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error textColor id text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id layoutWidth text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id layoutWidth textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id text layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id text textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id textColor layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  error id textColor text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error text textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error text id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error textColor text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error textColor id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error id text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth error id textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text error textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text error id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text textColor error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text textColor id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text id error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth text id textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor error text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor error id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor text error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor text id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor id error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth textColor id text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id error text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id error textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id text error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id text textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id textColor error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutWidth id textColor text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error layoutWidth textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error layoutWidth id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error textColor layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error textColor id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error id layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text error id textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth error textColor id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth error id textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth textColor error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth textColor id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth id error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text layoutWidth id textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text textColor id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id error layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id error textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id layoutWidth error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id layoutWidth textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id textColor error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  text id textColor layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error layoutWidth text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error layoutWidth id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error text layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error text id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error id layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor error id text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth error text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth error id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth text error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth text id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth id error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor layoutWidth id text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor text id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  textColor id text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error layoutWidth text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error layoutWidth textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error text layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error text textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error textColor layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id error textColor text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth error text textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth error textColor text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth text error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth text textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth textColor error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id layoutWidth textColor text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text error layoutWidth textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text error textColor layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text layoutWidth error textColor 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text layoutWidth textColor error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text textColor error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id text textColor layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  id textColor text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                   							    |  layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error text textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error text id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error textColor text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error textColor id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error id text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight error id textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text error textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text error id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text textColor error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text textColor id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text id error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight text id textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor error text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor error id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor text error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor text id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor id error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight textColor id text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id error text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id error textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id text error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id text textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id textColor error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  layoutHeight id textColor text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight text textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight text id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight textColor text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight textColor id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight id text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error layoutHeight id textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text layoutHeight textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text layoutHeight id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text textColor layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text textColor id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text id layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error text id textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor layoutHeight text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor layoutHeight id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor text layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor text id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor id layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error textColor id text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id layoutHeight text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id layoutHeight textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id text layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id text textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id textColor layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  error id textColor text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight error textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight error id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight textColor error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight textColor id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight id error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text layoutHeight id textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error layoutHeight textColor id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error layoutHeight id textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error textColor layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error textColor id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error id layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text error id textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text textColor id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id layoutHeight error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id layoutHeight textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id error layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id error textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id textColor layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  text id textColor error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight error text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight error id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight text error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight text id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight id error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor layoutHeight id text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error layoutHeight text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error layoutHeight id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error text layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error text id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error id layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor error id text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor text id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  textColor id text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight error text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight error textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight text error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight text textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight textColor error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id layoutHeight textColor text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error layoutHeight text textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error layoutHeight textColor text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error text layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error text textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error textColor layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id error textColor text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text layoutHeight error textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text layoutHeight textColor error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text error layoutHeight textColor 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text error textColor layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text textColor layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id text textColor error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                   							    |  id textColor text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                                                ;
buttonAttributes:								layoutHeight layoutWidth text
                 								| layoutHeight text layoutWidth
                 								| layoutWidth layoutHeight text
                 								| layoutWidth text layoutHeight
                 								| text layoutHeight layoutWidth
                 								| text layoutWidth layoutHeight
                 								| layoutHeight layoutWidth text id
                 								| layoutHeight layoutWidth id text
                 								| layoutHeight text layoutWidth id
                 								| layoutHeight text id layoutWidth
                 								| layoutHeight id layoutWidth text
                 								| layoutHeight id text layoutWidth
                 								| layoutWidth layoutHeight text id
                 								| layoutWidth layoutHeight id text
                 								| layoutWidth text layoutHeight id
                 								| layoutWidth text id layoutHeight
                 								| layoutWidth id layoutHeight text
                 								| layoutWidth id text layoutHeight
                 								| text layoutHeight layoutWidth id
                 								| text layoutHeight id layoutWidth
                 								| text layoutWidth layoutHeight id
                 								| text layoutWidth id layoutHeight
                 								| text id layoutHeight layoutWidth
                 								| text id layoutWidth layoutHeight
                 								| id layoutHeight layoutWidth text
                 								| id layoutHeight text layoutWidth
                 								| id layoutWidth layoutHeight text
                 								| id layoutWidth text layoutHeight
                 								| id text layoutHeight layoutWidth
                 								| id text layoutWidth layoutHeight
                 								| layoutHeight layoutWidth text padding
                 								| layoutHeight layoutWidth padding text
                 								| layoutHeight text layoutWidth padding
                 								| layoutHeight text padding layoutWidth
                 								| layoutHeight padding layoutWidth text
                 								| layoutHeight padding text layoutWidth
                 								| layoutWidth layoutHeight text padding
                 								| layoutWidth layoutHeight padding text
                 								| layoutWidth text layoutHeight padding
                 								| layoutWidth text padding layoutHeight
                 								| layoutWidth padding layoutHeight text
                 								| layoutWidth padding text layoutHeight
                 								| text layoutHeight layoutWidth padding
                 								| text layoutHeight padding layoutWidth
                 								| text layoutWidth layoutHeight padding
                 								| text layoutWidth padding layoutHeight
                 								| text padding layoutHeight layoutWidth
                 								| text padding layoutWidth layoutHeight
                 								| padding layoutHeight layoutWidth text
                 								| padding layoutHeight text layoutWidth
                 								| padding layoutWidth layoutHeight text
                 								| padding layoutWidth text layoutHeight
                 								| padding text layoutHeight layoutWidth
                 								| padding text layoutWidth layoutHeight
                 							    |  error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error layoutWidth text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error layoutWidth id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error text layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error text id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error id layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error id text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth error text id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth error id text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth text error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth text id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth id error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth id text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  id text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error layoutWidth text padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error layoutWidth padding text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error text layoutWidth padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error text padding layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error padding layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  error padding text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth error text padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth error padding text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth text error padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth text padding error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth padding error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutWidth padding text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text error layoutWidth padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text error padding layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text layoutWidth error padding 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text layoutWidth padding error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text padding error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  text padding layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding error layoutWidth text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding error text layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding layoutWidth error text 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding layoutWidth text error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding text error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  padding text layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                 							    |  layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight error id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight error text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight id error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight id text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight text error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight text id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error layoutHeight id text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error layoutHeight text id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error id layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error id text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error text layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error text id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  id text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error layoutHeight text padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error layoutHeight padding text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error text layoutHeight padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error text padding layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error padding layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  error padding text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight error text padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight error padding text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight text error padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight text padding error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight padding error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight padding text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text error layoutHeight padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text error padding layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text layoutHeight error padding 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text layoutHeight padding error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text padding error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  text padding layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding error layoutHeight text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding error text layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding layoutHeight error text 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding layoutHeight text error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding text error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  padding text layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                 							    |  layoutHeight layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight layoutWidth error id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight layoutWidth id error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight error layoutWidth id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight error id layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight id layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight id error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth layoutHeight error id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth layoutHeight id error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth error layoutHeight id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth error id layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth id layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth id error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutHeight layoutWidth id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutHeight id layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutWidth layoutHeight id 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutWidth id layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error id layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error id layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id layoutHeight layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id layoutHeight error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id layoutWidth layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id layoutWidth error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id error layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  id error layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight layoutWidth error padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight layoutWidth padding error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight error layoutWidth padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight error padding layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight padding layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutHeight padding error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth layoutHeight error padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth layoutHeight padding error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth error layoutHeight padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth error padding layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth padding layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  layoutWidth padding error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutHeight layoutWidth padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutHeight padding layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutWidth layoutHeight padding 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error layoutWidth padding layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error padding layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  error padding layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding layoutHeight layoutWidth error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding layoutHeight error layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding layoutWidth layoutHeight error 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding layoutWidth error layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding error layoutHeight layoutWidth 				 { yyerror("android:text is mandatory!"); yyerrok;}
                 							    |  padding error layoutWidth layoutHeight 				 { yyerror("android:text is mandatory!"); yyerrok;}
							  ;
progressBarAttributes:								layoutHeight layoutWidth
                      								| layoutWidth layoutHeight
                      								| layoutHeight layoutWidth id
                      								| layoutHeight id layoutWidth
                      								| layoutWidth layoutHeight id
                      								| layoutWidth id layoutHeight
                      								| id layoutHeight layoutWidth
                      								| id layoutWidth layoutHeight
                      								| layoutHeight layoutWidth max
                      								| layoutHeight max layoutWidth
                      								| layoutWidth layoutHeight max
                      								| layoutWidth max layoutHeight
                      								| max layoutHeight layoutWidth
                      								| max layoutWidth layoutHeight
                      								| layoutHeight layoutWidth progress
                      								| layoutHeight progress layoutWidth
                      								| layoutWidth layoutHeight progress
                      								| layoutWidth progress layoutHeight
                      								| progress layoutHeight layoutWidth
                      								| progress layoutWidth layoutHeight
                      								| layoutHeight layoutWidth max id
                      								| layoutHeight layoutWidth id max
                      								| layoutHeight max layoutWidth id
                      								| layoutHeight max id layoutWidth
                      								| layoutHeight id layoutWidth max
                      								| layoutHeight id max layoutWidth
                      								| layoutWidth layoutHeight max id
                      								| layoutWidth layoutHeight id max
                      								| layoutWidth max layoutHeight id
                      								| layoutWidth max id layoutHeight
                      								| layoutWidth id layoutHeight max
                      								| layoutWidth id max layoutHeight
                      								| max layoutHeight layoutWidth id
                      								| max layoutHeight id layoutWidth
                      								| max layoutWidth layoutHeight id
                      								| max layoutWidth id layoutHeight
                      								| max id layoutHeight layoutWidth
                      								| max id layoutWidth layoutHeight
                      								| id layoutHeight layoutWidth max
                      								| id layoutHeight max layoutWidth
                      								| id layoutWidth layoutHeight max
                      								| id layoutWidth max layoutHeight
                      								| id max layoutHeight layoutWidth
                      								| id max layoutWidth layoutHeight
                      								| layoutHeight layoutWidth progress id
                      								| layoutHeight layoutWidth id progress
                      								| layoutHeight progress layoutWidth id
                      								| layoutHeight progress id layoutWidth
                      								| layoutHeight id layoutWidth progress
                      								| layoutHeight id progress layoutWidth
                      								| layoutWidth layoutHeight progress id
                      								| layoutWidth layoutHeight id progress
                      								| layoutWidth progress layoutHeight id
                      								| layoutWidth progress id layoutHeight
                      								| layoutWidth id layoutHeight progress
                      								| layoutWidth id progress layoutHeight
                      								| progress layoutHeight layoutWidth id
                      								| progress layoutHeight id layoutWidth
                      								| progress layoutWidth layoutHeight id
                      								| progress layoutWidth id layoutHeight
                      								| progress id layoutHeight layoutWidth
                      								| progress id layoutWidth layoutHeight
                      								| id layoutHeight layoutWidth progress
                      								| id layoutHeight progress layoutWidth
                      								| id layoutWidth layoutHeight progress
                      								| id layoutWidth progress layoutHeight
                      								| id progress layoutHeight layoutWidth
                      								| id progress layoutWidth layoutHeight
                      								| layoutHeight layoutWidth max progress
                      								| layoutHeight layoutWidth progress max
                      								| layoutHeight max layoutWidth progress
                      								| layoutHeight max progress layoutWidth
                      								| layoutHeight progress layoutWidth max
                      								| layoutHeight progress max layoutWidth
                      								| layoutWidth layoutHeight max progress
                      								| layoutWidth layoutHeight progress max
                      								| layoutWidth max layoutHeight progress
                      								| layoutWidth max progress layoutHeight
                      								| layoutWidth progress layoutHeight max
                      								| layoutWidth progress max layoutHeight
                      								| max layoutHeight layoutWidth progress
                      								| max layoutHeight progress layoutWidth
                      								| max layoutWidth layoutHeight progress
                      								| max layoutWidth progress layoutHeight
                      								| max progress layoutHeight layoutWidth
                      								| max progress layoutWidth layoutHeight
                      								| progress layoutHeight layoutWidth max
                      								| progress layoutHeight max layoutWidth
                      								| progress layoutWidth layoutHeight max
                      								| progress layoutWidth max layoutHeight
                      								| progress max layoutHeight layoutWidth
                      								| progress max layoutWidth layoutHeight
                      								| layoutHeight layoutWidth max progress id
                      								| layoutHeight layoutWidth max id progress
                      								| layoutHeight layoutWidth progress max id
                      								| layoutHeight layoutWidth progress id max
                      								| layoutHeight layoutWidth id max progress
                      								| layoutHeight layoutWidth id progress max
                      								| layoutHeight max layoutWidth progress id
                      								| layoutHeight max layoutWidth id progress
                      								| layoutHeight max progress layoutWidth id
                      								| layoutHeight max progress id layoutWidth
                      								| layoutHeight max id layoutWidth progress
                      								| layoutHeight max id progress layoutWidth
                      								| layoutHeight progress layoutWidth max id
                      								| layoutHeight progress layoutWidth id max
                      								| layoutHeight progress max layoutWidth id
                      								| layoutHeight progress max id layoutWidth
                      								| layoutHeight progress id layoutWidth max
                      								| layoutHeight progress id max layoutWidth
                      								| layoutHeight id layoutWidth max progress
                      								| layoutHeight id layoutWidth progress max
                      								| layoutHeight id max layoutWidth progress
                      								| layoutHeight id max progress layoutWidth
                      								| layoutHeight id progress layoutWidth max
                      								| layoutHeight id progress max layoutWidth
                      								| layoutWidth layoutHeight max progress id
                      								| layoutWidth layoutHeight max id progress
                      								| layoutWidth layoutHeight progress max id
                      								| layoutWidth layoutHeight progress id max
                      								| layoutWidth layoutHeight id max progress
                      								| layoutWidth layoutHeight id progress max
                      								| layoutWidth max layoutHeight progress id
                      								| layoutWidth max layoutHeight id progress
                      								| layoutWidth max progress layoutHeight id
                      								| layoutWidth max progress id layoutHeight
                      								| layoutWidth max id layoutHeight progress
                      								| layoutWidth max id progress layoutHeight
                      								| layoutWidth progress layoutHeight max id
                      								| layoutWidth progress layoutHeight id max
                      								| layoutWidth progress max layoutHeight id
                      								| layoutWidth progress max id layoutHeight
                      								| layoutWidth progress id layoutHeight max
                      								| layoutWidth progress id max layoutHeight
                      								| layoutWidth id layoutHeight max progress
                      								| layoutWidth id layoutHeight progress max
                      								| layoutWidth id max layoutHeight progress
                      								| layoutWidth id max progress layoutHeight
                      								| layoutWidth id progress layoutHeight max
                      								| layoutWidth id progress max layoutHeight
                      								| max layoutHeight layoutWidth progress id
                      								| max layoutHeight layoutWidth id progress
                      								| max layoutHeight progress layoutWidth id
                      								| max layoutHeight progress id layoutWidth
                      								| max layoutHeight id layoutWidth progress
                      								| max layoutHeight id progress layoutWidth
                      								| max layoutWidth layoutHeight progress id
                      								| max layoutWidth layoutHeight id progress
                      								| max layoutWidth progress layoutHeight id
                      								| max layoutWidth progress id layoutHeight
                      								| max layoutWidth id layoutHeight progress
                      								| max layoutWidth id progress layoutHeight
                      								| max progress layoutHeight layoutWidth id
                      								| max progress layoutHeight id layoutWidth
                      								| max progress layoutWidth layoutHeight id
                      								| max progress layoutWidth id layoutHeight
                      								| max progress id layoutHeight layoutWidth
                      								| max progress id layoutWidth layoutHeight
                      								| max id layoutHeight layoutWidth progress
                      								| max id layoutHeight progress layoutWidth
                      								| max id layoutWidth layoutHeight progress
                      								| max id layoutWidth progress layoutHeight
                      								| max id progress layoutHeight layoutWidth
                      								| max id progress layoutWidth layoutHeight
                      								| progress layoutHeight layoutWidth max id
                      								| progress layoutHeight layoutWidth id max
                      								| progress layoutHeight max layoutWidth id
                      								| progress layoutHeight max id layoutWidth
                      								| progress layoutHeight id layoutWidth max
                      								| progress layoutHeight id max layoutWidth
                      								| progress layoutWidth layoutHeight max id
                      								| progress layoutWidth layoutHeight id max
                      								| progress layoutWidth max layoutHeight id
                      								| progress layoutWidth max id layoutHeight
                      								| progress layoutWidth id layoutHeight max
                      								| progress layoutWidth id max layoutHeight
                      								| progress max layoutHeight layoutWidth id
                      								| progress max layoutHeight id layoutWidth
                      								| progress max layoutWidth layoutHeight id
                      								| progress max layoutWidth id layoutHeight
                      								| progress max id layoutHeight layoutWidth
                      								| progress max id layoutWidth layoutHeight
                      								| progress id layoutHeight layoutWidth max
                      								| progress id layoutHeight max layoutWidth
                      								| progress id layoutWidth layoutHeight max
                      								| progress id layoutWidth max layoutHeight
                      								| progress id max layoutHeight layoutWidth
                      								| progress id max layoutWidth layoutHeight
                      								| id layoutHeight layoutWidth max progress
                      								| id layoutHeight layoutWidth progress max
                      								| id layoutHeight max layoutWidth progress
                      								| id layoutHeight max progress layoutWidth
                      								| id layoutHeight progress layoutWidth max
                      								| id layoutHeight progress max layoutWidth
                      								| id layoutWidth layoutHeight max progress
                      								| id layoutWidth layoutHeight progress max
                      								| id layoutWidth max layoutHeight progress
                      								| id layoutWidth max progress layoutHeight
                      								| id layoutWidth progress layoutHeight max
                      								| id layoutWidth progress max layoutHeight
                      								| id max layoutHeight layoutWidth progress
                      								| id max layoutHeight progress layoutWidth
                      								| id max layoutWidth layoutHeight progress
                      								| id max layoutWidth progress layoutHeight
                      								| id max progress layoutHeight layoutWidth
                      								| id max progress layoutWidth layoutHeight
                      								| id progress layoutHeight layoutWidth max
                      								| id progress layoutHeight max layoutWidth
                      								| id progress layoutWidth layoutHeight max
                      								| id progress layoutWidth max layoutHeight
                      								| id progress max layoutHeight layoutWidth
                      								| id progress max layoutWidth layoutHeight
                      							    |  error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth max progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth max id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth progress max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth progress id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error layoutWidth id progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max layoutWidth progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max layoutWidth id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max progress layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max progress id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max id layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error max id progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress layoutWidth max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress layoutWidth id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress max layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress max id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress id layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error progress id max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id layoutWidth progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id max layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id max progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id progress layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  error id progress max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error max progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error max id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error progress max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error progress id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth error id progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max error progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max error id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max progress error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max progress id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max id error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth max id progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress error max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress error id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress max error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress max id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress id error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth progress id max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id error progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id max error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id max progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id progress error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutWidth id progress max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error layoutWidth progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error layoutWidth id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error progress layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error progress id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error id layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max error id progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth error progress id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth error id progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth progress error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth progress id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth id error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max layoutWidth id progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max progress id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id error layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id error progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id layoutWidth error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id layoutWidth progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id progress error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  max id progress layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error layoutWidth max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error layoutWidth id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error max layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error max id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error id layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress error id max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth error max id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth error id max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth max error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth max id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth id error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress layoutWidth id max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress max id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id error layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id error max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id layoutWidth error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id layoutWidth max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id max error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  progress id max layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error layoutWidth progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error max layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error max progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error progress layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id error progress max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error max progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth error progress max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth max error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth max progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth progress error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id layoutWidth progress max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max error layoutWidth progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max error progress layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max layoutWidth error progress 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max layoutWidth progress error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max progress error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id max progress layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress error layoutWidth max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress error max layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress layoutWidth error max 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress layoutWidth max error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress max error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  id progress max layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok;}
                      							    |  layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error max progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error max id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error progress max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error progress id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight error id progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max error progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max error id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max progress error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max progress id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max id error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight max id progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress error max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress error id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress max error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress max id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress id error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight progress id max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id error progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id max error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id max progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id progress error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  layoutHeight id progress max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight max progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight max id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight progress max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight progress id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error layoutHeight id progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max layoutHeight progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max layoutHeight id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max progress layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max progress id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max id layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error max id progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress layoutHeight max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress layoutHeight id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress max layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress max id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress id layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error progress id max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id layoutHeight progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id max layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id max progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id progress layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  error id progress max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight error progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight error id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight progress error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight progress id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight id error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max layoutHeight id progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error layoutHeight progress id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error layoutHeight id progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error progress layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error progress id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error id layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max error id progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max progress id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id layoutHeight error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id layoutHeight progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id error layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id error progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id progress layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  max id progress error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight error max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight error id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight max error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight max id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight id error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress layoutHeight id max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error layoutHeight max id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error layoutHeight id max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error max layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error max id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error id layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress error id max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress max id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id layoutHeight error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id layoutHeight max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id error layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id error max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id max layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  progress id max error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight error progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight max error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight max progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight progress error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id layoutHeight progress max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight max progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error layoutHeight progress max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error max layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error max progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error progress layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id error progress max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max layoutHeight error progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max layoutHeight progress error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max error layoutHeight progress 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max error progress layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max progress layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id max progress error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress layoutHeight error max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress layoutHeight max error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress error layoutHeight max 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress error max layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress max layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
                      							    |  id progress max error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok;}
							  ;
radioGroupAttributes:								layoutHeight layoutWidth maxChildren
                     								| layoutHeight maxChildren layoutWidth
                     								| layoutWidth layoutHeight maxChildren
                     								| layoutWidth maxChildren layoutHeight
                     								| maxChildren layoutHeight layoutWidth
                     								| maxChildren layoutWidth layoutHeight
                     								| layoutHeight layoutWidth id maxChildren
                     								| layoutHeight layoutWidth maxChildren id
                     								| layoutHeight id layoutWidth maxChildren
                     								| layoutHeight id maxChildren layoutWidth
                     								| layoutHeight maxChildren layoutWidth id
                     								| layoutHeight maxChildren id layoutWidth
                     								| layoutWidth layoutHeight id maxChildren
                     								| layoutWidth layoutHeight maxChildren id
                     								| layoutWidth id layoutHeight maxChildren
                     								| layoutWidth id maxChildren layoutHeight
                     								| layoutWidth maxChildren layoutHeight id
                     								| layoutWidth maxChildren id layoutHeight
                     								| id layoutHeight layoutWidth maxChildren
                     								| id layoutHeight maxChildren layoutWidth
                     								| id layoutWidth layoutHeight maxChildren
                     								| id layoutWidth maxChildren layoutHeight
                     								| id maxChildren layoutHeight layoutWidth
                     								| id maxChildren layoutWidth layoutHeight
                     								| maxChildren layoutHeight layoutWidth id
                     								| maxChildren layoutHeight id layoutWidth
                     								| maxChildren layoutWidth layoutHeight id
                     								| maxChildren layoutWidth id layoutHeight
                     								| maxChildren id layoutHeight layoutWidth
                     								| maxChildren id layoutWidth layoutHeight
                     								| layoutHeight layoutWidth maxChildren checkedButton
                     								| layoutHeight layoutWidth checkedButton maxChildren
                     								| layoutHeight maxChildren layoutWidth checkedButton
                     								| layoutHeight maxChildren checkedButton layoutWidth
                     								| layoutHeight checkedButton layoutWidth maxChildren
                     								| layoutHeight checkedButton maxChildren layoutWidth
                     								| layoutWidth layoutHeight maxChildren checkedButton
                     								| layoutWidth layoutHeight checkedButton maxChildren
                     								| layoutWidth maxChildren layoutHeight checkedButton
                     								| layoutWidth maxChildren checkedButton layoutHeight
                     								| layoutWidth checkedButton layoutHeight maxChildren
                     								| layoutWidth checkedButton maxChildren layoutHeight
                     								| maxChildren layoutHeight layoutWidth checkedButton
                     								| maxChildren layoutHeight checkedButton layoutWidth
                     								| maxChildren layoutWidth layoutHeight checkedButton
                     								| maxChildren layoutWidth checkedButton layoutHeight
                     								| maxChildren checkedButton layoutHeight layoutWidth
                     								| maxChildren checkedButton layoutWidth layoutHeight
                     								| checkedButton layoutHeight layoutWidth maxChildren
                     								| checkedButton layoutHeight maxChildren layoutWidth
                     								| checkedButton layoutWidth layoutHeight maxChildren
                     								| checkedButton layoutWidth maxChildren layoutHeight
                     								| checkedButton maxChildren layoutHeight layoutWidth
                     								| checkedButton maxChildren layoutWidth layoutHeight
                     								| layoutHeight layoutWidth maxChildren id checkedButton
                     								| layoutHeight layoutWidth maxChildren checkedButton id
                     								| layoutHeight layoutWidth id maxChildren checkedButton
                     								| layoutHeight layoutWidth id checkedButton maxChildren
                     								| layoutHeight layoutWidth checkedButton maxChildren id
                     								| layoutHeight layoutWidth checkedButton id maxChildren
                     								| layoutHeight maxChildren layoutWidth id checkedButton
                     								| layoutHeight maxChildren layoutWidth checkedButton id
                     								| layoutHeight maxChildren id layoutWidth checkedButton
                     								| layoutHeight maxChildren id checkedButton layoutWidth
                     								| layoutHeight maxChildren checkedButton layoutWidth id
                     								| layoutHeight maxChildren checkedButton id layoutWidth
                     								| layoutHeight id layoutWidth maxChildren checkedButton
                     								| layoutHeight id layoutWidth checkedButton maxChildren
                     								| layoutHeight id maxChildren layoutWidth checkedButton
                     								| layoutHeight id maxChildren checkedButton layoutWidth
                     								| layoutHeight id checkedButton layoutWidth maxChildren
                     								| layoutHeight id checkedButton maxChildren layoutWidth
                     								| layoutHeight checkedButton layoutWidth maxChildren id
                     								| layoutHeight checkedButton layoutWidth id maxChildren
                     								| layoutHeight checkedButton maxChildren layoutWidth id
                     								| layoutHeight checkedButton maxChildren id layoutWidth
                     								| layoutHeight checkedButton id layoutWidth maxChildren
                     								| layoutHeight checkedButton id maxChildren layoutWidth
                     								| layoutWidth layoutHeight maxChildren id checkedButton
                     								| layoutWidth layoutHeight maxChildren checkedButton id
                     								| layoutWidth layoutHeight id maxChildren checkedButton
                     								| layoutWidth layoutHeight id checkedButton maxChildren
                     								| layoutWidth layoutHeight checkedButton maxChildren id
                     								| layoutWidth layoutHeight checkedButton id maxChildren
                     								| layoutWidth maxChildren layoutHeight id checkedButton
                     								| layoutWidth maxChildren layoutHeight checkedButton id
                     								| layoutWidth maxChildren id layoutHeight checkedButton
                     								| layoutWidth maxChildren id checkedButton layoutHeight
                     								| layoutWidth maxChildren checkedButton layoutHeight id
                     								| layoutWidth maxChildren checkedButton id layoutHeight
                     								| layoutWidth id layoutHeight maxChildren checkedButton
                     								| layoutWidth id layoutHeight checkedButton maxChildren
                     								| layoutWidth id maxChildren layoutHeight checkedButton
                     								| layoutWidth id maxChildren checkedButton layoutHeight
                     								| layoutWidth id checkedButton layoutHeight maxChildren
                     								| layoutWidth id checkedButton maxChildren layoutHeight
                     								| layoutWidth checkedButton layoutHeight maxChildren id
                     								| layoutWidth checkedButton layoutHeight id maxChildren
                     								| layoutWidth checkedButton maxChildren layoutHeight id
                     								| layoutWidth checkedButton maxChildren id layoutHeight
                     								| layoutWidth checkedButton id layoutHeight maxChildren
                     								| layoutWidth checkedButton id maxChildren layoutHeight
                     								| maxChildren layoutHeight layoutWidth id checkedButton
                     								| maxChildren layoutHeight layoutWidth checkedButton id
                     								| maxChildren layoutHeight id layoutWidth checkedButton
                     								| maxChildren layoutHeight id checkedButton layoutWidth
                     								| maxChildren layoutHeight checkedButton layoutWidth id
                     								| maxChildren layoutHeight checkedButton id layoutWidth
                     								| maxChildren layoutWidth layoutHeight id checkedButton
                     								| maxChildren layoutWidth layoutHeight checkedButton id
                     								| maxChildren layoutWidth id layoutHeight checkedButton
                     								| maxChildren layoutWidth id checkedButton layoutHeight
                     								| maxChildren layoutWidth checkedButton layoutHeight id
                     								| maxChildren layoutWidth checkedButton id layoutHeight
                     								| maxChildren id layoutHeight layoutWidth checkedButton
                     								| maxChildren id layoutHeight checkedButton layoutWidth
                     								| maxChildren id layoutWidth layoutHeight checkedButton
                     								| maxChildren id layoutWidth checkedButton layoutHeight
                     								| maxChildren id checkedButton layoutHeight layoutWidth
                     								| maxChildren id checkedButton layoutWidth layoutHeight
                     								| maxChildren checkedButton layoutHeight layoutWidth id
                     								| maxChildren checkedButton layoutHeight id layoutWidth
                     								| maxChildren checkedButton layoutWidth layoutHeight id
                     								| maxChildren checkedButton layoutWidth id layoutHeight
                     								| maxChildren checkedButton id layoutHeight layoutWidth
                     								| maxChildren checkedButton id layoutWidth layoutHeight
                     								| id layoutHeight layoutWidth maxChildren checkedButton
                     								| id layoutHeight layoutWidth checkedButton maxChildren
                     								| id layoutHeight maxChildren layoutWidth checkedButton
                     								| id layoutHeight maxChildren checkedButton layoutWidth
                     								| id layoutHeight checkedButton layoutWidth maxChildren
                     								| id layoutHeight checkedButton maxChildren layoutWidth
                     								| id layoutWidth layoutHeight maxChildren checkedButton
                     								| id layoutWidth layoutHeight checkedButton maxChildren
                     								| id layoutWidth maxChildren layoutHeight checkedButton
                     								| id layoutWidth maxChildren checkedButton layoutHeight
                     								| id layoutWidth checkedButton layoutHeight maxChildren
                     								| id layoutWidth checkedButton maxChildren layoutHeight
                     								| id maxChildren layoutHeight layoutWidth checkedButton
                     								| id maxChildren layoutHeight checkedButton layoutWidth
                     								| id maxChildren layoutWidth layoutHeight checkedButton
                     								| id maxChildren layoutWidth checkedButton layoutHeight
                     								| id maxChildren checkedButton layoutHeight layoutWidth
                     								| id maxChildren checkedButton layoutWidth layoutHeight
                     								| id checkedButton layoutHeight layoutWidth maxChildren
                     								| id checkedButton layoutHeight maxChildren layoutWidth
                     								| id checkedButton layoutWidth layoutHeight maxChildren
                     								| id checkedButton layoutWidth maxChildren layoutHeight
                     								| id checkedButton maxChildren layoutHeight layoutWidth
                     								| id checkedButton maxChildren layoutWidth layoutHeight
                     								| checkedButton layoutHeight layoutWidth maxChildren id
                     								| checkedButton layoutHeight layoutWidth id maxChildren
                     								| checkedButton layoutHeight maxChildren layoutWidth id
                     								| checkedButton layoutHeight maxChildren id layoutWidth
                     								| checkedButton layoutHeight id layoutWidth maxChildren
                     								| checkedButton layoutHeight id maxChildren layoutWidth
                     								| checkedButton layoutWidth layoutHeight maxChildren id
                     								| checkedButton layoutWidth layoutHeight id maxChildren
                     								| checkedButton layoutWidth maxChildren layoutHeight id
                     								| checkedButton layoutWidth maxChildren id layoutHeight
                     								| checkedButton layoutWidth id layoutHeight maxChildren
                     								| checkedButton layoutWidth id maxChildren layoutHeight
                     								| checkedButton maxChildren layoutHeight layoutWidth id
                     								| checkedButton maxChildren layoutHeight id layoutWidth
                     								| checkedButton maxChildren layoutWidth layoutHeight id
                     								| checkedButton maxChildren layoutWidth id layoutHeight
                     								| checkedButton maxChildren id layoutHeight layoutWidth
                     								| checkedButton maxChildren id layoutWidth layoutHeight
                     								| checkedButton id layoutHeight layoutWidth maxChildren
                     								| checkedButton id layoutHeight maxChildren layoutWidth
                     								| checkedButton id layoutWidth layoutHeight maxChildren
                     								| checkedButton id layoutWidth maxChildren layoutHeight
                     								| checkedButton id maxChildren layoutHeight layoutWidth
                     								| checkedButton id maxChildren layoutWidth layoutHeight
                     							    |  error layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth maxChildren id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth maxChildren checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutWidth id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutWidth checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren id layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren id checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id maxChildren layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id maxChildren checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id checkedButton layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error id checkedButton maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton id layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  error checkedButton id maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error maxChildren id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error maxChildren checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren error id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren error checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren id error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren id checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren checkedButton error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth maxChildren checkedButton id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id maxChildren error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id maxChildren checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id checkedButton error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth id checkedButton maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton maxChildren error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton maxChildren id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton id error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton id maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutWidth id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutWidth checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error id layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error id checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth error id checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth error checkedButton id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth id error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth id checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth checkedButton error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutWidth checkedButton id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id error layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id error checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutWidth error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutWidth checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id checkedButton error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren id checkedButton layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error maxChildren layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error maxChildren checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error checkedButton layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id error checkedButton maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error maxChildren checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error checkedButton maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth maxChildren error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth maxChildren checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth checkedButton error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id layoutWidth checkedButton maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren error layoutWidth checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren error checkedButton layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutWidth error checkedButton 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutWidth checkedButton error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren checkedButton error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id maxChildren checkedButton layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton error layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton error maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutWidth error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutWidth maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton maxChildren error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  id checkedButton maxChildren layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error id layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton error id maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error maxChildren id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error id maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth maxChildren error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth maxChildren id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth id error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth id maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id error layoutWidth maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id error maxChildren layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutWidth error maxChildren 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutWidth maxChildren error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id maxChildren error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  checkedButton id maxChildren layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                     							    |  layoutHeight error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error maxChildren id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error maxChildren checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren error id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren error checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren id error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren id checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren checkedButton error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight maxChildren checkedButton id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id maxChildren error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id maxChildren checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id checkedButton error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight id checkedButton maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton maxChildren error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton maxChildren id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton id error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton id maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight maxChildren id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight maxChildren checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutHeight id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren layoutHeight checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren id layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren id checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error maxChildren checkedButton id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id maxChildren layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id maxChildren checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id checkedButton layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error id checkedButton maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton maxChildren id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton id layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  error checkedButton id maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight error id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight error checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight id error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight id checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight checkedButton error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren layoutHeight checkedButton id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutHeight id checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error layoutHeight checkedButton id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error id layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error id checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren error checkedButton id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutHeight error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id layoutHeight checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id error layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id error checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id checkedButton layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren id checkedButton error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  maxChildren checkedButton id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight maxChildren error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight maxChildren checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight checkedButton error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id layoutHeight checkedButton maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight maxChildren checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight checkedButton maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error maxChildren layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error maxChildren checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error checkedButton layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id error checkedButton maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutHeight error checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren layoutHeight checkedButton error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren error layoutHeight checkedButton 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren error checkedButton layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren checkedButton layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id maxChildren checkedButton error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutHeight error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutHeight maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton error layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton error maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton maxChildren layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  id checkedButton maxChildren error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight maxChildren error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight maxChildren id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight id error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight id maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight maxChildren id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight id maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error maxChildren id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error id layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton error id maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton maxChildren id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutHeight error maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutHeight maxChildren error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id error layoutHeight maxChildren 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id error maxChildren layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id maxChildren layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  checkedButton id maxChildren error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth error id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth error checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth id error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth id checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth checkedButton error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight layoutWidth checkedButton id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error layoutWidth id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error layoutWidth checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error id checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight error checkedButton id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id layoutWidth error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id layoutWidth checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id error checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id checkedButton layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight id checkedButton error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton layoutWidth error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton layoutWidth id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton error id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton id layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutHeight checkedButton id error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight error id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight error checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight id error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight id checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight checkedButton error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth layoutHeight checkedButton id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error layoutHeight id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error layoutHeight checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error id checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth error checkedButton id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id layoutHeight error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id layoutHeight checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id error checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id checkedButton layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth id checkedButton error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton layoutHeight error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton layoutHeight id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton error id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton id layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  layoutWidth checkedButton id error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight layoutWidth id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight layoutWidth checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight id checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutHeight checkedButton id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth layoutHeight id checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth layoutHeight checkedButton id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth id checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error layoutWidth checkedButton id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutHeight checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id layoutWidth checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id checkedButton layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error id checkedButton layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutHeight id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton layoutWidth id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton id layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  error checkedButton id layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight layoutWidth error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight layoutWidth checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight error checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight checkedButton layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutHeight checkedButton error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth layoutHeight error checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth layoutHeight checkedButton error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth error checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth checkedButton layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id layoutWidth checkedButton error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight layoutWidth checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutHeight checkedButton layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth layoutHeight checkedButton 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error layoutWidth checkedButton layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error checkedButton layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id error checkedButton layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutHeight layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutHeight error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutWidth layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton layoutWidth error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton error layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  id checkedButton error layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight layoutWidth error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight layoutWidth id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight error id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight id layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutHeight id error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth layoutHeight error id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth layoutHeight id error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth error id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth id layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton layoutWidth id error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight layoutWidth id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutHeight id layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth layoutHeight id 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error layoutWidth id layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error id layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton error id layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutHeight layoutWidth error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutHeight error layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutWidth layoutHeight error 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id layoutWidth error layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id error layoutHeight layoutWidth 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
                     							    |  checkedButton id error layoutWidth layoutHeight 				 { yyerror("android:max_children is mandatory!"); yyerrok; }
							  ;
linearLayoutAttributes:								layoutHeight layoutWidth
                       								| layoutWidth layoutHeight
                       								| layoutHeight layoutWidth id
                       								| layoutHeight id layoutWidth
                       								| layoutWidth layoutHeight id
                       								| layoutWidth id layoutHeight
                       								| id layoutHeight layoutWidth
                       								| id layoutWidth layoutHeight
                       								| layoutHeight layoutWidth orientation
                       								| layoutHeight orientation layoutWidth
                       								| layoutWidth layoutHeight orientation
                       								| layoutWidth orientation layoutHeight
                       								| orientation layoutHeight layoutWidth
                       								| orientation layoutWidth layoutHeight
                       								| layoutHeight layoutWidth id orientation
                       								| layoutHeight layoutWidth orientation id
                       								| layoutHeight id layoutWidth orientation
                       								| layoutHeight id orientation layoutWidth
                       								| layoutHeight orientation layoutWidth id
                       								| layoutHeight orientation id layoutWidth
                       								| layoutWidth layoutHeight id orientation
                       								| layoutWidth layoutHeight orientation id
                       								| layoutWidth id layoutHeight orientation
                       								| layoutWidth id orientation layoutHeight
                       								| layoutWidth orientation layoutHeight id
                       								| layoutWidth orientation id layoutHeight
                       								| id layoutHeight layoutWidth orientation
                       								| id layoutHeight orientation layoutWidth
                       								| id layoutWidth layoutHeight orientation
                       								| id layoutWidth orientation layoutHeight
                       								| id orientation layoutHeight layoutWidth
                       								| id orientation layoutWidth layoutHeight
                       								| orientation layoutHeight layoutWidth id
                       								| orientation layoutHeight id layoutWidth
                       								| orientation layoutWidth layoutHeight id
                       								| orientation layoutWidth id layoutHeight
                       								| orientation id layoutHeight layoutWidth
                       								| orientation id layoutWidth layoutHeight
                       							    |  error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error layoutWidth orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error orientation layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth error orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth orientation error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error layoutWidth id orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error layoutWidth orientation id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error id layoutWidth orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error id orientation layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error orientation layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  error orientation id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth error id orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth error orientation id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth id error orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth id orientation error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth orientation error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutWidth orientation id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id error layoutWidth orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id error orientation layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id layoutWidth error orientation 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id layoutWidth orientation error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id orientation error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  id orientation layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  orientation id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                       							    |  layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight error orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight orientation error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error layoutHeight orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error orientation layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight error id orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight error orientation id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight id error orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight id orientation error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight orientation error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  layoutHeight orientation id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error layoutHeight id orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error layoutHeight orientation id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error id layoutHeight orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error id orientation layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error orientation layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  error orientation id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id layoutHeight error orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id layoutHeight orientation error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id error layoutHeight orientation 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id error orientation layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id orientation layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  id orientation error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                       							    |  orientation id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                                                    ;
relativeLayoutAttributes:								layoutHeight layoutWidth
                         								| layoutWidth layoutHeight
                         								| layoutHeight layoutWidth id
                         								| layoutHeight id layoutWidth
                         								| layoutWidth layoutHeight id
                         								| layoutWidth id layoutHeight
                         								| id layoutHeight layoutWidth
                         								| id layoutWidth layoutHeight
                         							    |  error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  error layoutWidth id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  error id layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  layoutWidth error id 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  layoutWidth id error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  id error layoutWidth 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  id layoutWidth error 				 { yyerror("android:layoutHeight is mandatory!"); yyerrok; }
                         							    |  layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  layoutHeight error id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  layoutHeight id error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  error layoutHeight id 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  error id layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  id layoutHeight error 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                         							    |  id error layoutHeight 				 { yyerror("android:layoutWidth is mandatory!"); yyerrok; }
                                                        ;
radioButton:					T_RADIO_BUTTON_S radioButtonAttributes T_END_ONE_LINE_ELEM { radioButton_counter++; check_radioGroup_checkedButton(hash, scope, &checkedButtonFound); } radioButton
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
radioGroup:						T_RADIO_GROUP_S { checkedButtonFound = FALSE; radioButton_counter = 0; } radioGroupAttributes T_END_MANY_LINES_ELEM radioButton T_RADIO_GROUP_F T_END_MANY_LINES_ELEM { if(!checkedButtonFound) yyerror("The value of checked_button should exists in radioButton inside radioGroup"); check_maxChildren_radioGroup(hash, radioButton_counter, scope); }
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
maxChildren:					T_ANDROID T_SEMICOLON T_MAX_CHILDREN T_EQUAL T_NUMBER		{ add_maxChildren(hash, $5, scope); }
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
