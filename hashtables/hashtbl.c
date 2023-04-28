#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtbl.h"

HASHTBL *hashtbl_create(hash_size size, hash_size (*hashfunc)(int))
{
    HASHTBL *hashtbl;
    if (!(hashtbl = malloc(sizeof(HASHTBL))))
        return NULL;
    if (!(hashtbl->nodes = calloc(size, sizeof(struct hashnode_s *))))
    {
        free(hashtbl);
        return NULL;
    }
    hashtbl->size = size;
    if (hashfunc)
        hashtbl->hashfunc = hashfunc;
    else
        hashtbl->hashfunc = def_hashfunc;
    return hashtbl;
}

void hashtbl_destroy(HASHTBL *hashtbl)
{
    hash_size n;
    hash_node_s *node, *oldnode;
    for (n = 0; n < hashtbl->size; ++n)
    {
        node = hashtbl->nodes[n];
        while (node)
        {
            free(node->key);
            oldnode = node;
            node = node->next;
            free(oldnode);
        }
    }
    free(hashtbl->nodes);
    free(hashtbl);
}

int hashtbl_insert(HASHTBL *hashtbl, const char *key, void *data, int scope)
{
    hash_node_s *node;
    hash_size hash = hashtbl->hashfunc(scope) % hashtbl->size;

    // We have to search the linked list to see if data with the same key has beeen inserted before,
    // in which case we just replace the data member of the hashnode_s struct.
    node = hashtbl->nodes[hash];
    while (node)
    {
        if (node->scope == scope)
        {
            node->data = data;
            node->key = strdup(key);
            return 0;
        }
        node = node->next;
    }

    // If we didn't find the key, we insert a new element at the start of the linked list.-
    if (!(node = malloc(sizeof(hash_node_s))))
        return -1;

    if (!(node->scope = scope))
    {
        free(node);
        return -1;
    }

    node->data = data;
    node->key = strdup(key);
    node->next = hashtbl->nodes[hash];
    hashtbl->nodes[hash] = node;
}

int hashtbl_remove(HASHTBL *hashtbl, const char *key, int scope)
{
    hash_node_s *node, *prevnode = NULL;
    hash_size hash = hashtbl->hashfunc(scope) % hashtbl->size;
    node = hashtbl->nodes[hash];
    while (node)
    {
        if ((scope == node->scope) && (!(strcmp(node->key, key))))
        {
            free(node->key);
            if (prevnode)
                prevnode->next = node->next;
            else
                hashtbl->nodes[hash] = node->next;
            free(node);
            return 0;
        }
        prevnode = node;
        node = node->next;
    }

    return -1;
}

void *hashtbl_get(HASHTBL *hashtbl, int scope){
    hash_node_s *node;
    hash_size hash = hashtbl->hashfunc(scope)%hashtbl->size;

    node=hashtbl->nodes[hash];
    while(node){
        if(scope == node->scope) return node->data;
        node=node->next;
    }

    return NULL;
}

static hash_size def_hashfunc(int scope)
{
    hash_size hash = 0;
    hash = ((scope >> 16) ^ scope) * 0x45d9f3b;
    hash = ((hash >> 16) ^ hash) * 0x45d9f3b;
    hash = (hash >> 16) ^ hash;

    return hash;
}