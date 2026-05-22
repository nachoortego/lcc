module Types.RelContext (Resource(..), Context) where

import qualified Data.Map as M
import Types.Common (Relation)
import Core.AST (RAExp)

data Resource = Table Relation | View RAExp
  deriving (Show, Eq)

type Context = M.Map String Resource
