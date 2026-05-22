import Parsing
import Control.Applicative hiding (many)

data Hasktype = DInt | DChar | DFloat | Fun Hasktype Hasktype


{- CFG:

Type  ::= Atom
        | Atom "->" Type

Atom  ::= "Int"
        | "Char"
        | "Float"
        | "(" Type ")"
-}

type' :: Parser Hasktype
type' = do t1 <- atom
           (do symbol "->"
               t2 <- type'
               return (Fun t1 t2))
           <|> return t1
                  
atom :: Parser Hasktype
atom = pInt <|> pChar <|> pFloat <|> paren type
        where 
          paren p = p <|> do symbol "("
                            t <- p
                            symbol ")"
                            return t
          pInt = do symbol "Int"
                    return DInt
          pChar = do symbol "Char"
                    return DChar
          pFloat = do symbol "Float"
                    return DFloat