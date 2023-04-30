#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic.h"
#include "hashtbl.h"

void add_id(HASHTBL *hash, char *value, int scope)
{
    char *new_value = strdup(value);
    new_value[strlen(new_value) - 1] = '\0';

    if (!hashtbl_check_id(hash, new_value))
        hashtbl_insert(hash, "android:id", new_value, scope);
    else
        yyerror("Values of `id` should be unique");
    // printf("\n");
}

int add_max(HASHTBL *hash, int value, int scope)
{
    char str_value[STR_LENGTH];

    sprintf(str_value, "%d", value);
    return hashtbl_insert(hash, "android:max", str_value, scope);
}

int add_progress(HASHTBL *hash, int value, int scope)
{
    char str_value[STR_LENGTH];

    sprintf(str_value, "%d", value);
    return hashtbl_insert(hash, "android:progress", str_value, scope);
}

void check_progress(HASHTBL *hash, int scope)
{
    hashnode_s *progress_value_node = hashtbl_get(hash, "android:progress", scope);
    hashnode_s *max_value_node = hashtbl_get(hash, "android:max", scope);

    if(progress_value_node == NULL)
        return;
    
    if(max_value_node == NULL)
        return;

    int progress_value = atoi(progress_value_node->data);
    int max_value = atoi(max_value_node->data);

    char msg[STR_LENGTH];

    if (!(progress_value >= 0 && progress_value <= max_value))
    {
        sprintf(msg, "Value of android:progress should be less or equal to max_value (%d)", max_value);
        yyerror(msg);
    }
}