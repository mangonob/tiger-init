module Simple.Main where

import Simple.Lexer

main :: IO ()
main = do
  contents <- getContents
  print $ alexScanTokens contents