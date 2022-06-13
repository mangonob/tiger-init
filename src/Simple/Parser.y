{
module Simple.Parser where

import qualified Simple.Token as T
import Simple.Token (intValue, doubleValue, pos)
import qualified Simple.Lexer as L
import Simple.AbSyn
}

%name parse
%tokentype { T.Token L.AlexPosn }
%error { parseError }

%token

let             { T.Let _ }
id              { T.IdToken $$ _ }
integer         { T.IntToken $$ _ }
double          { T.DoubleToken $$ _ }
'+'             { T.Plus _ }
'-'             { T.Minus _ }
'*'             { T.Mul _ }
'/'             { T.Div _ }
'('             { T.LeftParen _ }
')'             { T.RightParen _ }
'='             { T.Assign _ }

%left       '+' '-'
%left       '*' '/'

%%

Expr_       : let id '=' Expr       { Let $2 $4 }

Expr        : Expr '+' Expr         { Add $1 $3 }
            | Expr '-' Expr         { Sub $1 $3 }
            | Expr '*' Expr         { Mul $1 $3 }
            | Expr '/' Expr         { Div $1 $3 }
            | id                    { Id $1 }
            | integer               { Int $1 }
            | double                { Double $1 }
            | '(' Expr ')'          { Brack $2 }

{
parseError :: [T.Token L.AlexPosn] -> a
parseError [] = error "parse error"
parseError (t:_) = error $ "parse error at token " ++ show t ++ " (" ++ show (pos t) ++ ")"
}