#include <string.h>

#include "tetris.h"

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
