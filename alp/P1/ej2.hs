import Parsing
import Control.Applicative hiding (many)

{-
    expr ::= term (’+’ expr | ’-’ expr | ε)
    term ::= factor (’*’ term | ’/’ term | ε)
    atom ::= ’(’ exp ’)’ | n
    n    ::= d | dn
    d    ::= ’0’ | ’1’ | . . . | ’9’
-}

expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return ( t + e )
           <|> 
            do symbol "-"
               e <- expr
               return ( t - e ) 
             <|> return t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return ( f * t )
           <|> 
            do symbol "/"
               e <- expr
               return ( div f e )
           <|> return f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          <|> natural