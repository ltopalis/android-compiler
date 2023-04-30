.PHONY: all hashtables

all: compiler debugger

flex: lexer.l lexer.h
	@flex lexer.l

bison: syntax.y
	@bison -d -v syntax.y

hashtables: extras/hashtbl.h extras/hashtbl.c
	@gcc -c extras/hashtbl.c -o extras/hashtbl.o

semantic: extras/semantic.c extras/semantic.h
	@gcc -c extras/semantic.c -o extras/semantic.o

compiler: flex bison hashtables semantic
	@gcc -DDEBUG=0 lex.yy.c syntax.tab.c extras/hashtbl.o extras/semantic.o -o parser
	@echo "Compiler created!"

debugger: flex bison hashtables semantic
	@gcc -DDEBUG=1 lex.yy.c syntax.tab.c extras/hashtbl.o extras/semantic.o -o debugger
	@echo "Debugger created!"

clean:
	@rm -f lex.yy.c parser.tab.* parser* *.out syntax.tab.c syntax.tab.h syntax.output debugger* extras/*.o
	@clear