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

data T = T {a :: Int, b :: String} deriving (Show, Eq)

aaa :: IO T
aaa = return (T 1 "hello")

bbb :: IO ()
bbb = do
  value <- aaa
  let T x y = value
  return ()