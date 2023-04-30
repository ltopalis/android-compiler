#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "hashtbl.h"

#define STR_LENGTH 256

extern void yyerror(const char* error);

void add_id(HASHTBL *hash, char *value, int scope);
int add_max(HASHTBL *hash, int value, int scope);
int add_progress(HASHTBL *hash, int value, int scope);
void check_progress(HASHTBL *hash, int scope);


#endif