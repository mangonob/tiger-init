{
module RegExp.Lexer where

import Data.Char
import Numeric
import Prelude hiding (repeat)
import RegExp.Token
}

%wrapper "monad"

$digit      = [0-9]
$hex        = [0-9a-fA-F]

tokens :-

"("                     { token' (const ParenLeft) }
")"                     { token' $ const ParenRight }
"["                     { token' (const BracketLeft) `andBegin` charset }
<charset> "]"           { token' (const BracketRight) `andBegin` 0 }
"{"                     { token' (const BraceLeft) `andBegin` repeat }
<repeat> "}"            { token' (const BraceRight) `andBegin` 0 }
<charset> "-"           { token' $ const Minus }
"+"                     { token' $ const Plus }
"?"                     { token' $ const Question }
"|"                     { token' $ const Channel }
<charset> "^"           { token' $ const Caret }
","                     { token' $ const Comma }
"^"                     { token' $ const Caret }
"$"                     { token' $ const Dollar }
"/"                     { token' $ const Slash }
"*"                     { token' $ const Star }
"\u{"                   { begin unicode }
<unicode> "}"           { begin 0 }
<unicode> $hex+         { token' $ Char . hexToChar }
"\u"                    { begin sunicode}
<sunicode> $hex+        { token' (Char . hexToChar) `andBegin` 0 }
<escape> .              { token' (Char . read . (\s -> "'\\" ++ s ++ "'")) `andBegin` 0 }
\\                      { begin escape }
<repeat> $digit+        { token' $ Int . read }
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

hexToChar :: String -> Char
hexToChar = chr . fst . head . readHex
}