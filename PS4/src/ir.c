#include <vslc.h>
#include <string.h>

// Externally visible, for the generator
extern tlhash_t *global_names;
extern char **string_list;
extern size_t n_string_list, stringc;

tlhash_t **scope_list;
size_t scopec;

void create_symbol_table();
void print_symbol_table();
void print_globals();
void find_globals();
void bind_names(symbol_t*, node_t*);
void destroy_symtab();
void append_function(node_t*, int);
void append_vars(tlhash_t*, node_t*, symtype_t, int);
void search_tree(node_t*, node_t *, tlhash_t*, int, int*);
void append_string_list(node_t*);
void update_scope_list(tlhash_t *);
void lookup_scopes(node_t *, symbol_t *, int);
void free_table(tlhash_t *);
void print_symbols();
void print_bindings(node_t *);

char* sym_string[4] = {
    "SYM_GLOBAL_VAR",
    "SYM_FUNCTION",
    "SYM_PARAMETER",
    "SYM_LOCAL_VAR"
};


/* External interface */

void
create_symbol_table ( void )
{
    find_globals();
    size_t n_globals = tlhash_size ( global_names );
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for ( size_t i=0; i<n_globals; i++ ) {
        if ( global_list[i]->type == SYM_FUNCTION ) {
            bind_names ( global_list[i], global_list[i]->node );
        }
    }
}


void
print_symbol_table ( void )
{
       print_symbols ();
       print_bindings(root);
}

void
destroy_symbol_table ( void )
{
      destroy_symtab();
}

void
print_symbols ( void )
{
    printf ( "String table:\n" );
    for ( size_t s=0; s<stringc; s++ )
        printf  ( "%zu: %s\n", s, string_list[s] );
    printf ( "-- \n" );

    printf ( "Globals:\n" );
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for ( size_t g=0; g<n_globals; g++ )
    {
        switch ( global_list[g]->type )
        {
            case SYM_FUNCTION:
                printf (
                    "%s: function %zu:\n",
                    global_list[g]->name, global_list[g]->seq
                );
                if ( global_list[g]->locals != NULL )
                {
                    size_t localsize = tlhash_size( global_list[g]->locals );
                    printf (
                        "\t%zu local variables, %zu are parameters:\n",
                        localsize, global_list[g]->nparms
                    );
                    symbol_t *locals[localsize];
                    tlhash_values(global_list[g]->locals, (void **)locals );
                    for ( size_t i=0; i<localsize; i++ )
                    {
                        printf ( "\t%s: ", locals[i]->name );
                        switch ( locals[i]->type )
                        {
                            case SYM_PARAMETER:
                                printf ( "parameter %zu\n", locals[i]->seq );
                                break;
                            case SYM_LOCAL_VAR:
                                printf ( "local var %zu\n", locals[i]->seq );
                                break;
                        }
                    }
                }
                break;
            case SYM_GLOBAL_VAR:
                printf ( "%s: global variable\n", global_list[g]->name );
                break;
        }
    }
    printf ( "-- \n" );
}


void
print_bindings ( node_t *root )
{
    if ( root == NULL )
        return;
    else if ( root->entry != NULL )
    {
        switch ( root->entry->type )
        {
            case SYM_GLOBAL_VAR:
                printf ( "Linked global var '%s'\n", root->entry->name );
                break;
            case SYM_FUNCTION:
                printf ( "Linked function %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break;
            case SYM_PARAMETER:
                printf ( "Linked parameter %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break;
            case SYM_LOCAL_VAR:
                printf ( "Linked local var %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break;
        }
    } else if ( root->type == STRING_DATA ) {
        size_t string_index = *((size_t *)root->data);
        if ( string_index < stringc )
            printf ( "Linked string %zu\n", *((size_t *)root->data) );
        else
            printf ( "(Not an indexed string)\n" );
    }
    for ( size_t c=0; c<root->n_children; c++ )
        print_bindings ( root->children[c] );
}

void
find_globals ( void )
{
    node_t *list = root->children[0];
    global_names = malloc(sizeof(tlhash_t));
    tlhash_init(global_names, 32); //16 buckets
    int seq = 0;
    for (int i = 0; i < list->n_children; i++) {
        node_t *node = list->children[i];
        switch(node->type) {
            case FUNCTION:
                append_function(node, seq);
                seq++;
                break;
            case DECLARATION:
                append_vars(global_names, node->children[0], SYM_GLOBAL_VAR, seq);
                break;
        }
    }
}

void append_function(node_t *node, int seq) {
    symbol_t *sym = malloc(sizeof(symbol_t));
    tlhash_t *locals = malloc(sizeof(tlhash_t));
    tlhash_init(locals, 32);
    sym->locals = locals;
    sym->type = SYM_FUNCTION;
    sym->node = node;
    sym->name = node->children[0]->data;
    sym->seq = (size_t) seq;
    //fprintf(stderr, "Adding %s(%s) of type %s to GLOBAL_SYMTAB (%d)\n", sym_string[sym->type], sym->name, node_string[node->type], (int) sym->seq);
    tlhash_insert(global_names, sym->name, strlen(sym->name), sym);
}

void append_vars(tlhash_t *parent, node_t *list, symtype_t type, int seq) {
    for (int i = 0; i < list->n_children; i++) {
        node_t *child = list->children[i];
        symbol_t *sym = malloc(sizeof(symbol_t));
        sym->name = child->data;
        sym->type = type;
        sym->node = child;
        if (type != SYM_GLOBAL_VAR)
            sym->seq = (size_t) seq;
        tlhash_insert(parent, sym->name, strlen(sym->name), sym);
        //fprintf(stderr, "Adding %s(%s) of type %s to LOCAL_SYMTAB (%d) size: %d\n", sym_string[type], sym->name, node_string[child->type], (int) sym->seq, tlhash_size(parent));
        seq++;
    }
}

void
bind_names ( symbol_t *function, node_t *root )
{
    int seq = 0;
    for (int i = 0; i < root->n_children; i++) {
        node_t *child = root->children[i];
        if (child != NULL) {
            switch(child->type) {
                case VARIABLE_LIST:
                    function->nparms = child->n_children;
                    append_vars(function->locals, child, SYM_PARAMETER, seq);
                    seq += child->n_children;
                break;
            }
        }
    }
    //Traverse the tree to link the symbols to the identifier_data
    scopec = 0;
    update_scope_list(global_names);
    update_scope_list(function->locals);
    search_tree(root, NULL, function->locals, 1, &seq);
    //TODO
    //Merge local scopes swith the local sym-table and index on name + sequencing number
    if (scopec > 2) {
        for (int i = 2; i < scopec; i++) {
            size_t size = tlhash_size(scope_list[i]);
            char *keys[size];
            tlhash_keys(scope_list[i], (void **) &keys);
            for (int j = 0; j < size; j++) {
                symbol_t *sym;
                tlhash_lookup(scope_list[i], keys[j], strlen(keys[j]), (void **) &sym);
                tlhash_insert(function->locals, &sym->seq, sizeof(size_t), sym);
            }
            free_table(scope_list[i]); //Free symbol tables in deeper scopes after they have
            //been merged with the most local
        }
    }
}

void search_tree(node_t *node, node_t *parent, tlhash_t *function, int scope_level, int *seq) {
    if (node != NULL) {
        symbol_t *sym = NULL;
        node_t *child;
        tlhash_t *current_scope;
        switch (node->type) {
            case BLOCK: //If we are within the function
                //If we are at scope level 1, we want to append symbols to the
                //same table as the parameters. Thus, we do not initialize a new table
                //for the scope level "2", instead we use the same as the one for params
                if (scope_level > 1) {
                    current_scope = malloc(sizeof(tlhash_t));
                    tlhash_init(current_scope, 32);
                    update_scope_list(current_scope);
                }
                scope_level++;
                break;
            case DECLARATION:
                child = node->children[0];
                append_vars(scope_list[scopec - 1], child, SYM_LOCAL_VAR, *seq);
                *seq += child->n_children;
                break;
            case IDENTIFIER_DATA:
                if (parent->type != 10 && parent->type != 6)
                    lookup_scopes(node, sym, scope_level);
                break;
            case STRING_DATA:
                append_string_list(node);
                break;
        }
        for (int i = 0; i < node->n_children; i++) {
            search_tree(node->children[i], node, function, scope_level, seq);
        }
    }
}

void update_scope_list(tlhash_t *scope) {
    scope_list = realloc(scope_list, (scopec + 1) * sizeof(*scope_list));
    scope_list[scopec] = scope;
    scopec++;
}

void append_string_list(node_t *node) {
    string_list = realloc(string_list, (stringc + 1) * sizeof(*string_list));
    string_list[stringc] = node->data;
    size_t *p = malloc(sizeof(size_t)); //Create a new pointer for the data in node
    *p = stringc;
    node->data = p;
    stringc++;
}

void lookup_scopes(node_t *node, symbol_t *sym, int scope_level) {
    for (int i = scope_level - 1; i >= 0; i--) {
        tlhash_t *scope = scope_list[i];
        if (tlhash_lookup(scope, node->data, strlen(node->data), (void *)&sym) == TLHASH_SUCCESS) {
            node->entry = sym;
            //fprintf(stderr, "Linked a node (%s) to a symbol in scope level %d from scope %d. The symbol has seq: %d\n", sym->name, i, scope_level - 1, sym->seq);
            return;
        }
    }
}

void
destroy_symtab ( void )
{
    //We already free'd all symbol tables for variables in deeper scopes, here
    //we have to free the global table and all of the local tables
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for ( size_t g=0; g<n_globals; g++ ) {
        symbol_t *global = global_list[g];
        free_table(global->locals);
    }
    free_table(global_names);
    free(scope_list);
}

void free_table(tlhash_t *tab) {
    if (tab != NULL) {
        size_t size = tlhash_size(tab);
        char *keys[size];
        tlhash_keys(tab, (void **) &keys);
        for (int j = 0; j < size; j++) {
            //Remove twice, because the tables has been hashed with different
            //data types (hashing on name is easy while linking, but creates conflicts
            //when we merge symbol tables that has symbols of the same name
            if (tlhash_remove(tab, keys[j], strlen(keys[j])) == TLHASH_SUCCESS) {
                //fprintf(stderr, "Removed a symbol entry with string key\n");
            } else if (tlhash_remove(tab, keys[j], sizeof(size_t)) == TLHASH_SUCCESS) {
                //fprintf(stderr, "Removed a symbol entry with seq\n");
            }
        }
        free(tab);
    }
}