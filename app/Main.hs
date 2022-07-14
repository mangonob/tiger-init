module Main where

import Lexer (runAlex, scanTokens)
import Parser (parser)
import Raw (raw)
import Semantic.Semantic (translate)
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
    ("-a" : filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> print expr
    ("-t" : filename : _) -> do
      contents <- readFile filename
      print $ scanTokens contents
    ("-s" : filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> print $ translate expr
    (filename : _) -> do
      contents <- readFile filename
      case runAlex contents parser of
        Left msg -> putStrLn msg
        Right expr -> print expr
    _ ->
      putStrLn $
        unlines
          [ "usage: command_name [-r|-t|-h] [file_name]",
            "    -r   Raw text file",
            "    -a   Abstract syntax tree",
            "    -t   Scan tokens",
            "    -t   Semantic",
            "    -h   Show help message"
          ]