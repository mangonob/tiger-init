module RegExp.Main where

import RegExp.Lexer
import Utils (readWithPrompt)

main :: IO ()
main = do
  maybeContents <- readWithPrompt "regexp: "
  case maybeContents of
    Just contents -> print $ runAlex contents alexMonadScan
    Nothing -> return ()
  main