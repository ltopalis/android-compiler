/*
    Retrieved from: https://literateprograms.org/hash_table__c_.html
*/

#ifndef HASHTBL_H
#define HASHTBL_H

#include <stdio.h>

#define hash_size size_t

struct hashnode_s
{
    char *key;
    void *data;
    int scope;
    struct hashnode_s *next;
};

struct hashtbl
{
    hash_size size;
    struct hashnode_s **nodes;
    hash_size (*hashfunc)(const char *);
};

typedef struct hashtbl HASHTBL;
typedef struct hashnode_s hashnode_s;

static hash_size def_hashfunc(const char *key);
static char *mystrdup(const char *s);

HASHTBL *hashtbl_create(hash_size size, hash_size (*hashfunc)(const char *));
void hashtbl_destroy(HASHTBL *hashtbl);
int hashtbl_insert(HASHTBL *hashtbl, const char *key, void *data, int scope);
int hashtbl_remove(HASHTBL *hashtbl, const char *key, int scope);
hashnode_s *hashtbl_get(HASHTBL *hashtbl, const char *key, int scope);

#endif