module Token where

data Token p
  = While {pos :: p}
  | For {pos :: p}
  | To {pos :: p}
  | Break {pos :: p}
  | Let {pos :: p}
  | In {pos :: p}
  | End {pos :: p}
  | Function {pos :: p}
  | Var {pos :: p}
  | Type {pos :: p}
  | Array {pos :: p}
  | If {pos :: p}
  | Then {pos :: p}
  | Else {pos :: p}
  | Do {pos :: p}
  | Of {pos :: p}
  | Nil {pos :: p}
  | Comma {pos :: p}
  | Colon {pos :: p}
  | Semicolon {pos :: p}
  | LeftParen {pos :: p}
  | RightParen {pos :: p}
  | LeftBrace {pos :: p}
  | RightBrace {pos :: p}
  | LeftBracket {pos :: p}
  | RightBracket {pos :: p}
  | Dot {pos :: p}
  | Plus {pos :: p}
  | Minus {pos :: p}
  | Times {pos :: p}
  | Divide {pos :: p}
  | Eq {pos :: p}
  | NotEq {pos :: p}
  | Lt {pos :: p}
  | Le {pos :: p}
  | Gt {pos :: p}
  | Ge {pos :: p}
  | And {pos :: p}
  | Or {pos :: p}
  | Assign {pos :: p}
  | String {stringValue :: String, pos :: p}
  | Int {intValue :: Int, pos :: p}
  | ID {idValue :: String, pos :: p}
  | EOF {pos :: p}
  deriving (Show, Eq)
