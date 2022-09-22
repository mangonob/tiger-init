module Semantic.Types where

import Control.Monad (join)
import Control.Monad.State (State, evalState, get, put)
import Data.Function (on)
import Data.Functor ((<&>))
import Data.List (intercalate, union)
import Data.Set (fromList)
import Symbol (Sym)

type TypeID = Int

data Type
  = Void
  | NilType
  | IntType
  | StringType
  | ArrayType Type
  | RecordType [(Sym, Type)]
  | NamedType Sym (Maybe Type)
  | RefType (Ref Type)
  deriving (Eq)

data Ref a = Ref {ref :: Int, value :: a} deriving (Show)

instance Eq (Ref a) where
  (==) = (==) `on` ref

type Visited a = State ([TypeID], [TypeID]) a

meetArray :: TypeID -> Visited ()
meetArray t = get >>= \(ats, rts) -> put (t : ats, rts)

meetRecord :: TypeID -> Visited ()
meetRecord t = get >>= \(ats, rts) -> put (ats, t : rts)

metArray :: TypeID -> Visited Bool
metArray t = get <&> (elem t . fst)

metRecord :: TypeID -> Visited Bool
metRecord t = get <&> (elem t . snd)

runVisited :: Visited a -> a
runVisited v = evalState v ([], [])

isArray :: Type -> Bool
isArray (ArrayType _) = True
isArray _ = False

isRecord :: Type -> Bool
isRecord (RecordType _) = True
isRecord _ = False

instance Show Type where
  show Void = "void"
  show NilType = "nil"
  show IntType = "int"
  show StringType = "string"
  show (ArrayType t) = "[" ++ show t ++ "]"
  show (RecordType fs) = "{" ++ intercalate ", " (showRecord <$> fs) ++ "}"
    where
      showRecord (s, t) = show s ++ ": " ++ show t
  show _ = undefined