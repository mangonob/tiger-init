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

%%

Expr        : Expr '+' Term         { $1 + $3 }
            | Expr '-' Term         { $1 - $3 }
            | Term                  { $1 }

Term        : Term '*' Factor       { $1 * $3 }
            | Term '/' Factor       { $1 / $3 }
            | Factor                { $1 }

Factor      : id                    { undefined }
            | integer               { fromIntegral $1 }
            | double                { $1 }
            | '(' Expr ')'          { $2 }

{
parseError = [T.Token L.AlexPosn] -> a
parseError [] = error "parse error"
parseError (t:_) = error $ "parse at " ++ show t
}