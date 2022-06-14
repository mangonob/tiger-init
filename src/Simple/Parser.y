{
module Simple.Parser where

import Control.Monad (liftM2, (>>=))
import Control.Monad.State (State, put, get)
import Simple.AbSyn
import Simple.Token (intValue, doubleValue, pos)
import qualified Simple.Lexer as L
import qualified Simple.Token as T
}

%name parse
%monad { L.Alex }
%lexer { L.alexMonadScan >>= } { T.EOF _ }
%tokentype { T.Token L.AlexPosn }
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

%nonassoc   DO
%nonassoc   else
%left       '+' '-'
%left       '*' '/'
%left       UMINUS

%%

Expr_ :: { State [(String, Double)] (Either () Double) }
Expr_       : let id '=' Expr       { do
                value <- $4
                env <- get
                put (($2, value):env)
                return (Left ())
            }
            | Expr                  { fmap Right $1 }
            | if Expr then Expr %prec DO        { do
                pre <- $2
                if pre > 0 then fmap Right $4 else return (Left ())
            }
            | if Expr then Expr else Expr       { do
                pre <- $2
                if pre > 0 then fmap Right $4 else fmap Right $6
            }

Expr :: { State [(String, Double)] Double }
Expr        : Expr '+' Expr         { liftM2 (+) $1 $3 }
            | Expr '-' Expr         { liftM2 (-) $1 $3 }
            | Expr '*' Expr         { liftM2 (*) $1 $3 }
            | Expr '/' Expr         { liftM2 (/) $1 $3 }
            | id                    { do 
                env <- get
                case lookup $1 env of
                    Nothing -> error $ "id: " ++ show $1 ++ " not found."
                    Just value -> return value
            }
            | integer               { return (fromIntegral $1) }
            | double                { return $1 }
            | '-' Expr %prec UMINUS { fmap (0-) $2 }
            | '(' Expr ')'          { $2 }

{
parseError :: T.Token L.AlexPosn -> L.Alex a
parseError t = error $ "parse error at token " ++ show t ++ " (" ++ show (pos t) ++ ")"
}