%{
#include <vslc.h>
%}
%left '|'
%left '^'
%left '&'
%left LSHIFT RSHIFT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%right '~'
	//%expect 1

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING LSHIFT RSHIFT ASSIGN

%%
program :
      global_list {
        root = (node_t *) malloc ( sizeof(node_t) );
        node_init ( root, PROGRAM, NULL, 1, $1 );
      }
    ;

global_list:
    global {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, GLOBAL_LIST, NULL, 1, $1);
    }
    | global_list global {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, GLOBAL_LIST, NULL, 2, $1, $2);
    }
    ;

global:
    function {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, GLOBAL, NULL, 1, $1);
    }
    | declaration {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, GLOBAL, NULL, 1, $1);
    }
    ;

statement_list:
    statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT_LIST, NULL, 1, $1);
    }
    | statement_list statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT_LIST, NULL, 2, $1, $2);
    }
    ;

print_list:
    print_item {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PRINT_LIST, NULL, 1, $1);
    }
    | print_list ',' print_item {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PRINT_LIST, NULL, 2, $1, $3);
    }
    ;

expression_list:
    expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION_LIST, NULL, 1, $1);
    }
    | expression_list ',' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION_LIST, NULL, 2, $1, $3);
    }
    ;

variable_list:
    identifier {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, VARIABLE_LIST, NULL, 1, $1);
    }
    | variable_list ',' identifier {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, VARIABLE_LIST, NULL, 2, $1, $3);
    }
    ;

argument_list:
    expression_list {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, ARGUMENT_LIST, NULL, 1, $1);
    }
    |
    {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, ARGUMENT_LIST, NULL, 0);
    }
    ;

parameter_list:
    variable_list {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PARAMETER_LIST, NULL, 1, $1);
    }
    |
    {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PARAMETER_LIST, NULL, 0);
    }
    ;

declaration_list:
    declaration {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, DECLARATION_LIST, NULL, 1, $1);
    }
    | declaration_list declaration {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, DECLARATION_LIST, NULL, 2, $1, $2);
    }
    ;

function:
    FUNC identifier '(' parameter_list ')' statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, FUNCTION, NULL, 3, $2, $4, $6);
    }
    ;

statement:
    assignment_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | return_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | print_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | if_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | while_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | null_statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    | block {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STATEMENT, NULL, 1, $1);
    }
    ;

block:
    OPENBLOCK declaration_list statement_list CLOSEBLOCK {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, BLOCK, NULL, 2, $2, $3);
    }
    | OPENBLOCK statement_list CLOSEBLOCK {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, BLOCK, NULL, 1, $2);
    }
    ;

assignment_statement:
    identifier ASSIGN expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $3);
    }
    ;

return_statement:
    RETURN expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, RETURN_STATEMENT, NULL, 1, $2);
    }
    ;

print_statement:
    PRINT print_list {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PRINT_STATEMENT, NULL, 1, $2);
    }
    ;

null_statement:
    CONTINUE {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, NULL_STATEMENT, NULL, 1, $1);
    }
    ;

if_statement:
    IF relation THEN statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, IF_STATEMENT, NULL, 2, $2, $4);
    }
    | IF relation THEN statement ELSE statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, IF_STATEMENT, NULL, 3, $2, $4, $6);
    }
    ;

while_statement:
    WHILE relation DO statement {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, WHILE_STATEMENT, NULL, 2, $2, $4);
    }
    ;

relation:
    expression '=' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, RELATION, strdup("="), 2, $1, $3);
    }
    | expression '<' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, RELATION, strdup("<"), 2, $1, $3);
    }
    | expression '>' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, RELATION, strdup(">"), 2, $1, $3);
    }
    ;

expression:
    expression '|' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("|"), 2, $1, $3);
    }
    | expression '^' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("^"), 2, $1, $3);
    }
    | expression '&' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("&"), 2, $1, $3);
    }
    | expression LSHIFT expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("<<"), 2, $1, $3);
    }
    | expression RSHIFT expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup(">>"), 2, $1, $3);
    }
    | expression '+' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("+"), 2, $1, $3);
    }
    | expression '-' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("-"), 2, $1, $3);
    }
    | expression '*' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("*"), 2, $1, $3);
    }
    | expression '/' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("/"), 2, $1, $3);
    }
    | '-' expression %prec UMINUS {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("-"), 1, $2);
    }
    | '~' expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, strdup("~"), 1, $2);
    }
    | '(' expression ')' {
        $$ = $2;
    }
    | number {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, NULL, 1, $1);
    }
    | identifier {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, NULL, 1, $1);
    }
    | identifier '(' argument_list ')' {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, EXPRESSION, NULL, 2, $1, $3);
    }
    ;

declaration:
    VAR variable_list {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, DECLARATION, NULL, 1, $2);
    }
    ;

print_item:
    expression {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PRINT_ITEM, NULL, 1, $1);
    }
    | string {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, PRINT_ITEM, NULL, 1, $1);
    }
    ;

identifier:
    IDENTIFIER {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, IDENTIFIER_DATA, strdup(yytext), 0);
    }
    ;

number:
    NUMBER {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, NUMBER_DATA, NULL, 0);
        int64_t* number = malloc(sizeof(int64_t));
        *number = strtol(yytext, NULL, 10);
        $$->data = number;
    }
    ;

string:
    STRING {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init( $$, STRING_DATA, strdup(yytext), 0);
    }
    ;
%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d (%s)\n", error, yylineno, yytext);
    exit ( EXIT_FAILURE );
}
