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

<string> ( [^\"] | \\ \" ) *    { token' String }
<string> \"                     { begin 0 }
\"                              { begin string }

$white+                         ;

"//" .*                         ;
"/*"                            { enterComment }
<comment> "*/"                  { exitComment }
<comment> ([$any # [\/\*]] | \* [$any # \/] | \/ [$any # \*]) *
                                ;

while                           { token' $ const While }
for                             { token' $ const For }
to                              { token' $ const To }
break                           { token' $ const Break }
let                             { token' $ const Let }
in                              { token' $ const In }
end                             { token' $ const End }
function                        { token' $ const Function }
var                             { token' $ const Var }
type                            { token' $ const Type }
array                           { token' $ const Array }
if                              { token' $ const If }
then                            { token' $ const Then }
else                            { token' $ const Else }
do                              { token' $ const Do }
of                              { token' $ const Of }
nil                             { token' $ const Nil }

","                             { token' $ const Comma }
":"                             { token' $ const Colon }
";"                             { token' $ const Semicolon }
"("                             { token' $ const LeftParen }
")"                             { token' $ const RightParen }
"["                             { token' $ const LeftBracket }
"]"                             { token' $ const RightBracket }
"{"                             { token' $ const LeftBrace }
"}"                             { token' $ const RightBrace }
"."                             { token' $ const Dot }
"+"                             { token' $ const Plus }
"-"                             { token' $ const Minus }
"*"                             { token' $ const Times }
"/"                             { token' $ const Divide }
"="                             { token' $ const Eq }
">"                             { token' $ const Gt }
">="                            { token' $ const Ge }
"<"                             { token' $ const Lt }
"<="                            { token' $ const Le }
"<>"                            { token' $ const NotEq }
"&"                             { token' $ const And }
"|"                             { token' $ const Or }
":="                            { token' $ const Assign }
$digit+                         { token' $ Int . read }
@id                             { token' $ ID }

{
alexEOF :: Alex (Token AlexPosn)
alexEOF = do
    input <- alexGetInput
    let (p, _, _, _) = input
    return (EOF p)

token' :: (String -> AlexPosn -> (Token AlexPosn)) -> AlexAction (Token AlexPosn)
token' f = token (\(pos, _, _, s) len -> f (take len s) pos)

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