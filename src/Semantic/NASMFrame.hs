module Semantic.NASMFrame where

import Semantic.Frame
import qualified Semantic.Temp as Temp

data NASMFrame = NASMFrame
  { name :: Temp.Label,
    formals :: [Access],
    locals :: [Access],
    fp :: Int,
    sp :: Int
  }
  deriving (Show)

instance Frame NASMFrame where
  newFrame = undefined
  formals = undefined
  allocLocal = undefined