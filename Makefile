all: lexer parser
	stack build
	stack ghci src/Simple/Main.hs

lexer: src/Simple/Lexer.hs

parser: src/Simple/Parser.hs

src/Simple/Lexer.hs: src/Simple/Lexer.x
	alex -gi src/Simple/Lexer.x

src/Simple/Parser.hs: src/Simple/Parser.y
	happy -gi src/Simple/Parser.y

clean:
	-rm src/Simple/Lexer.hs
	-rm src/Simple/Lexer.info
	-rm src/Simple/Parser.hs
	-rm src/Simple/Parser.info
