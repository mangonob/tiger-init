module Main where

import Lexer_ (lexer)
import Parser_ (parser)
import Raw (raw)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("-r" : filename : _) -> do
      contents <- readFile filename
      putStrLn $ raw . parser $ lexer contents
    (filename : _) -> do
      contents <- readFile filename
      print $ lexer contents
    _ ->
      putStrLn $
        unlines
          [ "usage: command_name [-r|-h] [file_name]",
            "    -r   Raw text file.",
            "    -h   Show help message."
          ]

data Pos = Pos Int Int deriving (Show, Eq)

data Token = IntToken Int Pos | Let Pos deriving (Show, Eq)

token :: Pos -> String -> Token
token p s = IntToken (read s) p

letTk :: Pos -> String -> Token
letTk p s = Let p

letTk' = flip (const Let)