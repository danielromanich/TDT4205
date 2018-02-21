#include <vslc.h>
#include <string.h>

// Tasks
static void node_print ( node_t *root, int nesting );
static void simplify_tree ( node_t **simplified, node_t *root );
static void node_finalize ( node_t *discard );

// Choices
static void destroy_subtree ( node_t *discard );
static void modify_node( node_t *node );
static int is_list(node_t *node );
static void visit_node(node_t *node, int depth, node_t *parent);
static void compute_expressions(node_t *node);
static void simplify_lists(node_t *node, node_t *parent_node);
static void print_list_to_statement(node_t *node);
static void reduce_node(node_t *node, int depth, node_t *parent_node);

/* External interface */
void
destroy_syntax_tree ( void )
{
    destroy_subtree ( root );
}

/* Traverse the abstract syntax tree and simplify it */
void
simplify_syntax_tree ( void )
{
    visit_node(root, 0, NULL);
}

void visit_node(node_t *node, int depth, node_t *parent) {
    if (node != NULL) {
        reduce_node(node, depth, parent); //Reduce all nodes with only one child and no significant data
        for (int i = 0; i < node->n_children; i++) {
            visit_node(node->children[i], depth + 1, node);
        }
        simplify_lists(node, parent); //Simplify lists by collapsing them and combining children
        print_list_to_statement(node); //Convert simplified print_lists to print_statements
        compute_expressions(node); //Calculate all expressions consisting of number children
    }
}

void reduce_node(node_t *node, int depth, node_t *parent) {
    if (node != NULL && node->data == NULL && node->type != 0 && !is_list(node) && node->type != 21 && node->type != 12 && node->type != 14) {
        if (node->n_children == 1) {
            node_t *child = node->children[0];
            node->data  = child->data;
            node->children = child->children;
            node->n_children = child->n_children;
            if (node->type != 1)
                node->type = child->type;
            free(child);
            reduce_node(node, depth, parent);
        }
    }
}

void print_list_to_statement(node_t *node) {
    if (node->type == 4)
        node->type = 15;
}

void simplify_lists(node_t *node, node_t *parent_node) {
    if (node != NULL) {
        if (is_list(node)) {
            //If the node is a list with one child that also is a list, exchange current list for the child
            if (node->n_children == 1 && is_list(node->children[0])) {
                node_t *child = node->children[0];
                node->data  = child->data;
                node->children = child->children;
                node->n_children = child->n_children;
                node->type = child->type;
                free(child);
            } else if (parent_node != NULL) {
                //If the parent is a list and current is a list and they are of the same type merge the current node
                //children into the parent
                if (is_list(node) && parent_node != NULL && is_list(parent_node) && node->type == parent_node->type) {
                    int child_count = (node->n_children) + 1;
                    node_t** child_list = (node_t **) malloc ( child_count * sizeof(node_t *) );
                    for (int i = 0; i < node->n_children; i++) {
                        child_list[i] = node->children[i];
                    }
                    child_list[child_count - 1] = parent_node->children[1];
                    parent_node->children = child_list;
                    parent_node->n_children = child_count;
                    free( node );
                }
            }
        }
    }
}

void compute_expressions(node_t *node) {
    if (node != NULL && node->type == 19) {
        if (node->n_children == 2 && node->children[0]->type == 24 && node->children[1]->type == 24) {
            int64_t *v1 = (int64_t  *) node->children[0]->data, *v2 = (int64_t *) node->children[1]->data;
            int64_t *result = malloc(sizeof(int64_t));
            char *op = node->data;
            if (!strcmp(node->data, "+")) {
                *result = (int64_t) (*v1 + *v2);
            } else if (!strcmp(node->data, "-")) {
                *result = *v1 - *v2;
            } else if (!strcmp(node->data, "*")) {
                *result = *v1 * *v2;
            } else if (!strcmp(node->data, "/")) {
                *result = *v1 / *v2;
            } else if (!strcmp(node->data, "&")) {
                *result = *v1 & *v2;
            } else if (!strcmp(node->data, "^")) {
                *result = *v1 ^ *v2;
            } else if (!strcmp(node->data, "|")) {
                *result = *v1 | *v2;
            } else if (!strcmp(node->data, "<<")) {
                *result = *v1 << *v2;
            } else if (!strcmp(node->data, ">>")) {
                *result = *v1 >> *v2;
            }
            node->data = result;
            node->n_children = 0;
            node->type = 24;
            free (node -> children);
            node->children = NULL;
        } else if (node->n_children == 1 && node->children[0]->type == 24) {
            int64_t *v1 = (int64_t *) node->children[0]->data;
            int64_t *result = malloc(sizeof(int64_t));
            if (!strcmp(node->data, "-")) {
                *result = -(*v1);
            } else if (!strcmp(node->data, "~")) {
                *result = ~(*v1);
            }
            node->data = result;
            node->n_children = 0;
            node->type = 24;
            free (node -> children);
            node->children = NULL;
        }
    }
}

int is_list(node_t *node) {
    return (node->type >= 3 && node->type <= 9 || node->type == 1) ? 1 : 0;
}

void
print_syntax_tree ( void )
{
    node_print ( root, 0 );
}


void
node_init (node_t *nd, node_index_t type, void *data, uint64_t n_children, ...)
{
    va_list child_list;
    *nd = (node_t) {
        .type = type,
        .data = data,
        .entry = NULL,
        .n_children = n_children,
        .children = (node_t **) malloc ( n_children * sizeof(node_t *) )
    };
    va_start ( child_list, n_children );
    for ( uint64_t i=0; i<n_children; i++ )
        nd->children[i] = va_arg ( child_list, node_t * );
    va_end ( child_list );
}

/* Internal choices */

static void
node_print ( node_t *root, int nesting )
{
    if ( root != NULL )
    {
        printf ( "%*c%s", nesting, ' ', node_string[root->type] );
        if ( root->type == IDENTIFIER_DATA ||
             root->type == STRING_DATA ||
             root->type == EXPRESSION ) 
            printf ( "(%s)", (char *) root->data );
        else if ( root->type == NUMBER_DATA )
            printf ( "(%ld)", *((int64_t *)root->data) );
        putchar ( '\n' );
        for ( int64_t i=0; i<root->n_children; i++ )
            node_print ( root->children[i], nesting+1 );
    }
    else
        printf ( "%*c%p\n", nesting, ' ', root );
}


static void
node_finalize ( node_t *discard )
{
    if ( discard != NULL )
    {
        free ( discard->data );
        free ( discard->children );
        free ( discard );
    }
}


static void
destroy_subtree ( node_t *discard )
{
    if ( discard != NULL )
    {
        for ( uint64_t i=0; i<discard->n_children; i++ )
            destroy_subtree ( discard->children[i] );
        node_finalize ( discard );
    }
}
