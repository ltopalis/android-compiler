ALL:
	@clear;
	@bison -d parser.y
	@flex flex.l
	@gcc -o parser lex.yy.c parser.tab.c -lfl

clean:
	@rm lex.yy.c parser.tab.* 