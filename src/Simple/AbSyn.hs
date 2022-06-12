module Simple.AbSyn where

data Expr = Add Expr Term | Sub Expr Term deriving (Show, Eq)

data Term = Mul Term Factor | Div Term Factor deriving (Show, Eq)

data Factor
  = Id String
  | Double Double
  | Int Int
  | Factor Expr
  deriving (Show, Eq)