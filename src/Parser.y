{
module Parser where

import AbSyn
import Lexer (AlexPosn(..), Alex, alexMonadScan, alexError, alexGetInput)
import Token (Token, pos, intValue, idValue, stringValue)
import qualified Token as T
}

%name parser
%monad { Alex }
%lexer { alexMonadScan >>= } { T.EOF _ }
%tokentype { Token AlexPosn }
%error { parseError }

%token

while                   { T.While _ }
for                     { T.For _ }
to                      { T.To _ }
break                   { T.Break _ }
let                     { T.Let _ }
in                      { T.In _ }
end                     { T.End _ }
function                { T.Function _ }
var                     { T.Var _ }
type                    { T.Type _  }
array                   { T.Array _ }
if                      { T.If _ }
then                    { T.Then _ }
else                    { T.Else _ }
do                      { T.Do _ }
of                      { T.Of _ }
nil                     { T.Nil _ }
','                     { T.Comma _ }
':'                     { T.Colon _ }
';'                     { T.Semicolon _  }
'('                     { T.LeftParen _ }
')'                     { T.RightParen _ }
'['                     { T.LeftBracket _ }
']'                     { T.RightBracket _ }
'{'                     { T.LeftBrace _ }
'}'                     { T.RightBrace _ }
'.'                     { T.Dot _ }
'+'                     { T.Plus _ }
'-'                     { T.Minus _ }
'*'                     { T.Times _ }
'/'                     { T.Divide _ }
'='                     { T.Eq _ }
'<>'                    { T.NotEq _ }
'<'                     { T.Lt _ }
'<='                    { T.Le _ }
'>'                     { T.Gt _ }
'>='                    { T.Ge _ }
'&'                     { T.And _ }
'|'                     { T.Or _ }
':='                    { T.Assign _ }
string                  { T.String _ _ }
int                     { T.Int _ _ }
id                      { T.ID _ _ }

%nonassoc do of
%nonassoc else
%nonassoc ':='
%left '&' '|'
%nonassoc '>' '>=' '<' '<=' '<>' '='
%left '+' '-'
%left '*' '/'
%left '[' '{'
%left UMINUS

%%

expr :: { Expr }
expr        : int                                   { IntExpr (intValue $1) @ $1 }
            | string                                { StringExpr (stringValue $1) @ $1 }
            | nil                                   { NilExpr @ $1 }
            | lvalue                                { VarExpr $1 }
            | lvalue ':=' expr                      { AssignExpr $1 $3 @ $2 }
            | '(' ')'                               { SeqExpr [] @ $1 }
            | '(' expr_seq ')'                      { SeqExpr $2 @ $1 }
            | '-' expr %prec UMINUS                 { UMinus $2 @ $1 }
            | id '(' ')'                            { Call (idValue $1) [] @ $2 }
            | id '(' params ')'                     { Call (idValue $1) $3 @ $2 }
            | expr '+' expr                         { OpExpr $1 PlusOp $3 @ $2 }
            | expr '-' expr                         { OpExpr $1 MinusOp $3 @ $2 }
            | expr '*' expr                         { OpExpr $1 TimesOp $3 @ $2 }
            | expr '/' expr                         { OpExpr $1 DivideOp $3 @ $2 }
            | expr '=' expr                         { OpExpr $1 EqOp $3 @ $2 }
            | expr '<>' expr                        { OpExpr $1 NeqOp $3 @ $2 }
            | expr '<' expr                         { OpExpr $1 LtOp $3 @ $2 }
            | expr '<=' expr                        { OpExpr $1 LeOp $3 @ $2 }
            | expr '>' expr                         { OpExpr $1 GtOp $3 @ $2 }
            | expr '>=' expr                        { OpExpr $1 GeOp $3 @ $2 }
            | expr '&' expr                         { IFExpr $1 $3 (Just zero) @ $2 }
            | expr '|' expr                         { IFExpr $1 one (Just $3) @ $2 }
            | id '{' '}'                            { RecordsExpr (idValue $1) [] @ $1 }
            | id '{' records '}'                    { RecordsExpr (idValue $1) $3 @ $1 }
            | id '[' expr ']' of expr               { ArrayExpr (idValue $1) $3 $6 @ $1 }
            | if expr then expr %prec do            { IFExpr $2 $4 Nothing @ $1 }
            | if expr then expr else expr           { IFExpr $2 $4 (Just $6) @ $1 }
            | while expr do expr                    { WhileExpr $2 $4 @ $1 }
            | for id ':=' expr to expr do expr      { ForExpr (idValue $2) $4 $6 $8 False @ $1 }
            | break                                 { BreakExpr @ $1 }
            | let decs in end                       { LetExpr $2 (SeqExpr [] @ $4) @ $1 }
            | let decs in expr_seq end              { LetExpr $2 (SeqExpr $4 @ $5) @ $1 }

lvalue :: { Var }
lvalue      : id                                    { simpleVar $1 }
            | lvalue2                               { $1 }

lvalue2 :: { Var }
lvalue2     : id '.' id                             { FieldVar (simpleVar $1) (idValue $3) @ $2 }
            | id '[' expr ']'                       { IndexedVar (simpleVar $1) $3 @ $2 }
            | lvalue2 '.' id                        { FieldVar $1 (idValue $3) @ $2 }
            | lvalue2 '[' expr ']'                  { IndexedVar $1 $3 @ $2 }

expr_seq :: { [Expr] }
expr_seq    : expr                                  { [$1] }
            | expr_seq ';' expr                     { $1 ++ [$3] }

params :: { [Expr] }
params      : expr                                  { [$1] }
            | params ',' expr                       { $1 ++ [$3] }

records :: { [Field] }
records     : field                                 { [$1] }
            | records ',' field                     { $1 ++ [$3] }

field :: { Field }
field       : id '=' expr                           { Field (idValue $1) $3 @ $1 }

decs :: { [Dec] }
decs        : {- empty -}                           { [] }
            | decs dec                              { $1 ++ [$2] }

dec :: { Dec }
dec         : type id '=' ty                        { TypeDec (idValue $2) $4 @ $1 }
            | var id ':=' expr                      { VarDec (idValue $2) $4 Nothing False @ $1 }
            | var id ':' id ':=' expr               { VarDec (idValue $2) $6 (Just (idValue $4)) False @ $1 }
            | function id '(' ty_fields ')' '=' expr   
                                                    { FuncDec (idValue $2) $4 Nothing $7 @ $1 } 
            | function id '(' ty_fields ')' ':' id '=' expr    
                                                    { FuncDec (idValue $2) $4 (Just (idValue $7)) $9 @ $1 }

ty :: { Type }
ty          : id                                    { SimpleType (idValue $1) @ $1 }
            | '{' ty_fields '}'                     { Records $2 @ $1 }
            | array of id                           { Array (idValue $3) @ $1 }

ty_fields :: { [Record] }
ty_fields   : {- empty -}                           { [] }
            | ty_fields1                            { $1 }

ty_fields1 :: { [Record] }
ty_fields1  : ty_field                              { [$1] }
            | ty_fields1 ',' ty_field               { $1 ++ [$3] }

ty_field :: { Record }
ty_field    : id ':' id                             { Record (idValue $1) (idValue $3) False @ $1 }

{
parseError :: Token AlexPosn -> Alex a
parseError t = alexError $ "parse error at token " ++ show t

simpleVar :: Token AlexPosn -> Var
simpleVar t = SimpleVar (idValue t) (pos t)

(@) :: (AlexPosn -> a) -> Token AlexPosn -> a
f @ t = f (pos t)
}