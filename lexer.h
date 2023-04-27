#ifndef LEXER_H
#define LEXER_H

/*           SYMBOLS            */

#define T_EQUAL                     1
#define T_SYMBOL                    2
#define T_SEMICOLON                 3
#define T_END_ONE_LINE_ELEM         4
#define T_END_MANY_LINES_ELEM       5

/*           ELEMENTS           */

#define T_PROGRESS_BAR_S            6
#define T_TEXT_VIEW_S               7  
#define T_RADIO_BUTTON_S            8
#define T_RELATIVE_LAYOUT_S         9
#define T_IMAGE_VIEW_S              10  
#define T_BUTTON_S                  11   
#define T_LINEAR_LAYOUT_F           12 
#define T_RELATIVE_LAYOUT_F         13
#define T_RADIO_GROUP_F             14
#define T_RADIO_GROUP_S             15
#define T_LINEAR_LAYOUT_S           16  

/*          ATTRIBUTES          */
  
#define T_ANDROID                   17  
#define T_LAYOUT_HEIGHT             18  
#define T_LAYOUT_WIDTH              19  
#define T_ORIENTATION               20 
#define T_ID                        21
#define T_TEXT                      22 
#define T_SRC                       23 
#define T_PADDING                   24  
#define T_TEXT_COLOR                25  
#define T_CHECKED_BUTTON            26 
#define T_MAX                       27
#define T_PROGRESS                  28

/*            OTHER             */
  
#define T_ALPHANUMERIC              29
#define T_NUMBER                    30
#define T_VTEXT                     31
#define T_ALPHANUMERIC_             32

#define T_EOF                       0


#endif
