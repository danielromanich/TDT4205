#include <vslc.h>

#define MIN(a,b) (((a)<(b)) ? (a):(b))
static const char *record[6] = {
    "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"
};


static void generate_stringtable();
static void generate_main(symbol_t*);
static void print_global_variables();
static void print_functions();
static void handle_arithmetics(node_t* node);
static void print_function_params(symbol_t* sym);
static void traverse_function(node_t* node);
static void handle_assignments(node_t* node);
static void handle_return(node_t* node);
static void handle_printing(node_t* node);
static void handle_expression(node_t* node);
static void handle_while_statement(node_t* node);
static void handle_if_statement(node_t* node);
static void handle_continue(node_t* node);
static void find_variable(node_t* node, char* str);
static void assign_variable_value(node_t* node, char* str);
static void print_int(char* str);
static void print_str(int64_t val);
static void print_new_line();

int64_t if_count = 0, while_count = 0;

void
generate_program ( void )
{
    generate_stringtable();
    print_global_variables();
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for (int i = 0; i < n_globals; i++) {
        if (global_list[i]->type == SYM_FUNCTION && global_list[i]->seq == 0) {
            generate_main(global_list[i]);
            break;
        }
    }
    print_functions();
}

static void
generate_stringtable ( void )
{
    /* These can be used to emit numbers, strings and a run-time
     * error msg. from main
     */
    puts ( ".section .rodata" );
    puts ( "intout: .string \"\%ld \"" );
    puts ( "strout: .string \"\%s \"" );
    puts ( "errout: .string \"Wrong number of arguments\"" );
    for (int i = 0; i < stringc; i++) {
        printf("STR%d:\t.string\t%s\n", i, string_list[i]);
    }
}

static void
generate_main ( symbol_t *first )
{
    puts ( ".globl main" );
    puts ( ".section .text" );
    puts ( "main:" );
    puts ( "\tpushq %rbp" );
    puts ( "\tmovq %rsp, %rbp" );

    puts ( "\tsubq $1, %rdi" );
    printf ( "\tcmpq\t$%zu,%%rdi\n", first->nparms );
    puts ( "\tjne ABORT" );
    puts ( "\tcmpq $0, %rdi" );
    puts ( "\tjz SKIP_ARGS" );

    puts ( "\tmovq %rdi, %rcx" );
    printf ( "\taddq $%zu, %%rsi\n", 8*first->nparms );
    puts ( "PARSE_ARGV:" );
    puts ( "\tpushq %rcx" );
    puts ( "\tpushq %rsi" );

    puts ( "\tmovq (%rsi), %rdi" );
    puts ( "\tmovq $0, %rsi" );
    puts ( "\tmovq $10, %rdx" );
    puts ( "\tcall strtol" );

    /*  Now a new argument is an integer in rax */
    puts ( "\tpopq %rsi" );
    puts ( "\tpopq %rcx" );
    puts ( "\tpushq %rax" );
    puts ( "\tsubq $8, %rsi" );
    puts ( "\tloop PARSE_ARGV" );

    /* Now the arguments are in order on stack */
    for ( int arg=0; arg<MIN(6,first->nparms); arg++ ) {
        printf ( "\tpopq\t%s\n", record[arg] );
    }
    puts ( "SKIP_ARGS:" );
    printf ( "\tcall\t_%s\n", first->name );
    puts ( "\tjmp END" );
    puts ( "ABORT:" );
    puts ( "\tmovq $errout, %rdi" );
    puts ( "\tcall puts" );

    puts ( "END:" );
    puts ( "\tmovq %rax, %rdi" );
    puts ( "\tcall exit" );
}

void print_global_variables() {
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    puts(".section .data");
    for (int i = 0; i < n_globals; i++) {
        if (global_list[i]->type == SYM_GLOBAL_VAR)
            printf("_%s:\t.zero\t8\n", global_list[i]->name);
    }
}

size_t nparms = 0;
void print_functions() {
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for (int i = 0; i < n_globals; i++) {
        if (global_list[i]->type == SYM_FUNCTION) {
            printf("_%s:\n", global_list[i]->name);
            printf("\tpushq %%rbp\n"); //Push the base-pointer onto the stack
            printf("\tmovq %%rsp, %%rbp\n"); //Move the current stack pointer to the base pointer
            nparms = global_list[i]->nparms;
            for (int i = 0; i < MIN(nparms, 6); i++) {
                printf("\tpushq %s\n", record[i]);
            }
            int stack_size = 8 * (global_list[i]->locals->size);
            printf("\tsubq $%d, %%rsp\n",  8 * ((int) (global_list[i]->locals->size - nparms)));
            if (stack_size%16 != 0)
                puts("\tpushq $0");
            traverse_function(global_list[i]->node);
        }
    }
}

void traverse_function(node_t* node) {
    if (node != NULL) {
        switch(node->type) {
            case ASSIGNMENT_STATEMENT: //Assignment
                handle_assignments(node);
                return;
            case RETURN_STATEMENT: //Return
                handle_return(node);
                return;
            case PRINT_STATEMENT: //print
                handle_printing(node);
                return;
            case NULL_STATEMENT: //Null
                handle_continue(node);
                return;
            case IF_STATEMENT: //If
                //Generatae this by creating labels and generating code between
                handle_if_statement(node);
                return;
            case WHILE_STATEMENT: //While
                handle_while_statement(node);
                return;
        }
    }
    for (int i = 0; i < node->n_children; i++) {
        traverse_function(node->children[i]);
    }
}

void handle_function_call(node_t* node) {
    int64_t param_count = node->children[1] == NULL ? 0 : node->children[1]->n_children;
    if (param_count > 6) {
        for (int i = param_count - 1; i >= 6; i--) {
            find_variable(node->children[1]->children[i], "%rax");
            puts("\tpushq %rax");
        }
    }
    for (int i = 0; i < MIN(param_count, 6); i++) {
        find_variable(node->children[1]->children[i], (char *) record[i]);
    }
    printf("\tcall _%s\n", (char *) node->children[0]->data);
}

void handle_return(node_t* node) {
    node_t* child = node->children[0];
    switch (child->type) {
        case EXPRESSION:
        case IDENTIFIER_DATA:
        case NUMBER_DATA:
            find_variable(child, "%rax");
            break;
    }
    puts("\tleave");
    puts("\tret");
}

void handle_assignments(node_t* node) {
    find_variable(node->children[1], "%rax");
    assign_variable_value(node->children[0], "%rax");
}

void handle_printing(node_t* node) {
    for (int i = 0; i < node->n_children; i++) {
        node_t* child = node->children[i];
        switch(child->type) {
            case EXPRESSION:
            case IDENTIFIER_DATA:
            case NUMBER_DATA:
                find_variable(child, "%rsi");
                print_int("%rsi");
                break;
            case STRING_DATA:
                print_str(*((int64_t*)child->data));
                break;
        }
    }
    print_new_line();
}

void find_variable(node_t* node, char* dest) {
    switch(node->type) {
        case EXPRESSION:
            handle_expression(node);
            if (strcmp(dest, "%rax")) {
                printf("\tmovq %%rax, %s\n", dest);
            }
            break;
        case IDENTIFIER_DATA:
            switch (node->entry->type) {
                int64_t seq = 0;
                case SYM_PARAMETER:
                    seq = node->entry->seq;
                    printf("\tmovq %s%d(%%rbp), %s\n", seq >= 6 ? "" : "-", (int) (8 * (seq >= 6 ? seq - 4 : seq + 1)), dest);
                    break;
                case SYM_GLOBAL_VAR:
                    printf("\tmovq _%s, %s\n", node->entry->name, dest);
                    break;
                case SYM_LOCAL_VAR:
                    printf("\tmovq -%d(%%rbp), %s\n", (int) (8 * (node->entry->seq + MIN(nparms, 6) + 1)), dest);
                    break;
            }
            break;
        case NUMBER_DATA:
            printf("\tmovq $%d, %s\n", (int) *((int64_t*)node->data), dest);
            break;

    }
}

void handle_expression(node_t* node) {
    if (node->n_children == 1) {
        fprintf(stderr, "Other ålace\n");
    }
    if (node->n_children == 2) {
        fprintf(stderr, "Some place\n");
        if (node->children[1] != NULL && node->children[1]->type == EXPRESSION_LIST) {

        }
        if (node->children[1] != NULL) {
            //fprintf(stderr, "Funcall %s %s\n", node_string[node->children[1]->type], node_string[node->children[0]->type]);
            //fprintf(stderr, "Stuff %s %d\n", node->children[0]->data, node->children[1]->data);
        }
    }
    /*if (node->n_children > 0 && node->children[0] != NULL && node->children[0]->data != NULL && !strcmp("test", node->children[0]->data)) {
        fprintf(stderr, "Function node: %d %s %s\n", node->n_children, node_string[node->children[0]->type], node_string[node->children[1]->type]);
        fprintf(stderr, "Child: %d\n", *((int64_t *)node->children[1]->children[0]->data));
    }*/
    if (node->n_children == 2 && (node->children[1] == NULL || node->children[1]->type == EXPRESSION_LIST)) {

        handle_function_call(node); //If the expression is a function call handle that
    } else if (node->data != NULL &&
        node->n_children == 2) {
        char* op = (char *) node->data;
        switch (*op) {
            case '<':
                find_variable(node->children[0], "%rax");
                printf("\tmovq %%rax, %%rcx\n");
                find_variable(node->children[1], "%rax");
                printf("\txchgq %%rax, %%rcx\n");
                printf("\tsalq %s, %%rax\n", "%cl");
                return;
            case '>':
                find_variable(node->children[0], "%rax");
                printf("\tmovq %%rax, %%rcx\n");
                find_variable(node->children[1], "%rax");
                printf("\txchgq %%rax, %%rcx\n");
                printf("\tsarq %s, %%rax\n", "%cl");
                return;
        }
        int mul_div = *op == '*' || *op == '/';
        if (mul_div) { //If we have multiplication or division we need to take a different approach
            puts("\tpushq %rdx");
        }
        find_variable(node->children[mul_div ? 1 : 0], "%rax");
        puts("\tpushq %rax");
        find_variable(node->children[mul_div ? 0 : 1], "%rax");
        switch (*op) {
            case '+':
                puts("\taddq %rax, (%rsp)");
                break;
            case '-':
                puts("\tsubq %rax, (%rsp)");
                break;
            case '*':
                puts("\tmulq (%rsp)");
                puts("\tpopq %rdx");
                puts("\tpopq %rdx");
                break;
            case '/':
                puts("\tcqo");
                puts("\tidivq (%rsp)");
                puts("\tpopq %rdx");
                puts("\tpopq %rdx");
                break;
            case '|':
                puts("\torq %rax, (%rsp)");
                break;
            case '&':
                puts("\tandq %rax, (%rsp)");
                break;
            case '^':
                puts("\txorq %rax, (%rsp)");
                break;
        }
        if (!mul_div) //Result gets stored in rax automaticly from mul/div
            puts("\tpopq %rax");

    } else if (node->n_children == 1) {
        find_variable(node->children[0], "%rax");
        switch(*((char*)node->data)) {
            case '-':
                puts("\tnegq %rax");
                break;
            case '~':
                puts("\tnotq %rax");
                break;
        }
    }
}

void assign_variable_value(node_t* node, char* dest) {
    switch (node->entry->type) {
        int64_t seq = 0;
        case SYM_PARAMETER:
            seq = node->entry->seq;
            printf("\tmovq %s, %s%d(%%rbp)\n", dest, seq >= 6 ? "" : "-", 8 * ((int) (seq >= 6 ? seq - 4 : seq + 1)));
            break;
        case SYM_GLOBAL_VAR:
            printf("\tmovq %s, _%s\n", dest, node->entry->name);
            break;
        case SYM_LOCAL_VAR:
            printf("\tmovq %s, -%d(%%rbp)\n", dest, (int) (8 * ((int) node->entry->seq + MIN(nparms, 6) + 1)));
            break;
    }
}

void handle_if_statement(node_t* node) {
    int64_t current_if = if_count; //We have to store the current if count before we increment it incase of
    //recursive calls
    if_count += 1;
    find_variable(node->children[0]->children[0], "%rax");
    find_variable(node->children[0]->children[1], "%rbx");
    puts("\tcmpq %rax, %rbx");
    int64_t child_count = node->n_children - 1;
    switch (*((char*)node->children[0]->data)) {
        case '=':
            printf("jne");
            break;
        case '>':
            printf("jge");
            break;
        case '<':
            printf("jle");
            break;
    }
    printf("\t %s%d\n", child_count == 1 ? "END_IF" : "ELSE", (int) current_if);
    traverse_function(node->children[1]);
    if (child_count == 2) printf("\tjmp END_IF%d\n", (int) current_if);
    printf("%s%d:\n", child_count == 1 ? "END_IF" : "ELSE", (int) current_if);
    if (child_count == 2) {
        traverse_function(node->children[2]);
        printf("END_IF%d:\n", (int) current_if);
    }
}

void handle_while_statement(node_t* node) {
    int64_t current_while = while_count;
    while_count += 1;
    printf("WHILE%d:\n", (int) current_while);
    find_variable(node->children[0]->children[0], "%rax");
    find_variable(node->children[0]->children[1], "%rbx");
    puts("\tcmpq %rax, %rbx");
    switch (*((char*)node->children[0]->data)) {
        case '=':
            printf("jne");
            break;
        case '>':
            printf("jge");
            break;
        case '<':
            printf("jle");
            break;
    }
    printf("\t DONE%d\n", (int) current_while);
    traverse_function(node->children[1]);
    printf("\tjmp WHILE%d\n", (int) current_while);
    printf("DONE%d:\n", (int) current_while);
}

void handle_continue(node_t* node) {
    printf("\tjmp WHILE%d\n", (int) while_count - 1);
}


void print_str(int64_t str_num) {
    printf("\tmovq $STR%d, %%rsi\n", (int) str_num);
    puts("\tmovq $strout, %rdi");
    puts("\tcall printf");
}

void print_int(char* dest) {
    puts("\tmovq $intout, %rdi");
    puts("\tcall printf");
}

void print_new_line() {
    puts("\tmovq $'\\n', %rdi");
    puts("\tcall putchar");
}