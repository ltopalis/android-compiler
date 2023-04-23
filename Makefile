ALL:
	@rm -f lex.yy.c parser.tab.* parser.* *.out
	@clear
	@flex lexer.l
	@gcc lex.yy.c

clean:
	@rm -f lex.yy.c parser.tab.* parser.* *.out
	@clear