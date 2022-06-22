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
  | Comma {pos :: p}
  | Dollar {pos :: p}
  | Char {charValue :: Char, pos :: p}
  | Unicode {value :: Int, pos :: p}
  | Count {value :: Int, pos :: p}
  | EOF {pos :: p}
  deriving (Eq, Show)