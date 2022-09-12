module Semantic.Sem
  ( Sem (..),
    semError,
    semGetEnv,
    generateNewTypeID,
    findType,
    insertType,
    findVar,
    insertVar,
    scopeBegin,
    scopeEnd,
  )
where

import Semantic.Env (Env (Env), EnvEntry)
import Semantic.STable (create, drop, insert, length, lookup)
import Semantic.Types (Type, TypeID)
import Symbol (Sym)
import Prelude hiding (drop, length, lookup)

data SemState = SemState {env :: Env, currentTypeId :: TypeID} deriving (Show)

newtype Sem a = Sem {runSem :: SemState -> Either String (SemState, a)}

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

semGetState :: Sem SemState
semGetState = Sem $ \s -> Right (s, s)

semSetState :: SemState -> Sem ()
semSetState s = Sem $ \_ -> Right (s, ())

semGetEnv :: Sem Env
semGetEnv = Sem $ \s -> Right (s, env s)

semPutEnv :: Env -> Sem ()
semPutEnv e = Sem $ \s -> Right (s {env = e}, ())

generateNewTypeID :: Sem TypeID
generateNewTypeID = do
  SemState e i <- semGetState
  semSetState $ SemState e (i + 1)
  return i

findType :: Sym -> Sem (Maybe Type)
findType s = semGetEnv >>= \(Env t _) -> return $ lookup s t

insertType :: Sym -> Type -> Sem ()
insertType s ty = semGetEnv >>= \(Env t v) -> semPutEnv $ Env (insert s ty t) v

findVar :: Sym -> Sem (Maybe EnvEntry)
findVar s = semGetEnv >>= \(Env t v) -> return $ lookup s v

insertVar :: Sym -> EnvEntry -> Sem ()
insertVar s e = semGetEnv >>= \(Env t v) -> semPutEnv $ Env t (insert s e v)

scopeBegin :: Sem ()
scopeBegin = semGetEnv >>= \(Env t v) -> semPutEnv $ Env (create t) (create v)

scopeEnd :: Sem ()
scopeEnd = semGetEnv >>= \(Env t v) -> semPutEnv $ Env (drop t) (drop v)