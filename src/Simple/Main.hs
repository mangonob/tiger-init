module Simple.Main where

import Control.Monad.State (runState)
import Simple.Lexer (Alex, runAlex)
import Simple.Parser (parse)
import Utils (readWithPrompt)

main :: IO ()
main = do
  maybeContents <- readWithPrompt "eval>"
  case maybeContents of
    Nothing -> return ()
    Just contents -> do
      case runAlex contents parse of
        Left msg -> print msg
        Right expr -> do
          if null expr
            then return ()
            else print (reverse expr)
      main