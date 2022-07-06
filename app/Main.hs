module Main where

import Lexer (runAlex, scanTokens)
import Parser (parser)
import Raw (raw)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("-r" : filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> putStrLn (raw expr)
    ("-t" : filename : _) -> do
      contents <- readFile filename
      print $ scanTokens contents
    (filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> print expr
    _ ->
      putStrLn $
        unlines
          [ "usage: command_name [-r|-t|-h] [file_name]",
            "    -r   Raw text file.",
            "    -t   Scan tokens.",
            "    -h   Show help message."
          ]