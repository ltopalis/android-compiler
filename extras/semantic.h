#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "hashtbl.h"

#define STR_LENGTH 256
#define TRUE 1
#define FALSE 0

extern void yyerror(const char *error);

void add_id(HASHTBL *hash, char *value, int scope);
int add_max(HASHTBL *hash, int value, int scope);
int add_progress(HASHTBL *hash, int value, int scope);
void check_progress(HASHTBL *hash, int scope);
int checkedButton(HASHTBL *hash, char *value, int scope);
void check_radioGroup_checkedButton(HASHTBL *hash, int scope, int *found);

#endif