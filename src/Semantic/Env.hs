{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Semantic.Env
  ( EnvEntry (..),
    Env (..),
    getTenv,
    putTenv,
    getVenv,
    putVenv,
    scopeBegin,
    scopeEnd,
    baseEnv,
  )
where

import Control.Monad.State.Strict
import Data.Char (isSpace)
import Semantic.STable
import Semantic.Types
import qualified Semantic.Types
import Symbol (Sym)
import Prelude hiding (lookup)

data EnvEntry = VarEntry Type | FuncEntry {formals :: [Type], result :: Type} deriving (Show)

data Env = Env {tenv :: STable Type, venv :: STable EnvEntry}

getTenv :: Sym -> State Env (Maybe Type)
getTenv s = get >>= \(Env t _) -> return $ lookup s t

putTenv :: Sym -> Type -> State Env ()
putTenv s val = get >>= \(Env t v) -> put $ Env (insert s val t) v

getVenv :: Sym -> State Env (Maybe EnvEntry)
getVenv s = get >>= \(Env t v) -> return $ lookup s v

putVenv :: Sym -> EnvEntry -> State Env ()
putVenv s e = get >>= \(Env t v) -> put $ Env t (insert s e v)

scopeBegin :: State Env ()
scopeBegin = get >>= \(Env t v) -> put $ Env (enter t) (enter v)

scopeEnd :: State Env ()
scopeEnd = get >>= \(Env t v) -> put $ Env (exit t) (exit v)

baseEnv :: Env
baseEnv =
  Env
    { tenv =
        empty
          & ("int", IntType)
          & ("string", StringType),
      venv =
        empty
          & ("print", FuncEntry [StringType] Void)
          & ("flush", FuncEntry [] Void)
          & ("getchar", FuncEntry [] StringType)
          & ("ord", FuncEntry [StringType] IntType)
          & ("chr", FuncEntry [IntType] StringType)
          & ("size", FuncEntry [StringType] IntType)
          & ("substring", FuncEntry [StringType, IntType, IntType] StringType)
          & ("concat", FuncEntry [StringType, StringType] StringType)
          & ("not", FuncEntry [IntType] IntType)
          & ("exit", FuncEntry [IntType] Void)
    }

instance Show Env where
  show (Env t v) =
    unlines
      [ "============= TENV =============",
        _trimTail (show t),
        "",
        "============= VENV =============",
        _trimTail (show v)
      ]

_trimTail :: [Char] -> [Char]
_trimTail = reverse . trimHead . reverse
  where
    trimHead [] = []
    trimHead ((isSpace -> True) : xs) = trimHead xs
    trimHead xs = xs