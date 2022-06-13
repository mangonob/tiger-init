module Simple.Main where

import Control.Monad.State (runState)
import Simple.Lexer (alexScanTokens)
import Simple.Parser (parse)
import Utils (readWithPrompt)

main :: IO ()
main = repl [("pi", pi), ("e", exp 1)]

repl :: [(String, Double)] -> IO ()
repl env = do
  maybeContents <- readWithPrompt "eval>"
  case maybeContents of
    Nothing -> return ()
    Just contents -> do
      let (v, s) = runState (parse (alexScanTokens contents)) env
      case v of
        Left _ -> return ()
        Right r -> print r
      repl s