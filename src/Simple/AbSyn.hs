module Simple.AbSyn where

data Expr
  = Let String Expr
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Id String
  | Double Double
  | Int Int
  | Brack Expr
  deriving (Show, Eq)
