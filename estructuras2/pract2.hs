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
