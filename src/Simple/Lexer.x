{
module Simple.Lexer where

import Data.ByteString.Lazy.Char8 (unpack)
}

%wrapper "posn-bytestring"

$digit  = [0-9]
$alpha  = [a-zA-Z]
@id     = ($alpha | \_) ($alpha | $digit | \_)*

tokens :-

$white+                 ;

$digit+\.($digit*)?     { flip $ DoubleToken . read . unpack}
$digit+                 { flip $ IntToken . read . unpack}

"let"                   { flip $ const Let }
"+"                     { flip $ const Plus }
"-"                     { flip $ const Minus}
"*"                     { flip $ const Mul }
"/"                     { flip $ const Div }
"="                     { flip $ const Assign}
"("                     { flip $ const LeftParen }
")"                     { flip $ const RightParen }
@id                     { flip $ IdToken . unpack }

{
data Token = IntToken Int AlexPosn 
    | DoubleToken Double AlexPosn 
    | IdToken String AlexPosn 
    | Assign AlexPosn
    | LeftParen AlexPosn
    | RightParen AlexPosn
    | Plus AlexPosn
    | Minus AlexPosn
    | Mul AlexPosn
    | Div AlexPosn
    | Let AlexPosn 
    | EOF AlexPosn deriving (Show, Eq)
}