#include <stdio.h>
#include <sys/time.h>
#include <pthread.h>
#include <string.h>

#include "tetris.h"

void tetris() {
  time_t last_exe = 0;

  pthread_t kb_id;
  pthread_create(&kb_id, NULL, kb_thread, NULL);

  game = 1;

  while (game) {
    // get system time in ms
    struct timeval tv;
    gettimeofday(&tv,NULL);
    now = (((long long)tv.tv_sec)*1000)+(tv.tv_usec/1000);

    if (now - last_exe > REFRESH) {
      last_exe = now;

      move_down();
      if (now % 4 == 0)
        rotate();
      if (now % 5 == 0)
        move_right();
      if (now % 6 == 0)
        move_left();
      if (now % 20 == 0)
        drop();

      print_board();
    }

  }

  pthread_join(kb_id, NULL);

}

int move_down() {
  if (is_valid(pp, pr, px, py+1)) {
    py++;
    return 1;
  }
  commit2board(pp, pr, px, py);
  next_piece();
  return 0;
}

int move_left() {
  if (is_valid(pp, pr, px-1, py)) {
    px--;
    return 1;
  }
  return 0;
}

int move_right() {
  if (is_valid(pp, pr, px+1, py)) {
    px++;
    return 1;
  }
  return 0;
}

void drop() {
  while (move_down());
}

void next_piece() {
  // end game logic here
  pp=now%7;
  py = 0; pr = 0; px = now%(COLS-4); // COLS/2-2;
  if (!is_valid(pp, pr, px, py))
    game = 0;
}

void rotate() {
  if (is_valid(pp, (pr+1)%4, px, py))
    pr = (pr+1)%4;
}

int is_valid(int p, int r, int x, int y) {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++)
      if (pieces[p][r][i][j] && ((x+j >= COLS || y+i >= ROWS || x+j < 0 || y+i < 0) || board[y+i][x+j])) {
        return 0;
      }
  return 1;
}

void commit2board(int p, int r, int x, int y) {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++)
      if (pieces[p][r][i][j])
        board[y+i][x+j] = pieces[p][r][i][j];

  /////////////////////////////////////////////////////////////////////////////
  // TODO: destroy any complete rows!!!
}

void print_board() {
  char p_board[ROWS][COLS];
  memcpy(p_board, board, ROWS*COLS);
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++)
      if (pieces[pp][pr][i][j])
        p_board[py+i][px+j] = pieces[pp][pr][i][j];

  printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXX                        XX\n");
  for (int i = 0; i < ROWS; i++) {
    printf("XX  ");
    for (int j = 0; j < COLS; j++) {
      switch (p_board[i][j] & 0x0F) {
        case RED: printf("\033[0;31m"); break;
        case BLUE: printf("\033[0;32m"); break;
        case GREEN: printf("\033[0;34m"); break;
        case YELLOW: printf("\033[0;33m"); break;
      }

      if (p_board[i][j] & 0xF0)
        printf("██");
      else
        printf("  ");

      printf("\033[0m");
    }
    printf("  XX\n");
  }
  printf("XX                        XX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n");
}


void * kb_thread() {
  time_t last_exe = 0;

  int i = 0;

  kb_buf[2] = 23;

  while (game) {

    if (now - last_exe > REFRESH_KB) {
      last_exe = now;
      kb_char = kb_buf[i++];
    }
  }

  return NULL;
}
