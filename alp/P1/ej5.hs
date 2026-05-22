import Parsing
import Control.Applicative hiding (many)

data Basetype = DInt | DChar | DFloat deriving Show
type Hasktype = [Basetype]

{- CFG:
    ht -> bt (ε | '->' ht)
    bt -> 'Int' | 'Char' | 'Float'
-}

ht = sepBy1 bt (symbol "->") <|> return []

ht :: Parser Hasktype
ht = do t <- bt
        do symbol "->"
           ts <- ht
           return (t:ts)
         <|> return [t]

bt :: Parser Basetype
bt = pInt <|> pChar <|> pChar <|> pFloat
    where
        pInt = do symbol "Int"
                  return DInt
        pChar = do symbol "Char"
                   return DChar
        pFloat = do symbol "Float"
                    return DFloat

