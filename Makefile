.PHONY: all hashtables

all: compiler debugger

flex: lexer.l lexer.h
	@flex lexer.l

bison: syntax.y
	@bison -d -v syntax.y

hashtables: hashtables/hashtbl.h hashtables/hashtbl.c
	@gcc -c hashtables/hashtbl.c -o hashtables/hashtbl.o

compiler: flex bison hashtables
	@gcc -DDEBUG=0 lex.yy.c syntax.tab.c hashtables/hashtbl.o -o parser
	@echo "Compiler created!"

debugger: flex bison hashtables
	@gcc -DDEBUG=1 lex.yy.c syntax.tab.c hashtables/hashtbl.o -o debugger
	@echo "Debugger created!"

clean:
	@rm -f lex.yy.c parser.tab.* parser* *.out syntax.tab.c syntax.tab.h syntax.output debugger* hashtables/*.o
	@clear