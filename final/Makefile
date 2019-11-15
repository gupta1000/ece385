EXENAME = tetris
OBJS = main.o tetris.o

CXX = gcc
CXXFLAGS = -c -g -O0 -Wall -Wextra -pedantic
LD = clang
LDFLAGS = -lpng -lpthread -lm

all : $(EXENAME)

$(EXENAME) : $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $(EXENAME)

main.o : main.c
	$(CXX) $(CXXFLAGS) main.c

tetris.o : tetris.c tetris.h
	$(CXX) $(CXXFLAGS) tetris.c
