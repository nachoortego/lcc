module Core.AST (module Core.AST) where

import Types.Common (Value(..))

type NombreRelacion = String
type NombreAtributo = String
type NombreOp       = String

data Program = Prog [Definition] RAExp
  deriving (Show, Eq)

data Definition = Def NombreOp [NombreRelacion] RAExp
  deriving (Show, Eq)

data RAExp = Tabla NombreRelacion 
           | Seleccion Condition RAExp
           | Proyeccion [NombreAtributo] RAExp
           | Renombre NombreAtributo NombreAtributo RAExp

           | Union RAExp RAExp
           | Diferencia RAExp RAExp
           | Producto RAExp RAExp

           | Interseccion RAExp RAExp
           | Join         RAExp RAExp
           | Division     RAExp RAExp
               deriving (Show, Eq)

 
data Condition = Comp NombreAtributo Op Value
               | And Condition Condition
               | Or Condition Condition
               | Not Condition
                 deriving (Show, Eq)

data Op = Eq | NEq | Gt | Lt | Ge | Le
  deriving (Show, Eq)

data Error = UndefVar
           | UndefColumn String
           | IncompatibleSchemes
           | CustomError String
           deriving (Show, Eq)