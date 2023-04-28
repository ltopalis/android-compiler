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
    hash_size (*hashfunc)(int);
};

typedef struct hashtbl HASHTBL;
typedef struct hashnode_s hash_node_s;

static hash_size def_hashfunc(int scope);

HASHTBL *hashtbl_create(hash_size size, hash_size (*hashfunc)(int));
void hashtbl_destroy(HASHTBL *hashtbl);
int hashtbl_insert(HASHTBL *hashtbl, const char *key, void *data, int scope);
int hashtbl_remove(HASHTBL *hashtbl, const char *key, int scope);
void *hashtbl_get(HASHTBL *hashtbl, int scope);

#endif