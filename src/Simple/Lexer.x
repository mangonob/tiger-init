{
module Simple.Lexer where
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
"+"                     { token' $ const Plus }
"-"                     { token' $ const Minus}
"*"                     { token' $ const Mul }
"/"                     { token' $ const Div }
"="                     { token' $ const Assign}
"("                     { token' $ const LeftParen }
")"                     { token' $ const RightParen }
@id                     { token' $ IdToken }

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

alexEOF :: Alex Token
alexEOF = do 
    input <- alexGetInput
    let (pos, _, _, _)  = input
    return (EOF pos)

token' :: (String -> AlexPosn -> Token) -> AlexAction Token
token' f = token (\(pos, _, _, s) _ -> f s pos)
}