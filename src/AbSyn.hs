module AbSyn where

import Lexer (AlexPosn (..))
import Symbol (Sym)

class Position a where
  posn :: a -> AlexPosn

data Expr
  = VarExpr Var
  | NilExpr AlexPosn
  | SeqExpr [Expr] AlexPosn
  | IntExpr Int AlexPosn
  | StringExpr String AlexPosn
  | UMinus Expr AlexPosn
  | Call {call_name :: Sym, args :: [Expr], call_pos :: AlexPosn}
  | OpExpr Expr Operator Expr AlexPosn
  | RecordsExpr {records_type :: Sym, records :: [Field], records_pos :: AlexPosn}
  | ArrayExpr {array_type :: Sym, size :: Expr, element_value :: Expr, array_pos :: AlexPosn}
  | AssignExpr Var Expr AlexPosn
  | IFExpr {predicate :: Expr, success :: Expr, failure :: Maybe Expr, if_pos :: AlexPosn}
  | WhileExpr {predicate :: Expr, body :: Expr, while_pos :: AlexPosn}
  | ForExpr
      { for_var :: Sym,
        from :: Expr,
        to :: Expr,
        body :: Expr,
        i_escape :: Bool,
        for_pos :: AlexPosn
      }
  | BreakExpr AlexPosn
  | LetExpr {decs :: [Dec], body :: Expr, let_pos :: AlexPosn}
  deriving (Show)

data Field = Field {field_name :: Sym, field_value :: Expr, field_pos :: AlexPosn} deriving (Show)

data Dec
  = TypeDec {type_name :: Sym, alias :: Type, type_pos :: AlexPosn}
  | VarDec
      { var_name :: Sym,
        var_init :: Expr,
        var_type :: Maybe Sym,
        var_escape :: Bool,
        var_pos :: AlexPosn
      }
  | FuncDec
      { func_name :: Sym,
        parameters :: [Record],
        returnType :: Maybe Sym,
        func_body :: Expr,
        func_pos :: AlexPosn
      }
  deriving (Show)

data Type
  = SimpleType Sym AlexPosn
  | Records [Record] AlexPosn
  | Array Sym AlexPosn
  deriving (Show)

data Record = Record {record_name :: Sym, record_type :: Sym, record_escape :: Bool, record_pos :: AlexPosn} deriving (Show)

data Operator
  = PlusOp
  | MinusOp
  | TimesOp
  | DivideOp
  | EqOp
  | NeqOp
  | LtOp
  | LeOp
  | GtOp
  | GeOp
  deriving (Show)

-- | Left value
data Var
  = SimpleVar Sym AlexPosn
  | FieldVar Var Sym AlexPosn
  | IndexedVar Var Expr AlexPosn
  deriving (Show)

zero :: Expr
zero = IntExpr 0 (AlexPn 0 0 0)

one :: Expr
one = IntExpr 1 (AlexPn 0 0 0)

instance Position Expr where
  posn (VarExpr v) = posn v
  posn (NilExpr p) = p
  posn (SeqExpr _ p) = p
  posn (IntExpr _ p) = p
  posn (StringExpr _ p) = p
  posn (UMinus _ p) = p
  posn Call {call_pos = p} = p
  posn (OpExpr _ _ _ p) = p
  posn RecordsExpr {records_pos = p} = p
  posn ArrayExpr {array_pos = p} = p
  posn (AssignExpr _ _ p) = p
  posn IFExpr {if_pos = p} = p
  posn WhileExpr {while_pos = p} = p
  posn ForExpr {for_pos = p} = p
  posn (BreakExpr p) = p
  posn LetExpr {let_pos = p} = p

instance Position Var where
  posn (SimpleVar _ p) = p
  posn (FieldVar _ _ p) = p
  posn (IndexedVar _ _ p) = p