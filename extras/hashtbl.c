#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtbl.h"

HASHTBL *hashtbl_create(hash_size size, hash_size (*hashfunc)(const char *))
{
    HASHTBL *hashtbl;
    if (!(hashtbl = malloc(sizeof(HASHTBL))))
        return NULL;
    if (!(hashtbl->nodes = calloc(size, sizeof(hashnode_s *))))
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
    hashnode_s *node, *oldnode;
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
    hashnode_s *node;
    hash_size hash = hashtbl->hashfunc(key) % hashtbl->size;

    // We have to search the linked list to see if data with the same key has beeen inserted before, in which case we just replace the data member of the hashnode_s struct.
    node = hashtbl->nodes[hash];
    while (node)
    {
        if (!strcmp(node->key, key) && node->scope == scope)
        {
            node->data = data;
            node->scope = scope;
            return 0;
        }
        node = node->next;
    }

    // If we didn't find the key, we insert a new element at the start of the linked list.-
    if (!(node = malloc(sizeof(hashnode_s))))
        return -1;
    if (!(node->key = mystrdup(key)))
    {
        free(node);
        return -1;
    }
    node->data = strdup(data);
    node->scope = scope;
    node->next = hashtbl->nodes[hash];
    hashtbl->nodes[hash] = node;

    return 0;
}

int hashtbl_remove(HASHTBL *hashtbl, const char *key, int scope)
{
    hashnode_s *node, *prevnode = NULL;
    hash_size hash = hashtbl->hashfunc(key) % hashtbl->size;
    node = hashtbl->nodes[hash];
    while (node)
    {
        if (!strcmp(node->key, key) && node->scope == scope)
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

hashnode_s *hashtbl_get(HASHTBL *hashtbl, const char *key, int scope)
{
    hashnode_s *node;
    hash_size hash = hashtbl->hashfunc(key) % hashtbl->size;

    node = hashtbl->nodes[hash];
    while (node)
    {
        if (!strcmp(node->key, key) && node->scope == scope)
            return node;
        node = node->next;
    }
    return NULL;
}

int hashtbl_check_id(HASHTBL *hashtbl, void *value)
{
    hashnode_s *node;
    hash_size hash = hashtbl->hashfunc("android:id") % hashtbl->size;

    node = hashtbl->nodes[hash];
    while (node)
    {
        if (!strcmp(node->data, value))
            return 1;
        node = node->next;
    }
    return 0;
}

static char *mystrdup(const char *s)
{
    char *b;
    if (!(b = malloc(strlen(s) + 1)))
        return NULL;
    strcpy(b, s);
    return b;
}

static hash_size def_hashfunc(const char *key)
{
    hash_size hash = 0;
    while (*key)
    {
        hash += (unsigned char)*key++;
    }
    return hash;
}