module RegExp.Main where

import Control.Monad.State (runState)
import RegExp.AbSyn (RegExp (Group))
import RegExp.Lexer (Alex, runAlex)
import RegExp.Parser (parse)
import Utils (readWithPrompt)

main :: IO ()
main = do
  maybeContents <- readWithPrompt "eval> "
  case maybeContents of
    Nothing -> return ()
    Just contents -> do
      case runAlex contents parse of
        Left msg -> print msg
        Right exp -> print exp
      main