#include <stdio.h>
#include <stdlib.h>
#include <vslc.h>

node_t *root;

int
main ( int argc, char **argv )
{
    /*int tokenId;
    while((tokenId = yylex()) != 0) {
        printf("ID: %d\t\tValue: %s\n", tokenId, yytext);
    }*/


    //For a long time I had an issue with the parser causing a segfault
    //It took a really long time to debug, but I finally realized that for the
    //number data nodes I had to make a pointer for the number data and not
    //store it directly into the node data

    yyparse();

    node_print ( root, 0 );
    destroy_subtree ( root );
}