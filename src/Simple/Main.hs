module Simple.Main where

import Control.Monad.State (runState)
import Simple.Lexer (Alex, runAlex)
import Simple.Parser (parse)
import Utils (readWithPrompt)

main :: IO ()
main = repl [("pi", pi), ("e", exp 1)]

sss :: String -> IO ()
sss s = case runAlex s parse of
  Left msg -> print msg
  Right s -> do
    let (result, s') = runState s [("pi", pi), ("e", exp 1)]
    case result of
      Left _ -> return ()
      Right r -> print r

repl :: [(String, Double)] -> IO ()
repl env = do
  maybeContents <- readWithPrompt "eval>"
  case maybeContents of
    Nothing -> return ()
    Just contents -> do
      case runAlex contents parse of
        Left msg -> error msg
        Right s -> do
          let (v, s') = runState s env
          case v of
            Left _ -> return ()
            Right r -> print r
          repl s'