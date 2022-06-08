{
module Simple.Lexer where
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
"-"                     { flip $ const Minus }
"*"                     { flip $ const  Mul }
"/"                     { flip $ const Div }
"="                     { flip $ const Assign }
"("                     { flip $ const LeftParen }
")"                     { flip $ const RightParen }
@id                     { flip $ IdToken }

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
    | Let AlexPosn deriving (Show, Eq)
}