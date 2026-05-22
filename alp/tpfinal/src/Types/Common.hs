module Types.Common (Value(..), Tuple, Relation(..), valToString) where

import qualified Data.Map as M
import qualified Data.Set as S
import Core.Schema

data Value = VInt Int | VStr String 
  deriving (Eq, Ord)

instance Show Value where
  show (VInt n) = show n
  show (VStr s) = show s

valToString :: Value -> String
valToString (VInt n) = show n
valToString (VStr s) = s

type Tuple = M.Map String Value

data Relation = Rel {
  attributes :: Schema,
  tuples     :: S.Set Tuple
} deriving (Eq, Show)
