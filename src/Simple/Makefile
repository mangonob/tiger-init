all: lexer parser

lexer:
	alex -gi Lexer.x

parser:
	happy -gi Parser.y

clean:
	rm *.info
	-rm Lexer.hs
	-rm Parser.hs
