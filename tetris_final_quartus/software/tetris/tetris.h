#ifndef tetris_h
#define tetris_h

#include <sys/time.h>

#define ROWS 20
#define COLS 10
#define REFRESH 500
#define REFRESH_KB 100

#define RED 1
#define BLUE 2
#define GREEN 3
#define YELLOW 4

#define UP_KEY 0x52
#define DOWN_KEY 0x51
#define LEFT_KEY 0x50
#define RIGHT_KEY 0x4f
#define SPACE_KEY 0x2c

volatile int kb_char;
volatile int game;
volatile time_t now;

char board[ROWS][COLS];

int pp, px, py, pr;

int is_valid(int p, int r, int x, int y);

int move_down();

int move_left();

int move_right();

void drop();

void rotate();

void next_piece();

void commit2board(int p, int r, int x, int y);

void draw2hardware(volatile unsigned char * base);

#endif
