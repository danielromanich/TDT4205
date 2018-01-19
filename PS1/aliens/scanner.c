#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "pencil.h"

uint8_t validateState(uint8_t, uint8_t);
uint8_t getState(uint8_t, char);

//O, N, E, F, U, R, S, T, P, W, H
uint8_t trans_table[19][11] = {{1,  0, 0,  4, 0, 0,  8, 12, 0,  0,  0}, //1
                               {0,  2, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //2
                               {0,  0, 3,  0, 0, 0,  0, 0,  0,  0,  0}, //3
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //4 ONE
                               {5,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //5
                               {0,  0, 0,  0, 6, 0,  0, 0,  0,  0,  0}, //6
                               {0,  0, 0,  0, 0, 7,  0, 0,  0,  0,  0}, //7
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //8 FOUR
                               {0,  0, 0,  0, 0, 0,  0, 9,  0,  0,  0}, //9
                               {10, 0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //10
                               {0,  0, 0,  0, 0, 0,  0, 0,  11, 0,  0}, //11
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //12 STOP
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  13, 15}, //13
                               {14, 0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //14
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}, //15 TWO
                               {0,  0, 0,  0, 0, 16, 0, 0,  0,  0,  0}, //16
                               {0,  0, 17, 0, 0, 0,  0, 0,  0,  0,  0}, //17
                               {0,  0, 18, 0, 0, 0,  0, 0,  0,  0,  0}, //18
                               {0,  0, 0,  0, 0, 0,  0, 0,  0,  0,  0}}; //19 THREE
/*
 * This function is called before anything else, to initialize the
 * state machine. It is certainly possible to create implementations
 * which don't require any initialization, so just leave this blank if
 * you don't need it.
 */
void
init_transtab(void) {

}

uint8_t getState(uint8_t state, char c) {
    switch (c) {
        case 'o':
            return validateState(state, trans_table[state][0]);
        case 'n':
            return validateState(state, trans_table[state][1]);
        case 'e':
            return validateState(state, trans_table[state][2]);
        case 'f':
            return validateState(state, trans_table[state][3]);
        case 'u':
            return validateState(state, trans_table[state][4]);
        case 'r':
            return validateState(state, trans_table[state][5]);
        case 's':
            return validateState(state, trans_table[state][6]);
        case 't':
            return validateState(state, trans_table[state][7]);
        case 'p':
            return validateState(state, trans_table[state][8]);
        case 'w':
            return validateState(state, trans_table[state][9]);
        case 'h':
            return validateState(state, trans_table[state][10]);
    }
    return state;
}

uint8_t validateState(uint8_t state, uint8_t next_state) {
    return next_state == 0 ? state : next_state;
}


/*
 * Return the next token from reading the given input stream.
 * The words to be recognized are 'turn', 'draw' and 'move',
 * while the returned tokens may be TURN, DRAW, MOVE or END (as
 * enumerated in 'pencil.h').
 */
//S(3) == ONE, S(7) == FOUR, S(11) == STOP, S(14) = TWO, S(18) = THREE
command_t next(FILE *input) {
    uint8_t state = 0;
    char *str = "two";
    for (int i = 0; i < 3; i++) {
        state = getState(state, str[i]);
        printf("Char: %c, State: %d\n", str[i], state);
        switch (state) {
            case 3:
                return ONE;
            case 7:
                return FOUR;
            case 11:
                return STOP;
            case 14:
                return TWO;
            case 18:
                return THREE;
        }
    }
    return STOP;
}
