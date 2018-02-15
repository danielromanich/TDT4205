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


    //For a long time I had an issue with the parser causing a segfault. After a lot of debugging I found that the
    //issue was connected with the NUMBER_DATA node. I finally realized that I was setting the data pointer to the
    //number value parsed from yytext, instead of allocating another memory slot for the data. Therefore the data pointer
    //pointed to some random memory-location which it was not allowed to access.



    yyparse();

    node_print ( root, 0 );
    destroy_subtree ( root );
}