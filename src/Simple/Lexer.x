{
module Simple.Lexer where

import Simple.Token
}

%wrapper "monad"

$digit  = [0-9]
$alpha  = [a-zA-Z]
@id     = ($alpha | \_) ($alpha | $digit | \_)*

tokens :-

$white+                 ;

$digit+\.($digit*)?     { token' $ DoubleToken . read }
$digit+                 { token' $ IntToken . read }

"let"                   { token' $ const Let }
"if"                    { token' $ const If }
"then"                  { token' $ const Then }
"else"                  { token' $ const Else }
"+"                     { token' $ const Plus }
"-"                     { token' $ const Minus}
"*"                     { token' $ const Mul }
"/"                     { token' $ const Div }
"="                     { token' $ const Assign}
"("                     { token' $ const LeftParen }
")"                     { token' $ const RightParen }
";"                     { token' $ const Semicolon }
@id                     { token' $ IdToken }

{
alexEOF :: Alex (Token AlexPosn)
alexEOF = do
    input <- alexGetInput
    let (p, _, _, _) = input
    return (EOF p)

token' :: (String -> AlexPosn -> (Token AlexPosn)) -> AlexAction (Token AlexPosn)
token' f = token (\(pos, _, _, s) len -> f (take len s) pos)
}
