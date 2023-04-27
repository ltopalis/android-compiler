all: compiler debugger

flex: lexer.l lexer.h
	@flex lexer.l

bison: syntax.y
	@bison -d -v syntax.y

compiler: flex bison
	@gcc -DDEBUG=0 lex.yy.c syntax.tab.c -o parser
	@echo "Compiler created!"

debugger: flex bison
	@gcc -DDEBUG=1 lex.yy.c syntax.tab.c -o debugger
	@echo "Debugger created!"

clean:
	@rm -f lex.yy.c parser.tab.* parser* *.out syntax.tab.c syntax.tab.h syntax.output debugger*
	@clear