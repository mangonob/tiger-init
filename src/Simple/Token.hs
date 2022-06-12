module Simple.Token where

data Token p
  = IntToken {intValue :: Int, pos :: p}
  | DoubleToken {doubleValue :: Double, pos :: p}
  | IdToken {idValue :: String, pos :: p}
  | Assign {pos :: p}
  | LeftParen {pos :: p}
  | RightParen {pos :: p}
  | Plus {pos :: p}
  | Minus {pos :: p}
  | Mul {pos :: p}
  | Div {pos :: p}
  | Let {pos :: p}
  | EOF {pos :: p}
  deriving (Show, Eq)