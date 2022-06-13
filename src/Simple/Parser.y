{
module Simple.Parser where

import Control.Monad (liftM2)
import Control.Monad.State (State, put, get)
import Simple.AbSyn
import Simple.Token (intValue, doubleValue, pos)
import qualified Simple.Lexer as L
import qualified Simple.Token as T
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

Expr_ :: { State [(String, Double)] (Either () Double) }
Expr_       : let id '=' Expr       { do
                value <- $4
                env <- get
                put (($2, value):env)
                return (Left ())
            }
            | Expr                  { fmap Right $1 }

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
            | '(' Expr ')'          { $2 }

{
parseError :: [T.Token L.AlexPosn] -> a
parseError [] = error "parse error"
parseError (t:_) = error $ "parse error at token " ++ show t ++ " (" ++ show (pos t) ++ ")"
}