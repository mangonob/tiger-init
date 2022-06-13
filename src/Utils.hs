module Utils (readWithPrompt, readLine) where

import System.Console.Haskeline (defaultSettings, getInputLine, runInputT)

readWithPrompt :: String -> IO (Maybe String)
readWithPrompt = runInputT defaultSettings . getInputLine

readLine :: IO (Maybe String)
readLine = readWithPrompt ""
