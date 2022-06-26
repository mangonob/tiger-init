module Main where

import Lexer (runAlex)
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
    (filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> print expr
    _ ->
      putStrLn $
        unlines
          [ "usage: command_name [-r|-h] [file_name]",
            "    -r   Raw text file.",
            "    -h   Show help message."
          ]