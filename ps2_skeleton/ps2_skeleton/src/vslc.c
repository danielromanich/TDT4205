#include <stdio.h>
#include <stdlib.h>
#include <vslc.h>

node_t *root;

int
main ( int argc, char **argv )
{
    //The output seems just fine, but yyparse still does not work
    int tokenId;
    while((tokenId = yylex()) != 0)
        printf("ID: %d\t\tValue: %s\n", tokenId, yytext);
    yyparse();
    node_print ( root, 0 );
    destroy_subtree ( root );
}