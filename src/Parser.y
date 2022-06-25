{
module Parser where

import AbSyn
import Lexer (AlexPosn, Alex, alexMonadScan, alexError)
import Token (Token)
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
string                  { T.String $$ _ }
int                     { T.Int $$ _ }
id                      { T.ID $$ _ }

%nonassoc POSN
%nonassoc do of
%nonassoc else
%nonassoc ':='
%left '&' '|'
%nonassoc '>' '>=' '<' '<=' '<>' '='
%left '+' '-'
%left '*' '/'
%left UMINUS

%%

expr :: { Expr }
expr        : int                                   { IntExpr $1 (pos $1) }
            | string                                { StringExpr $1 (pos $1) }
            | nil                                   { NilExpr (pos $1) }
            | lvalue                                { VarExpr $1 }
            | lvalue ':=' expr                      { AssignExpr $1 $3 (pos $2) }
            | '(' ')'                               { SeqExpr [] (pos $2)}
            | '(' expr_seq ')'                      { SeqExpr $2 (pos $3)}
            | '-' expr %prec UMINUS                 { UMinus $2 (pos $1)}
            | id '(' ')'                            { Call $1 [] (pos $1) }
            | id '(' params ')'                     { Call $1 $3 (pos $1) }
            | expr '+' expr                         { OpExpr $1 PlusOp $3 (pos $2) }
            | expr '-' expr                         { OpExpr $1 MinusOp $3 (pos $2) }
            | expr '*' expr                         { OpExpr $1 TimesOp $3 (pos $2) }
            | expr '/' expr                         { OpExpr $1 DivideOp $3 (pos $2) }
            | expr '=' expr                         { OpExpr $1 EqOp $3 (pos $2) }
            | expr '<>' expr                        { OpExpr $1 NeqOp $3 (pos $2) }
            | expr '<' expr                         { OpExpr $1 LtOp $3 (pos $2) }
            | expr '<=' expr                        { OpExpr $1 LeOp $3 (pos $2) }
            | expr '>' expr                         { OpExpr $1 GtOp $3 (pos $2) }
            | expr '>=' expr                        { OpExpr $1 GeOp $3 (pos $2) }
            | expr '&' expr                         { IFExpr $1 $3 (Just zero) (pos $2) }
            | expr '|' expr                         { IFExpr $1 one (Just $3) (pos $2) }
            | id '{' '}'                            { RecordsExpr $1 [] (pos $1) }
            | id '{' records '}'                    { RecordsExpr $1 $3 (pos $1) }
            | id '[' expr ']' of expr               { ArrayExpr $1 $3 $6 (pos $1) }
            | if expr then expr %prec do            { IFExpr $2 $4 Nothing (pos $1) }
            | if expr then expr else expr           { IFExpr $2 $4 (Just $6) (pos $1) }
            | while expr do expr                    { WhileExpr $2 $4 (pos $1) }
            | for id ':=' expr to expr do expr      { ForExpr $2 $4 $6 $8 False (pos $1)}
            | break                                 { BreakExpr (pos $1) }
            | let decs in end                       { LetExpr $2 (SeqExpr [] (pos $4)) (pos $1) }
            | let decs in expr_seq end              { LetExpr $2 (SeqExpr $4 (pos $5)) (pos $1) }

lvalue :: { Var }
lvalue      : id            { simpleVar $1 }
            | lvalue_       { $1 }

lvalue_ :: { Var }
lvalue_     : id '.' id                             { FieldVar $1 $3 (pos $2) }
            | id '[' expr ']'                       { IndexedVar $1 $3 (pos $2)} 
            | lvalue_ '.' id                        { FieldVar $1 $3 (pos $2) }
            | lvalue_ '[' expr ']'                  { IndexedVar $1 $3 (pos $2) }

expr_seq :: { [Expr] }
expr_seq    : expr                                  { [$1] }
            | expr_seq ';' expr                     { $1 ++ [$3]}

params :: { [Expr] }
params      : expr                                  { [$1] }
            | params ',' expr                       { $1 ++ [$3] }

records :: { [Field] }
records     : field                                 { [$1] }
            | records ',' field                     { $1 ++ [$3] }

field :: { Field }
field       : id '=' expr                           { Field $1 $3 (pos $1) }

decs :: { [Dec] }
decs        : {- empty -}                           { [] }
            | decs dec                              { $1 ++ [$2] }

dec :: { Dec }
dec         : type id '=' ty                        { TypeDec $2 $4 (pos $1)}
            | var id ':=' expr                      { VarDec $2 $4 Nothing False (pos $1)}
            | var id ':' id ':=' expr               { VarDec $2 $6 (Just $4) False (pos $1)}
            | function id '(' ty_fields ')' '=' expr    { FuncDec $2 $4 Nothing $7 (pos $1)} 
            | function id '(' ty_fields ')' ':' id '=' expr    { FuncDec $2 $4 (Just $7) $9 (pos $1)}

ty :: { Type }
ty          : id                                    { SimpleType $1 (pos $1) }
            | '{' ty_fields '}'                     { Records $2 (pos $1) }
            | array of id                           { Array $3 (pos $1) }

ty_fields :: { [Record] }
ty_fields   : {- empty -}                           { [] }
            | ty_fields_                            { $1 }

ty_fields_ :: { [Record] }
ty_fields_  : ty_field                              { [$1] }
            | ty_fields_ ',' ty_field               { $1 ++ [$3] }

ty_field :: { Record }
ty_field    : id ':' id                             { Record $1 $3 False (pos $1) }

{
parseError :: Token AlexPosn -> Alex a
parseError t = alexError $ "parse error at token " ++ show t

simpleVar :: Token AlexPosn -> Var
simpleVar t = SimpleVar t (pos t)
}