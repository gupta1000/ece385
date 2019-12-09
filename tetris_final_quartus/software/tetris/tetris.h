#ifndef tetris_h
#define tetris_h

#include <stdlib.h>
#include <sys/time.h>

#define ROWS 20
#define COLS 10
#define REFRESH 300
#define REFRESH_KB 32

#define WHITE 0x0e
#define DARK_GRAY 0x0d
#define LIGHT_GRAY 0x0c

#define UP_KEY 0x52
#define DOWN_KEY 0x51
#define LEFT_KEY 0x50
#define RIGHT_KEY 0x4f
#define SPACE_KEY 0x2c

volatile int kb_char;
volatile int game;
volatile unsigned long long now;
volatile unsigned long long del_white;

volatile unsigned score;

char board[ROWS][COLS];

int pp, px, py, pr, sy, blink;

int is_valid(int p, int r, int x, int y);

int move_down();

int shadow();

int move_left();

int move_right();

void drop();

void rotate();

void next_piece();

void commit2board(int p, int r, int x, int y);

void clear_board();

void delete_rows();

void flash_complete_rows();

void draw2hardware(volatile unsigned int * base);

#endif
