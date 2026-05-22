module Core.Schema (
  Schema(..),
  mkSchema,
  hasAttr,
  schemaAttrs,
  combineSchemas,
  mapSchema,
  intersectSchemas
) where

import qualified Data.Sequence as Seq
import qualified Data.Set as S
import Data.Foldable (toList)

data Schema = Schema {
  attrSeq  :: Seq.Seq String,
  attrSet  :: S.Set String
} deriving Show

instance Eq Schema where
  s1 == s2 = attrSet s1 == attrSet s2

mkSchema :: [String] -> Schema
mkSchema xs = Schema (Seq.fromList xs) (S.fromList xs)

combineSchemas :: Schema -> Schema -> Schema
combineSchemas s1 s2 = Schema (attrSeq s1 Seq.>< attrSeq s2) (S.union (attrSet s1) (attrSet s2))

intersectSchemas :: Schema -> Schema -> S.Set String
intersectSchemas s1 s2 = S.intersection (attrSet s1) (attrSet s2)

mapSchema :: (String -> String) -> Schema -> Schema
mapSchema f s = Schema (fmap f (attrSeq s)) (S.map f (attrSet s))

hasAttr :: String -> Schema -> Bool
hasAttr a s = S.member a (attrSet s)

schemaAttrs :: Schema -> [String]
schemaAttrs = toList . attrSeq