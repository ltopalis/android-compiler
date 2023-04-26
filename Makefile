ALL:
	@rm -f lex.yy.c parser.tab.* parser.* *.out
	@clear
	@flex lexer.l
	@bison -d syntax.y
	@gcc lex.yy.c syntax.tab.c -o parser

clean:
	@rm -f lex.yy.c parser.tab.* parser.* *.out syntax.tab.c syntax.tab.h syntax.output
	@clear