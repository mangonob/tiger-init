dest = src

all: lexer parser
	stack build
	stack install

run: lexer parser
	stack build
	$(MAKE) repl

lexer: $(dest)/Lexer.hs

parser: $(dest)/Parser.hs

repl:
	stack ghci $(dest)/Main.hs

$(dest)/Lexer.hs: $(dest)/Lexer.x
	alex -gi $(dest)/Lexer.x

$(dest)/Parser.hs: $(dest)/Parser.y
	happy -gi $(dest)/Parser.y

clean:
	-rm $(dest)/Lexer.hs
	-rm $(dest)/Lexer.info
	-rm $(dest)/Parser.hs
	-rm $(dest)/Parser.info
