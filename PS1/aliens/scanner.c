#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

#include "pencil.h"


/*
 * This function is called before anything else, to initialize the
 * state machine. It is certainly possible to create implementations
 * which don't require any initialization, so just leave this blank if
 * you don't need it.
 */


void
init_transtab(void) {

}


/*
 * Return the next token from reading the given input stream.
 * The words to be recognized are 'turn', 'draw' and 'move',
 * while the returned tokens may be TURN, DRAW, MOVE or END (as
 * enumerated in 'pencil.h').
 */
command_t
next(FILE *input) {

}
