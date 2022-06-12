module Simple.Main where

import Simple.Lexer
import Simple.Parser (parse)
import Utils (readLine)

main :: IO ()
main = do
  maybeContents <- readLine
  case maybeContents of
    Nothing -> return ()
    Just contents -> do
      print $ parse $ alexScanTokens contents
      main
