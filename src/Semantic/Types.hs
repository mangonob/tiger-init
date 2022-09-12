module Semantic.Types where

import Control.Monad (join)
import Data.List (intersperse)
import Data.Set (fromList)
import Symbol (Sym)

type TypeID = Int

data Type
  = Void
  | NilType
  | IntType
  | StringType
  | ArrayType TypeID Type
  | RecordType TypeID [(Sym, Type)]
  | NamedType Sym (Maybe Type)
  deriving (Ord)

instance Show Type where
  show = showWithPath [] []

showWithPath :: [TypeID] -> [TypeID] -> Type -> String
showWithPath _ _ NilType = "nil"
showWithPath _ _ IntType = "int"
showWithPath _ _ Void = "void"
showWithPath _ _ StringType = "string"
showWithPath ats rts (ArrayType i t) =
  if i `elem` ats
    then "a" ++ show i
    else "a" ++ show i ++ ": [" ++ showWithPath (i : ats) rts t ++ "]"
showWithPath ats rts (RecordType i records) =
  if i `elem` ats
    then "r" ++ show i
    else "r" ++ show i ++ ": {" ++ join (intersperse ", " (fmap showRecord records)) ++ "}"
  where
    showRecord (s, t) = s ++ ": " ++ showWithPath ats (i : rts) t
showWithPath ats rts (NamedType s t) = s ++ maybe " ->" ((" -> " ++) . showWithPath ats rts) t

instance Eq Type where
  Void == Void = True
  NilType == NilType = True
  IntType == IntType = True
  StringType == StringType = True
  ArrayType i t1 == ArrayType i' t2 = i == i' || t1 == t2
  RecordType i rs1 == RecordType i' rs2 = i == i' || fromList rs1 == fromList rs2
  NamedType s t == NamedType s' t' = s == s' && t == t'
  _ == _ = False

isArray :: Type -> Bool
isArray (ArrayType _ _) = True
isArray _ = False

isRecord :: Type -> Bool
isRecord (RecordType _ _) = True
isRecord _ = False