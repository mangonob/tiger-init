module Simple.AbSyn where

data Expr
  = Add Expr Term
  | Sub Expr Term
  | Term Term
  deriving (Show, Eq)

data Term
  = Mul Term Factor
  | Div Term Factor
  | Factor Factor
  deriving (Show, Eq)

data Factor
  = Id String
  | Double Double
  | Int Int
  | Brack Expr
  deriving (Show, Eq)