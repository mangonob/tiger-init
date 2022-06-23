module RegExp.Token where

data Token p
  = ParenLeft {pos :: p}
  | ParenRight {pos :: p}
  | BracketLeft {pos :: p}
  | BracketRight {pos :: p}
  | BraceLeft {pos :: p}
  | BraceRight {pos :: p}
  | Minus {pos :: p}
  | Plus {pos :: p}
  | Question {pos :: p}
  | Channel {pos :: p}
  | Caret {pos :: p}
  | Slash {pos :: p}
  | Comma {pos :: p}
  | Dollar {pos :: p}
  | Star {pos :: p}
  | Char {charValue :: Char, pos :: p}
  | Int {intValue :: Int, pos :: p}
  | EOF {pos :: p}
  deriving (Eq, Show)