#include <stdio.h>
#include <sys/time.h>

#include "tetris.h"

void tetris() {

  time_t now = 0;
  time_t last_exe = 0;

  while (1) {

    // get system time in ms
    struct timeval tv;
    gettimeofday(&tv,NULL);
    now = (((long long)tv.tv_sec)*1000)+(tv.tv_usec/1000);
    // printf("%ld\n", now);

    for (int i = 0; i < ROWS; i++) {
        board[i][1] = GREEN;
        board[i][1] |= 0x80;

        board[i][3] = RED;
        board[i][3] |= 0x80;

        board[i][5] = BLUE;
        board[i][5] |= 0x80;
    }

    if (now - last_exe > REFRESH) {
      last_exe = now;
      print_board();
    }

  }
}

void print_board() {
  printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXX\nXX                        XX\n");
  for (int i = 0; i < ROWS; i++) {
    printf("XX  ");
    for (int j = 0; j < COLS; j++) {
      switch (board[i][j] & 0x0F) {
        case RED: printf("\033[0;31m"); break;
        case BLUE: printf("\033[0;32m"); break;
        case GREEN: printf("\033[0;34m"); break;
      }

      if (board[i][j] & 0xF0)
        printf("██");
      else
        printf("  ");
      printf("\033[0m");
    }
    printf("  XX\n");
  }
  printf("XX                        XX\nXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n");
}
