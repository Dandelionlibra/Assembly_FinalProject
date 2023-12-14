CC:= gcc
CFLAGS:= -Wall -g
files:= main.c name.s id.s drawJuliaSet.s

all: $(files)
	$(CC) $(CFLAGS) -o main $(files)