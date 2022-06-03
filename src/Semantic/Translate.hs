module Semantic.Translate where

data Level
  = Outermost
  | Level {}
  deriving (Show, Eq)