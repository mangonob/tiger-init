module Utils where

import System.Console.Haskeline (defaultSettings, getInputLine, runInputT)

readLine :: IO (Maybe String)
readLine = runInputT defaultSettings $ getInputLine ""