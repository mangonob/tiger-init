{
module Lexer where

import Token
import Control.Monad (when)
}

%wrapper "monadUserState"

$digit  = [0-9]
$alpha  = [a-zA-Z]
@id     = ($alpha | \_) ($alpha | $digit | \_)*
$any    = [ . \n ]

token :-

<string> ( [^\"] | \\ \" ) *    { from String }
<string> \"                     { begin 0 }
\"                              { begin string }

$white+                         ;

"//" .*                         ;
"/*"                            { enterComment }
<comment> "*/"                  { exitComment }
<comment> ([$any # [\/\*]] | \* [$any # \/] | \/ [$any # \*]) *
                                ;

while                           { from $ const While }
for                             { from $ const For }
to                              { from $ const To }
break                           { from $ const Break }
let                             { from $ const Let }
in                              { from $ const In }
end                             { from $ const End }
function                        { from $ const Function }
var                             { from $ const Var }
type                            { from $ const Type }
array                           { from $ const Array }
if                              { from $ const If }
then                            { from $ const Then }
else                            { from $ const Else }
do                              { from $ const Do }
of                              { from $ const Of }
nil                             { from $ const Nil }

","                             { from $ const Comma }
":"                             { from $ const Colon }
";"                             { from $ const Semicolon }
"("                             { from $ const LeftParen }
")"                             { from $ const RightParen }
"["                             { from $ const LeftBracket }
"]"                             { from $ const RightBracket }
"{"                             { from $ const LeftBrace }
"}"                             { from $ const RightBrace }
"."                             { from $ const Dot }
"+"                             { from $ const Plus }
"-"                             { from $ const Minus }
"*"                             { from $ const Times }
"/"                             { from $ const Divide }
"="                             { from $ const Eq }
">"                             { from $ const Gt }
">="                            { from $ const Ge }
"<"                             { from $ const Lt }
"<="                            { from $ const Le }
"<>"                            { from $ const NotEq }
"&"                             { from $ const And }
"|"                             { from $ const Or }
":="                            { from $ const Assign }
$digit+                         { from $ Int . read }
@id                             { from $ ID }

{
alexEOF :: Alex (Token AlexPosn)
alexEOF = do
    input <- alexGetInput
    let (p, _, _, _) = input
    return (EOF p)

from :: (String -> AlexPosn -> (Token AlexPosn)) -> AlexAction (Token AlexPosn)
from f = token (\(pos, _, _, s) len -> f (take len s) pos)

bad :: AlexAction (Token AlexPosn)
bad = token (\(pos, _, _, s) len -> error (take len s))

data AlexUserState = AlexUserState {commentDepth :: Int} deriving (Show, Eq)

alexInitUserState = AlexUserState 0

getDepth :: Alex Int
getDepth = do
    us <- alexGetUserState
    return (commentDepth us)

setDepth :: Int -> Alex ()
setDepth d = do
    us <- alexGetUserState
    alexSetUserState (us {commentDepth = d})

enterComment :: AlexAction (Token AlexPosn)
enterComment input len = do
    d <- getDepth
    setDepth (d + 1)
    sc <- alexGetStartCode
    when (sc /= comment) (alexSetStartCode comment)
    skip input len

exitComment :: AlexAction (Token AlexPosn)
exitComment input len = do
    d <- getDepth
    setDepth (d - 1)
    sc <- alexGetStartCode
    when (d <= 1) (alexSetStartCode 0)
    skip input len
}