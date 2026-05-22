{-
    expr -> term expr'
    expr' -> ('-' | '+') term expr' | ε
    term -> expr term'
    term' -> ('*' | '/') expr term' | ε
-}

data Expr = Num Int | BinOp Op Expr Expr
data Op = Add | Mul | Min | Div

expr :: Parser Expr
expr = do t <- term  {- t ::Expr -}
          f <- expr' {- f :: Expr -> Expr -}
          return (f t)

expr' :: Parser (Expr -> Expr)
expr' = pMin <|> pSum <|> pEmpty

pMin :: Parser (Expr -> Expr)
pMin = do symbol "-"
          t <- term  {- t :: Expr -}
          f <- expr' {- f :: Expr -> Expr -}
          return (\e -> f (BinOp Min e t))

pSum :: Parser (Expr -> Expr)
pSum = do symbol "+"
          t <- term  {- t :: Expr -}
          f <- expr' {- f :: Expr -> Expr -}
          return (\e -> f (BinOp Sum e t))



import Parsing
import Control.Applicative hiding (many)

{-
  expr -> expr (’+’ term | ’-’ term) | term
  term -> term (’*’ factor | ’/’ factor ) | factor
  factor -> digit | ’(’ expr ’)’
  digit -> ’0’ | ’1’ | ... | ’9’
-}

{-
  expr -> term expr'
  expr' -> ('-' term | '+' term)  expr' | ε
  term -> factor term'
  term' -> ('*' factor | '/' factor) term' | ε
  factor -> digit | ’(’ expr ’)’
  digit -> ’0’ | ’1’ | ... | ’9’
-}

data Expr = Num Int
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr
  deriving Show


digit :: Parser Expr
digit = do n <- nat 
           return Num n 

factor :: Parser Expr
factor = digit <|> do symbol "("
                      e <- expr
                      symbol ")"
                      return e

term :: Parser Expr
term = do f <- factor 
          term' f

term' :: Expr -> Parser Expr
term' acc =
      (do symbol "*"
          f <- factor
          term' (Mul acc f))
  <|> (do symbol "/"
          f <- factor
          term' (Div acc f))
  <|> return acc


expr :: Parser Expr
expr = do
  t <- term
  expr' t

expr' :: Expr -> Parser Expr
expr' acc =
      (do symbol "+"
          t <- term
          expr' (Add acc t))
  <|> (do symbol "-"
          t <- term
          expr' (Sub acc t))
  <|> return acc