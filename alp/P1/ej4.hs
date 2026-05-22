import Parsing
import Control.Applicative hiding (many)

data Expr = Num Int | BinOp Op Expr Expr deriving Show
data Op = Add | Mul | Min | Div deriving Show

expr :: Parser Expr
expr = do t <- term
          do symbol "+"
             e <- expr
             return ( BinOp Add t e )
           <|> 
            do symbol "-"
               e <- expr
               return ( BinOp Min t e ) 
             <|> return t

term :: Parser Expr
term = do f <- factor
          do symbol "*"
             t <- term
             return ( BinOp Mul f t )
           <|> 
            do symbol "/"
               e <- expr
               return ( BinOp Div f e )
           <|> return f

factor :: Parser Expr
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          <|> do n <- nat
                 return (Num n)