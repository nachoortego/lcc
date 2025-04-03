--ej 5)
f x = let (y, z ) = (x , x ) in y
f1 x = x

greater (x , y) = if x > y then True else False
f2 (x, y) = x > y

fc (x , y) = let z = x + y in g (z , y) where g (a, b) = a - b
f3 (x, y) = x

--ej 6)

-- smallest1 (x , y, z ) | x <= y && x <= z = x
--                      | y <= x && y <= z = y
--                      | z <= x && z <= y = z

smallest2 :: Int -> Int -> Int -> Int
smallest2 = \x y z -> if x <= y && x <= z then x else
                     if y <= x && y <= z then y else
                     z


--map (\x y (w,r)-> x + 1) [1, 2, 3]


-- second x = λx -> x
second2 = \x -> x

andThen True y = y
andThen False y = False

andThen2 = \x y -> x && y

twice f x = f (f x )
twice2 = \f x -> f (f x)

flip f x y = f y x
flip2 = \f x y -> f y x

inc1 = (+1)
inc2 = \x -> x + 1

--ej 7)

-- ff = λx -> λy -> if x then not y else y
ff x y | x = not y
       | otherwise = y

-- alpha = λx -> x
alpha x = x

-- ej 8)

-- Suponiendo que f y g tienen los siguientes tipos
-- f :: c -> d
-- g :: a -> b -> c
-- y sea h definida como
-- h x y = f (g x y)
-- Determinar el tipo de h e indicar cuales de las 
-- siguientes definiciones de h son equivalentes a la dada:
-- h = f . g
-- h x = f . (g x )
-- h x y = (f . g) x y -- CORRECTA
-- Dar el tipo de la funcion (.).

-- h :: a -> b -> d
-- (.) :: (b -> c) -> (a -> b) -> (a -> c)
-- (f.g) x = f (g x)

-- ej 9)
-- La funcion zip3 zipea 3 listas. Dar una definicion 
-- recursiva de la funcion y otra definicion con el mismo tipo
-- que utilice la funcion zip. ¿Que ventajas y desventajas 
-- tiene cada definicion?

zip3r :: [a] -> [b] -> [c] -> [(a,b,c)]
zip3r [] _ _ = []
zip3r _ [] _ = []
zip3r _ _ [] = []
zip3r (x:xs) (y:ys) (z:zs) = (x,y,z) : zip3r xs ys zs

zip3z :: [a] -> [b] -> [c] -> [(a,b,c)]
zip3z x y z = map (\((a, b), c) -> (a, b, c)) 
                  (zip (zip x y) z)


-- ej10)
-- [[ ]] ++ xs = xs --F si xs es [[]] devuelve la lista con [] adentro
-- [[ ]] ++ xs = [xs] --F 
-- [[ ]] ++ xs = [ ] : xs -- T
-- [[ ]] ++ xs = [[ ], xs] -- F
-- [[ ]] ++ [xs] = [[ ], xs] -- T
-- [[ ]] ++ [xs] = [xs ] -- F
-- [ ] ++ xs = [ ] : xs -- F
-- [ ] ++ xs = xs -- T
-- [xs] ++ [ ] = [xs] -- T
-- [xs] ++ [xs] = [xs, xs] -- T

-- ej11)
-- sqrt :: Float -> Float

modulus:: [Float] -> Float
modulus = sqrt . sum . map (**2)

vmod:: [[Float]] -> [Float] 
vmod [ ] = [ ]
vmod (v : vs) = modulus v : vmod vs


--ej 12)
type NumBin = [Bool]

-- a) suma binaria

sumbin:: NumBin -> NumBin -> NumBin
sumbin x y = sumbin_aux x y False

sumbin_aux:: NumBin -> NumBin -> Bool -> NumBin

xor:: Bool -> Bool -> Bool
xor x y = not (x == y)

sumbin_aux [] [] carry = if carry then [carry] else []
sumbin_aux [] (y:ys) carry = xor (xor False y) carry : sumbin_aux [] ys (y &&  carry)
sumbin_aux (x:xs) [] carry = xor (xor x False) carry : sumbin_aux xs [] (x &&  carry)
sumbin_aux (x:xs) (y:ys) carry = xor (xor x y) carry : sumbin_aux xs ys ((x && y) || ((xor x y) &&  carry))

-- b) producto binario
-- c) cociente y resto de la division por dos

-- ej13)
--divisors, que dado un entero positivo x devuelve la lista de los divisores de x (y la lista vacıa si el entero no es positivo).
divisors :: Int -> [Int]
divisors x | x > 0 = [ a | a <- [1..x], mod x a == 0 ]
           | otherwise = []

-- matches, que dados un entero x y una lista de enteros descarta de la lista los elementos distintos a x .
matches :: Int -> [Int] -> [Int]
matches x l =  [ a | a <- l, x == a ]

-- cuadruplas, que dado un natural n, devuelve las cuadruplas (a, b, c, d ) con 0 < a, b, c, d <= n que cumplen a ^ 2 + b ^ 2 = c ^ 2 + d ^ 2.
cuadruplas :: Int -> [(Int, Int, Int, Int)]
cuadruplas n = [ (a,b,c,d) | a <- [1..n],b <- [1..n],c <- [1..n],d <- [1..n], a ^ 2 + b ^ 2 == c ^ 2 + d ^ 2, a /= b, b /= c, c /= d, b /= d]

-- unique, que dada una lista xs de enteros, devuelve la lista con los elementos no repetidos de xs. Por ejemplo, unique [1, 4, 2, 1, 3] = [1, 4, 2, 3].
unique :: [Int] -> [Int]
unique xs = [x | (x, i) <- zip xs [0..], not (elem x (take i xs))]

-- crea la lista [(x1,1), (x2,2), ... , (xn,n)] y se fija que cada xk no este en la lista x1, ... , xk.


--ej 14)
-- 14. El producto escalar de dos listas de enteros de igual longitud es la suma de los productos de los elementos sucesivos (misma posicion) de ambas listas. Usando listas por comprension defina una funcion scalarproduct que devuelva el producto escalar de dos listas.
-- Sugerencia: Usar las funciones zip y sum.

scalarproduct :: [Int] -> [Int] -> Int
scalarproduct xs ys = sum [a * b | (a, b) <- zip xs ys]
