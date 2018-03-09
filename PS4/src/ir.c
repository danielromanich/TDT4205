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
void search_tree(node_t*, tlhash_t*, int, int*);
void append_string_list(node_t*);
void update_scope_list(tlhash_t *);
void lookup_scopes(node_t *, symbol_t *, int);
void free_table(tlhash_t *);

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
      print_globals ();
}


void
destroy_symbol_table ( void )
{
      destroy_symtab();
}

void
print_globals ( void )
{
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for ( size_t g=0; g<n_globals; g++ ) {
        fprintf ( stderr, "Global: %s (%d)\n", global_list[g]->name, (int) global_list[g]->seq);
        if (global_list[g]->type == SYM_FUNCTION) {
            size_t n_locals = tlhash_size(global_list[g]->locals);
            symbol_t *local_list[n_locals];
            tlhash_values ( global_list[g]->locals, (void **)&local_list );
            for (size_t i = 0; i < n_locals; i++) {
                fprintf(stderr, "Local: %s (%d) - %s\n", local_list[i]->name, (int) local_list[i]->seq, sym_string[local_list[i]->type]);
            }
        }
    }
    for (int i = 0; i < stringc; i++) {
        fprintf(stderr, "String #%d is: %s\n", i, string_list[i]);
    }
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
    fprintf(stderr, "Adding %s(%s) of type %s to GLOBAL_SYMTAB (%d)\n", sym_string[sym->type], sym->name, node_string[node->type], (int) sym->seq);
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
        fprintf(stderr, "Adding %s(%s) of type %s to LOCAL_SYMTAB (%d)\n", sym_string[type], sym->name, node_string[child->type], (int) sym->seq);
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
    search_tree(root, function->locals, 1, &seq);
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
        free(scope_list); //Free the "stack" of symbol tables"s
    }
}

void search_tree(node_t *node, tlhash_t *function, int scope_level, int *seq) {
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
                lookup_scopes(node, sym, scope_level);
                break;
            case STRING_DATA:
                append_string_list(node);
                break;
        }
        for (int i = 0; i < node->n_children; i++) {
            search_tree(node->children[i], function, scope_level, seq);
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
}

void free_table(tlhash_t *tab) {
    size_t size = tlhash_size(tab);
    char *keys[size];
    tlhash_keys(tab, (void **) &keys);
    for (int j = 0; j < size; j++) {
        //Remove twice, because the tables has been hashed with different
        //data types (hashing on name is easy while linking, but creates conflicts
        //when we merge symbol tables that has symbols of the same name
        if (tlhash_remove(tab, keys[j], strlen(keys[j])) == TLHASH_SUCCESS)
            fprintf(stderr, "Removed a symbol entry with string key\n");
        if (tlhash_remove(tab, keys[j], sizeof(size_t)) == TLHASH_SUCCESS)
            fprintf(stderr, "Removed a symbol entry with seq\n");
    }
    free(tab);
}