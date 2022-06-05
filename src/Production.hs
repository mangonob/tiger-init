module Production where

import Control.Monad (when)
import Control.Monad.State (State, execState, get, put)
import Data.Char (isSpace, isUpper)
import Data.Either (isLeft, lefts)
import Data.List (inits, tails)
import Data.Map (Map, lookup)
import qualified Data.Map as Map
import Data.Set (Set, insert, singleton, union)
import qualified Data.Set as Set
import System.Console.Haskeline (defaultSettings, getInputLine, runInputT)

data Item = Terminal String | NonTerminal String deriving (Eq, Ord)

instance Show Item where
  show (Terminal s) = s
  show (NonTerminal s) = s

data Arrow = Arrow deriving (Eq, Show, Ord)

data Production = Production {left :: Item, right :: [Item]} deriving (Eq, Show)

instance Read Production where
  readsPrec _ text = [(toProduction $ toItem <$> (words . head . lines) text, (unlines . tail . lines) text)]
    where
      toItem :: String -> Either Item Arrow
      toItem "->" = Right Arrow
      toItem (x : xs) = if isUpper x then Left (NonTerminal (x : xs)) else Left (Terminal (x : xs))
      toItem _ = undefined

      toProduction :: [Either Item Arrow] -> Production
      toProduction (Left item : Right Arrow : xs)
        | isTerminal item = error "Production must start with a non-terminal"
        | all isLeft xs = Production item (lefts xs)
        | otherwise = error "Production must has some items"
      toProduction _ = error "invalid production"

data Infos = Infos
  { nullable :: Set Item,
    first :: Map Item (Set Item),
    follow :: Map Item (Set Item)
  }
  deriving (Eq)

instance Show Infos where
  show (Infos nullable first follow) =
    unlines
      [ "======== Nullable ========",
        show $ Set.toList nullable,
        "",
        "======== First ========",
        showMap first,
        "======== Follow ========",
        showMap follow
      ]
    where
      showMap :: Map Item (Set Item) -> String
      showMap = unlines . map (\(k, v) -> show k ++ " -> " ++ show (Set.toList v)) . Map.toList

updateOrDefault :: Ord k => (a -> a) -> a -> k -> Map k a -> Map k a
updateOrDefault f d k m = case Map.lookup k m of
  Nothing -> Map.insert k d m
  Just _ -> Map.update (Just . f) k m

extendFirst :: Item -> Set Item -> State Infos ()
extendFirst item fs = do
  infos <- get
  let Infos nullable first follow = infos
  put $ Infos nullable (updateOrDefault (union fs) fs item first) follow

extendFollow :: Item -> Set Item -> State Infos ()
extendFollow item fs = do
  infos <- get
  let Infos nullable first follow = infos
  put $ Infos nullable first (updateOrDefault (union fs) fs item follow)

firstOfItem :: Item -> State Infos (Set Item)
firstOfItem item = do
  infos <- get
  let Infos _ first _ = infos
  case Map.lookup item first of
    Just set -> return set
    Nothing -> return Set.empty

followOfItem :: Item -> State Infos (Set Item)
followOfItem item = do
  infos <- get
  let Infos _ _ follow = infos
  case Map.lookup item follow of
    Just set -> return set
    Nothing -> return Set.empty

nullish :: Item -> State Infos ()
nullish item = get >>= \(Infos nullable first follow) -> put $ Infos (insert item nullable) first follow

isTerminal :: Item -> Bool
isTerminal (Terminal _) = True
isTerminal _ = False

isNonTerminal :: Item -> Bool
isNonTerminal (NonTerminal _) = True
isNonTerminal _ = False

empty :: Infos
empty = Infos Set.empty Map.empty Map.empty

initState :: [Production] -> State Infos ()
initState [] = return ()
initState (Production _ right : ps) = do
  mapM_ (\term -> extendFirst term (Set.singleton term)) (filter isTerminal right)
  initState ps

getInfos :: [Production] -> State Infos ()
getInfos ps = initState ps >> generateInfos ps

generateInfos :: [Production] -> State Infos ()
generateInfos productions = do
  current <- get
  mapM_ tell productions
  new <- get
  if new == current
    then return ()
    else generateInfos productions

isNullable :: Item -> State Infos Bool
isNullable item = get >>= \(Infos nullable _ _) -> return $ Set.member item nullable

tell :: Production -> State Infos ()
tell (Production left right) = do
  nuls <- mapM isNullable right
  when (and nuls) $ nullish left
  mapM_
    ( \(xs, x) -> do
        nuls <- mapM isNullable xs
        when (and nuls) $ firstOfItem x >>= extendFirst left
    )
    (initsAndSide right)
  mapM_
    ( \(x, xs) -> do
        nuls <- mapM isNullable xs
        when (and nuls) $ followOfItem left >>= extendFollow x
    )
    (sideAndTails right)
  mapM_
    ( \(x, xs) -> do
        mapM_
          ( \(ys, y) -> do
              nuls <- mapM isNullable ys
              when (and nuls) $ firstOfItem y >>= extendFollow x
          )
          (initsAndSide xs)
    )
    (sideAndTails right)

initsAndSide :: [b] -> [([b], b)]
initsAndSide xs = zip ((init . inits) xs) xs

sideAndTails :: [a] -> [(a, [a])]
sideAndTails xs = zip xs ((tail . tails) xs)

getProductions :: IO [Production]
getProductions = do
  maybeLine <- readLine
  case maybeLine of
    Just line ->
      if null line
        then return []
        else do
          ps <- getProductions
          return (read line : ps)
    Nothing -> return []

readLine :: IO (Maybe String)
readLine = runInputT defaultSettings $ getInputLine ""

main = do
  ps <- getProductions
  return $ execState (getInfos ps) empty