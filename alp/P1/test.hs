n = \ f x . f(n) x

resta = \ n1 n2 . n2 pred n1       -- (n1 - n2)

max = \ n1 n2 . if (isZero resta n1 n2) then n2 else n1


Nil ≡ λc n. n
Cons ≡ λx xs. λc n. c x (xs c n)

maximun Nil = Zero 
maximun (Cons x xs) = max x (maximun xs)

maximun xs = foldr xs max Zero

maximun = \ xs . xs max Zero


(\ xs . xs max Zero) (\ c n. c 1 (c 2 (c 3 n)))
(\ c n. c 1 (c 2 (c 3 n))) max Zero
max 1 (max 2 (max 3 Zero))
max 1 (max 2 3)
max 1 3
3


and = \ x y . if x then y else False

eq = \ n m . and (isZero (resta n m)) (isZero (resta m n))
                 

mod' = \ f . \ n m . if (and (isZero (resta n m)) (eq n m)) 
                     then Zero 
                     else if (isZero (resta n m)) 
                          then n
                          else f ((resta n m) m )

mod = Y mod' = mod' (Y mod') = mod' mod



7 / 2 

6 / 2 

7 - 2 => 5 - 2 => 3 - 2 => 1 - 2

max R 2 == R





tree :: Parser (GenTree Int)

data GenTree a = N a [GenTree a]

tree = do symbol "("
          t <- tree'
          symbol ")"
          return t 

tree' = do symbol "N"
           x <- nat
           xs <- many tree
           return (N x xs)


tree :: Parser (GenTree Int)
tree = do
  symbol "("
  symbol "N"
  v <- natural
  children <- many tree
  symbol ")"
  return (N v children)



<suc error, rho> => error  (SUCERROR)




data Cur = A | D
data Term = Add Term Term | Suc Term | Conv Cur Term | Cur Nat

t :=  t '+' t | m nv | 'suc' '(' t ')' | 'conv' m '(' t ')'
m := 'ar$' | 'us$' 
nv := '0' | 'suc' '(' nv ')'

term :: Parser Term 
term = do t1 <- term 
          symbol "+"
          t2 <- term 
          return (Add t1 t2)
   <|> parseM
   <|> parseSuc
   <|> parseConv
          

parseM = do symbol "ar$"
           n <- natural 
           return (A n)   
        <|> 
        do symbol "us$"
           n <- natural 
           return (D n)   

parseSuc = do symbol "suc"
              t <- paren term
              return (Suc t)

parseConv = do symbol "conv"
               m <- parseM 
               t <- paren term
               return Conv m t

paren p = do symbol "conv"
             symbol "("
             t <- p 
             symbol ")"
             return t
