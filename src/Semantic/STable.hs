{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Semantic.STable
  ( Table (..),
    STable (..),
    empty,
    singleton,
    insert,
    fromList,
    create,
    drop,
    lookup,
  )
where

import Data.Char (isSpace)
import qualified Data.Map as Map
import Data.Maybe (Maybe (Just, Nothing))
import Symbol (Sym)
import Text.Printf (printf)
import Prelude hiding (drop, lookup)

newtype Table a = Table {toList :: Map.Map Sym a}

data STable a = STable {prev :: Maybe (STable a), table :: Table a}

empty :: STable a
empty = STable {prev = Nothing, table = Table Map.empty}

singleton :: Sym -> a -> STable a
singleton s t = STable {prev = Nothing, table = Table $ Map.singleton s t}

insert :: Sym -> a -> STable a -> STable a
insert s t STable {prev = a, table = b} = STable {prev = a, table = Table $ Map.insert s t (toList b)}

fromList :: [(Sym, a)] -> STable a
fromList [] = empty
fromList ((s, v) : xs) = insert s v (fromList xs)

create :: STable a -> STable a
create st = STable {prev = Just st, table = Table Map.empty}

drop :: STable a -> STable a
drop STable {prev = Nothing, table = _} = error "can not exit"
drop STable {prev = Just st, table = b} = st

lookup :: Sym -> STable a -> Maybe a
lookup s STable {prev = a, table = b} = case Map.lookup s (toList b) of
  Just t -> Just t
  Nothing -> case a of
    Just st -> lookup s st
    Nothing -> Nothing

instance Show a => Show (STable a) where
  show (STable Nothing table) = _trimTail $ show table
  show (STable (Just prev) table) = unlines [_trimTail $ show prev, separator, _trimTail $ show table]
    where
      separator = "--------------------------------"

instance Show a => Show (Table a) where
  show t = unlines $ Map.foldlWithKey acc [] (toList t)
    where
      acc xs k v = (printf "%-8s" k ++ " -> " ++ show v) : xs

_trimTail :: [Char] -> [Char]
_trimTail = reverse . trimHead . reverse
  where
    trimHead [] = []
    trimHead ((isSpace -> True) : xs) = trimHead xs
    trimHead xs = xs