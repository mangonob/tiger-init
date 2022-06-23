{
module Simple.Parser where

import Control.Monad (liftM2, (>>=))
import Control.Monad.State (State, put, get)
import Simple.AbSyn
import Simple.Token (Token)
import Simple.Lexer (Alex, AlexPosn, alexMonadScan, alexError)
import qualified Simple.Token as T
}

%name parse
%monad { Alex }
%lexer { alexMonadScan >>= } { T.EOF _ }
%tokentype { Token AlexPosn }
%error { parseError }

%token

let             { T.Let _ }
if              { T.If _ }
then            { T.Then _ }
else            { T.Else _ }
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
';'             { T.Semicolon _ }

%nonassoc   DO
%nonassoc   else
%left       '+' '-'
%left       '*' '/'
%left       UMINUS

%%

Prog :: { [Expr] }
Prog        : {- empty -}           { [] }
            | Seq                   { $1 }

Seq :: { [Expr] }
Seq         : Expr                  { [$1] }
            | Seq ';' Expr          { $3 : $1 }

Expr :: { Expr }
Expr        : Expr '+' Expr         { Add $1 $3 }
            | Expr '-' Expr         { Sub $1 $3 }
            | Expr '*' Expr         { Mul $1 $3 }
            | Expr '/' Expr         { Div $1 $3 }
            | id                    { Id $1 }
            | integer               { Int $1 }
            | double                { Double $1 }
            | let id '=' Expr %prec DO          { Let $2 $4 }
            | if Expr then Expr %prec DO        { If $2 $4 Nothing }
            | if Expr then Expr else Expr       { If $2 $4 (Just $6) }
            | '-' Expr %prec UMINUS { Minus $2 }
            | '(' Expr ')'          { Brack $2 }

{
parseError :: Token AlexPosn -> Alex a
parseError t = alexError $ "parse error at token " ++ show t
}