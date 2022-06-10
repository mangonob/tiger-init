module Simple.Main where

import qualified Data.ByteString.Lazy as ByteString
import Simple.Lexer

main :: IO ()
main = do
  contents <- ByteString.getContents
  print $ alexScanTokens contents
