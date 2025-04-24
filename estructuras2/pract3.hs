import Data.List

--1)
--Definir un tipo Color en este modelo y una funcion mezclar que permita obtener el promedio componente a componente entre dos colores.

-- type Color = (Int, Int, Int)

-- data Color = RGB Int Int Int 

data Color = RGB {
    red   :: Int,
    green :: Int,
    blue  :: Int
}

mezclar :: Color -> Color -> Color
--mezclar (r1,g1,b1) (r2,g2,b2) = (avg r1 r2, avg g1 g2, avg b1 b2)
--                              where avg x y = div (x+y) 2

avg x y = div (x+y) 2

mezclar c1 c2 = RGB {
                        red = avg (red c1) (red c2),
                        green = avg (green c1) (green c2),
                        blue = avg (blue c1) (blue c2)
                    }

--mezclar (RGB r1 g1 b1) (RGB r2 g2 b2) = RGB (avg r1 r2) (avg g1 g2) (avg b1 b2)
--2)
data Linea = Linea [Char] Int deriving Show

vacia :: Linea
vacia = Linea [] 0

moverIzq :: Linea -> Linea
moverIzq (Linea xs p) | p==0 = Linea xs 0
                      | otherwise = Linea xs (p-1)

moverDer :: Linea -> Linea
moverDer (Linea xs p) | p == length xs = Linea xs p
                      | otherwise = Linea xs (p+1)

moverIni :: Linea -> Linea
moverIni (Linea xs p) = Linea xs 0

moverFin :: Linea -> Linea
moverFin (Linea xs p) = Linea xs (length xs)

insertar :: Char -> Linea -> Linea
insertar c (Linea xs p) = Linea ((take p xs) ++ [c] ++ (drop p xs)) (p+1)

borrar :: Linea -> Linea
borrar (Linea xs 0) = (Linea xs 0)
borrar (Linea xs p) = Linea ((take (p-1) xs) ++ (drop p xs)) (p-1)

--4)
--Defina un evaluador eval :: Exp → Int para el siguiente tipo algebraico:

data Exp = Lit Int | Add Exp Exp | Sub Exp Exp | Prod Exp Exp | Div Exp Exp

eval :: Exp -> Int
eval (Lit n) = n
eval (Add e1 e2) = eval e1 + eval e2
eval (Sub e1 e2) = eval e1 - eval e2
eval (Prod e1 e2) = eval e1 * eval e2
eval (Div e1 e2) = div (eval e1)  (eval e2)

--5)
--a) Defina una funcion parseRPN :: String → Exp que, dado un string que representa una expresion escrita en RPN, construya un elemento del tipo Exp presentado en el ejercicio 4 correspondiente a la expresion dada. Por ejemplo: parseRPN “8 5 3 − 3 * +” = Add (Lit 8) (Prod (Sub (Lit 5) (Lit 3)) (Lit 3)) 

--Ayuda: para implementar parseRPN puede seguir un algoritmo similar al presentado anteriormente. En lugar de evaluar las expresiones, debe construir un valor de tipo Exp.

getFirst :: String -> (String, String)
getFirst s = aux "" (deleteSp s)
             where deleteSp (' ':s) = deleteSp s
                   deleteSp s = s
                   aux p "" = (reverse p, "")
                   aux p (' ':s) = (reverse p, deleteSp s) 
                   aux p ('+':s) = if p == [] then ("+", deleteSp s) else error "Expresion mal formada"
                   aux p ('-':s) = if p == [] then ("-", deleteSp s) else error "Expresion mal formada"
                   aux p ('*':s) = if p == [] then ("*", deleteSp s) else error "Expresion mal formada"
                   aux p ('/':s) = if p == [] then ("/", deleteSp s) else error "Expresion mal formada"
                   aux p (c:s) = aux (c:p) s


opTop :: (Exp -> Exp -> Exp) -> [Exp] -> String -> Exp
opTop op (x:y:p) s = parseS ((op y x):p) s
opTop _ _ _ = error "EMP"


parseS :: [Exp] -> String -> Exp
parseS p "" = if length p == 1 
                then head p
                else error "EMF"
parseS p s = case x of
                "+" -> opTop Add p s'
                "-" -> opTop Sub p s'
                "*" -> opTop Prod p s'
                "/" -> opTop Div p s'
                n -> parseS ((Lit (read n)):p) s'
                where(x, s') = getFirst s

parseRPN :: String -> Exp
parseRPN s = parseS [] s



--   |         |\
--   |\_______/  \_____
--    \              o \___
--     \_______\   /_______/
--             | /
--             -


{-
3. Dado el tipo de datos
a) Implementar las operaciones de este tipo algebraico teniendo en cuenta que:
Las funciones de acceso son headCL, tailCL, isEmptyCL, isCUnit.
headCL y tailCL no est´an definidos para una lista vac´ıa.
headCL toma una CList y devuelve el primer elemento de la misma (el de m´as a la izquierda).
tailCL toma una CList y devuelve la misma sin el primer elemento.
isEmptyCL aplicado a una CList devuelve True si la CList es vac´ıa (EmptyCL) o False en caso contrario.
isCUnit aplicado a una CList devuelve True sii la CList tiene un solo elemento (CUnit a) o False en caso
contrario.
b) Definir una funci´on reverseCL que toma una CList y devuelve su inversa.
c) Definir una funci´on inits que toma una CList y devuelve una CList con todos los posibles inicios de la CList.
d) Definir una funci´on lasts que toma una CList y devuelve una CList con todas las posibles terminaciones de la
CList.
e) Definir una funci´on concatCL que toma una CList de CList y devuelve la CList con todas ellas concatenadas
-}

data CList a = EmptyCL | CUnit a | Consnoc a (CList a) a

headCL :: CList a -> a
headCL (CUnit a) = a
headCL (Consnoc l EmptyCL r) = l
headCL (Consnoc l xs r) = l

tailCL :: CList a -> CList a

tailCL (CUnit a) = EmptyCL
tailCL (Consnoc l EmptyCL r) = CUnit r
tailCL (Consnoc l xs r) = Consnoc (headCL xs) (tailCL xs) r

isEmptyCL :: CList a -> Bool
isEmptyCL EmptyCL = True
isEmptyCL _ = False

isCUnit :: CList a -> Bool
isCUnit (CUnit a) = True
isCUnit _ = False

cons :: a -> CList a -> CList a
cons x EmptyCL = CUnit x
cons x (CUnit a) = Consnoc x EmptyCL a 
cons x (Consnoc a b c) = Consnoc x (cons a b) c

snoc :: CList a -> a -> CList a
snoc EmptyCL x = CUnit x
snoc (CUnit a) x = Consnoc a EmptyCL x
snoc (Consnoc a b c) x = Consnoc a (snoc b c) x