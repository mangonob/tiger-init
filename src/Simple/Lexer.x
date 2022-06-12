{
module Simple.Lexer where

import Simple.Token
}

%wrapper "posn"

$digit  = [0-9]
$alpha  = [a-zA-Z]
@id     = ($alpha | \_) ($alpha | $digit | \_)*

tokens :-

$white+                 ;

$digit+\.($digit*)?     { flip $ DoubleToken . read }
$digit+                 { flip $ IntToken . read }

"let"                   { flip $ const Let }
"+"                     { flip $ const Plus }
"-"                     { flip $ const Minus}
"*"                     { flip $ const Mul }
"/"                     { flip $ const Div }
"="                     { flip $ const Assign}
"("                     { flip $ const LeftParen }
")"                     { flip $ const RightParen }
@id                     { flip $ IdToken }
