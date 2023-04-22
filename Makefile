ALL:
	@rm -f lex.yy.c parser.tab.* 
	@clear
	@bison -d parser.y
	@flex flex.l
	@gcc -o parser lex.yy.c parser.tab.c -lfl

clean:
	@rm -f lex.yy.c parser.tab.* 
	@clear