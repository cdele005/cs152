FLEX = flex
COMPILE = gcc
FLAGS = -lfl
FILE = mini_l.lex
CFILE = lex.yy.c
EXEC = lexer
MIN = primes.min
MIN2 = mytest.min 

all: $(FILE)
	$(FLEX) $(FILE)
	$(COMPILE) -o $(EXEC) $(CFILE) $(FLAGS)

test: all
	cat $(MIN) | $(EXEC)

test2: all
	cat $(MIN2) | $(EXEC)

open:
	vim $(FILE)

clean: 
	rm -f $(EXEC) $(CFILE)

