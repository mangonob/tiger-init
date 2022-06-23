module RegExp.AbSyn where

data RegExps = RegExps {exp :: RegExp, flags :: [Flag]} deriving (Show, Eq)

data RegExp
  = Empty
  | Char Char
  | Concat RegExp RegExp
  | Repeat RegExp Int (Maybe Int)
  | Optional RegExp
  | Require RegExp
  | Closure RegExp
  | CharSets {sets :: [CharSet], isExclude :: Bool}
  | Or RegExp RegExp
  | Group RegExp
  | LineStart
  | LineEnd
  deriving (Show, Eq)

newtype Flag = Flag Char deriving (Show, Eq)

data CharSet
  = Only Char
  | Range Char Char
  deriving (Show, Eq)