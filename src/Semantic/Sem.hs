module Semantic.Sem
  ( Sem (..),
    semError,
    get,
    findType,
    insertType,
    findVar,
    insertVar,
    scopeBegin,
    scopeEnd,
  )
where

import Semantic.Env (Env (Env), EnvEntry)
import Semantic.STable
import Semantic.Types (Type)
import Symbol (Sym)
import Prelude hiding (drop, lookup)

newtype Sem a = Sem {runSem :: Env -> Either String (Env, a)}

instance Functor Sem where
  fmap f s = Sem $ \e -> case runSem s e of
    Left msg -> Left msg
    Right (e', s') -> Right (e', f s')

instance Applicative Sem where
  pure a = Sem $ \e -> Right (e, a)
  fs <*> s = Sem $ \e -> case runSem fs e of
    Left msg -> Left msg
    Right (e', f) -> case runSem s e' of
      Left msg -> Left msg
      Right (e'', a') -> Right (e'', f a')

instance Monad Sem where
  return = pure
  m >>= f = Sem $ \e -> case runSem m e of
    Left msg -> Left msg
    Right (e', a) -> runSem (f a) e'

semError :: String -> Sem a
semError msg = Sem $ \e -> Left msg

get :: Sem Env
get = Sem $ \e -> Right (e, e)

put :: Env -> Sem ()
put e = Sem $ \_ -> Right (e, ())

findType :: Sym -> Sem (Maybe Type)
findType s = get >>= \(Env t _) -> return $ lookup s t

insertType :: Sym -> Type -> Sem ()
insertType s val = get >>= \(Env t v) -> put $ Env (insert s val t) v

findVar :: Sym -> Sem (Maybe EnvEntry)
findVar s = get >>= \(Env t v) -> return $ lookup s v

insertVar :: Sym -> EnvEntry -> Sem ()
insertVar s e = get >>= \(Env t v) -> put $ Env t (insert s e v)

scopeBegin :: Sem ()
scopeBegin = get >>= \(Env t v) -> put $ Env (create t) (create v)

scopeEnd :: Sem ()
scopeEnd = get >>= \(Env t v) -> put $ Env (drop t) (drop v)