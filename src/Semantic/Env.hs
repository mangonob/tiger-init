{-# LANGUAGE ViewPatterns #-}

module Semantic.Env
  ( EnvEntry (..),
    Env (..),
    baseEnv,
  )
where

import Data.Array (array, (!))
import Data.Char (isSpace)
import Semantic.STable (STable, fromList)
import Semantic.Types (Type (IntType, StringType, Void))

data EnvEntry = VarEntry Type | FuncEntry {formals :: [Type], result :: Type} deriving (Show)

data Env = Env {tenv :: STable Type, venv :: STable EnvEntry}

baseEnv :: Env
baseEnv =
  Env
    { tenv =
        fromList [("int", IntType), ("string", StringType)],
      venv =
        fromList
          [ ("print", FuncEntry [StringType] Void),
            ("flush", FuncEntry [] Void),
            ("getchar", FuncEntry [] StringType),
            ("ord", FuncEntry [StringType] IntType),
            ("chr", FuncEntry [IntType] StringType),
            ("size", FuncEntry [StringType] IntType),
            ("substring", FuncEntry [StringType, IntType, IntType] StringType),
            ("concat", FuncEntry [StringType, StringType] StringType),
            ("not", FuncEntry [IntType] IntType),
            ("exit", FuncEntry [IntType] Void),
            ("debugger", FuncEntry [] Void)
          ]
    }

instance Show Env where
  show (Env t v) =
    unlines
      [ "============= TENV =============",
        trimTail (show t),
        "",
        "============= VENV =============",
        trimTail (show v)
      ]
    where
      trimTail :: [Char] -> [Char]
      trimTail = reverse . trimHead . reverse
        where
          trimHead [] = []
          trimHead ((isSpace -> True) : xs) = trimHead xs
          trimHead xs = xs