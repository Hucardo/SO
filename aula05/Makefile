CC=gcc
CFLAGS=-Wall -std=c17

LIBS=-lrt -lm

TARGETS= args1 args2 higherlowergame calculadora calculadora_strtod

all: $(TARGETS)

args1: args1.c
	$(CC) $(CFLAGS) -o $@ $<

args2: args2.c
	$(CC) $(CFLAGS) -o $@ $<

higherlowergame: higherlowergame.c
	$(CC) $(CFLAGS) -o $@ $<

calculadora: calculadora.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

calculadora_strtod: calculadora_strtod.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

.PHONY: clean
clean:
	rm -f $(TARGETS)
