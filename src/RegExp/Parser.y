{
module RegExp.Parser where

import RegExp.AbSyn
import RegExp.Lexer (Alex, AlexPosn, alexMonadScan, alexError)
import RegExp.Token (Token)
import qualified RegExp.Token as T
}

%name parse
%monad { Alex }
%lexer { alexMonadScan >>= } { T.EOF _ }
%tokentype { Token AlexPosn }
%error { parseError }

%token

'('         { T.ParenLeft _ }
')'         { T.ParenRight _ }
'['         { T.BracketLeft _ }
']'         { T.BracketRight _ }
'{'         { T.BraceLeft _ }
'}'         { T.BraceRight _ }
'-'         { T.Minus _ }
'+'         { T.Plus  _ }
'?'         { T.Question _ }
'|'         { T.Channel _ }
'^'         { T.Caret _ }
','         { T.Comma _ }
'$'         { T.Dollar _ }
'*'         { T.Star _ }
'/'         { T.Slash _ }
ch          { T.Char $$ _ }
int         { T.Int $$ _ }

%nonassoc   Nonull
%left       '|'
%left       ch 
%left       Con
%left       '{' '[' '(' 
%left       '+' '?' '*'
%nonassoc   '-'
%left       '$' '^'

%%

reg_exps :: { RegExps }
reg_exps    : reg_exp0                      { RegExps $1 [] }
            | '/' reg_exp0 '/' flags        { RegExps $2 $4 }

flags :: { [Flag] }
flags       : {- empty -}                   { [] }
            | flags ch                      { Flag $2 : $1 }

reg_exp0 :: { RegExp }
reg_exp0    : {- empty -}                   { Empty }
            | reg_exp %prec Nonull          { $1 }
            | reg_exp0 '|' reg_exp0         { Or $1 $3 }

reg_exp :: { RegExp }
reg_exp     : ch                            { Char $1 }
            | reg_exp reg_exp %prec Con     { Concat $2 $1 }
            | reg_exp '{' int '}'           { Repeat $1 $3 Nothing }
            | reg_exp '{' int ',' int '}'   { Repeat $1 $3 (Just $5) }
            | reg_exp '?'                   { Optional $1 }
            | reg_exp '+'                   { Require $1 }
            | reg_exp '*'                   { Closure $1 }
            | '(' reg_exp0 ')'              { Group $2 }
            | '[' char_sets ']'             { CharSets $2 False }
            | '[' '^' char_sets ']'         { CharSets $3 True }
            | '^'                           { LineStart }
            | '$'                           { LineEnd }

char_sets :: { [CharSet] }
char_sets   : {- empty -}                   { [] }
            | char_sets char_set            { $2 : $1 }

char_set :: { CharSet }
char_set    : ch '-' ch                     { Range $1 $3 }
            | ch                            { Only $1 }

{
parseError :: Token AlexPosn -> Alex a
parseError t = alexError $ "parse error at token " ++ show t
}