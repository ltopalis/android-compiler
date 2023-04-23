#ifndef LEXER_H
#define LEXER_H

/*           SYMBOLS            */

#define T_EQUAL                     1
#define T_START_COMMENT             2
#define T_END_COMMENT               3
#define T_SEMICOLON                 4
#define T_END_ONE_LINE_ELEM         5
#define T_END_MANY_LINES_ELEM       6
#define T_QUOTATION                 7
#define T_UNDERSCORE                8
#define T_DOUBLE_MINUS              9
#define T_SYMBOL                    10

/*           ELEMENTS           */
   
#define T_TEXT_VIEW_S               11  
#define T_RADIO_BUTTON_S            12
#define T_RELATIVE_LAYOUT_S         13
#define T_IMAGE_VIEW_S              14  
#define T_BUTTON_S                  15   
#define T_LINEAR_LAYOUT_F           16 
#define T_RELATIVE_LAYOUT_F         17
#define T_RADIO_GROUP_F             18  
#define T_PROGRESS_BAR_S            19

/*          ATTRIBUTES          */
    
#define T_PROGRESS                  20  
#define T_ANDROID                   21  
#define T_LAYOUT_HEIGHT             22  
#define T_LAYOUT_WIDTH              23  
#define T_ORIENTATION               24 
#define T_ID                        25
#define T_TEXT                      26 
#define T_SRC                       27 
#define T_PADDING                   28  
#define T_TEXT_COLOR                29  
#define T_CHECKED_BUTTON            30 
#define T_MAX                       31 

/*            OTHER             */
  
#define T_NUMBER                    32
#define T_ALPHARITHMETIC            33  
#define T_EOF                       0


#endif
