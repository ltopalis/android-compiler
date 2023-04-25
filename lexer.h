#ifndef LEXER_H
#define LEXER_H

/*           SYMBOLS            */

#define T_EQUAL                     1
#define T_COMMENT                   2
#define T_SYMBOL                    3
#define T_SEMICOLON                 4
#define T_END_ONE_LINE_ELEM         5
#define T_END_MANY_LINES_ELEM       6
#define T_QUOTATION                 7

/*           ELEMENTS           */

#define T_PROGRESS_BAR_S            8
#define T_TEXT_VIEW_S               9  
#define T_RADIO_BUTTON_S            10
#define T_RELATIVE_LAYOUT_S         11
#define T_IMAGE_VIEW_S              12  
#define T_BUTTON_S                  13   
#define T_LINEAR_LAYOUT_F           14 
#define T_RELATIVE_LAYOUT_F         15
#define T_RADIO_GROUP_F             16
#define T_RADIO_GROUP_S             17
#define T_LINEAR_LAYOUT_S           18  

/*          ATTRIBUTES          */
  
#define T_ANDROID                   19  
#define T_LAYOUT_HEIGHT             20  
#define T_LAYOUT_WIDTH              21  
#define T_ORIENTATION               22 
#define T_ID                        23
#define T_TEXT                      24 
#define T_SRC                       25 
#define T_PADDING                   26  
#define T_TEXT_COLOR                27  
#define T_CHECKED_BUTTON            28 
#define T_MAX                       29
#define T_PROGRESS                  30

/*            OTHER             */
  
#define T_ALPHANUMERIC              31
#define T_NUMBER                    32
#define T_VTEXT                     33
#define T_ALPHANUMERIC_             34

#define T_EOF                       0


#endif
