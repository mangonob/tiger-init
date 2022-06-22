{
module RegExp.Lexer where

import RegExp.Token
}

%wrapper "monad"

$digit      = [0-9]
$hex        = [0-9a-fA-F]

tokens :-

"("                     { token' (const ParenLeft) }
")"                     { token' $ const ParenRight }
"["                     { token' $ const BracketLeft }
"]"                     { token' $ const BracketRight }
"{"                     { token' $ const BraceLeft }
"}"                     { token' $ const BraceRight }
"-"                     { token' $ const Minus }
"+"                     { token' $ const Plus }
"?"                     { token' $ const Question }
"|"                     { token' $ const Channel }
"^"                     { token' $ const Caret }
","                     { token' $ const Comma }
"$"                     { token' $ const Dollar }
"\u{"                   { begin unicode }
<unicode> "}"           { begin 0 }
<unicode> $hex+         { token' $ Unicode . read }
"\u"                    { begin sunicode}
<sunicode> $hex+        { token' (Unicode . read) `andBegin` 0 }
<escape> .              { token' (Char . read . (\s -> "'\\" ++ s ++ "'")) `andBegin` 0 }
\\                      { begin escape }
-- TODO Count
.                       { token' $ Char . head }


{
alexEOF :: Alex (Token AlexPosn)
alexEOF = do
    input <- alexGetInput
    let (p, _, _, _) = input
    return (EOF p)

token' :: (String -> AlexPosn -> (Token AlexPosn)) -> AlexAction (Token AlexPosn)
token' f = token (\(pos, _, _, s) len -> f (take len s) pos)

data AlexUserState = AlexUserState deriving (Show)
}