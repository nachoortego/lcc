--1)
-- a) promedios : Seq Int → Seq Float, que dada una secuencia de enteros calcule el promedio de cada comienzo de la lista. Por ejemplo,

-- promedios〈2, 4, 3, 7, 9〉 = 〈2, 3, 3, 4, 5〉

promedios :: Seq Int -> Seq Float
promedios s = let (xs, xss) = scan (+) 0 s
                  s' = drop 1 (append xs xss)
                  l = length s'
              in tabulate (\i -> (nth i s') / i) l   

zip :: Seq a -> Seq b -> Seq (a, b)
zip s s' = if s == empty 
           then empty 
           else if s' == empty 
                then empty
                else tabulate (\i-> (nth i s, nth i s')) (min (length s) (length s'))

-- b) mayores : Seq Int → Int, que dada una secuencia de enteros devuelva la cantidad de enteros en la secuencia que son mayores a todos los anteriores. Por ejemplo,

-- mayores〈1, 2, 5, 3, 5, 2, 7, 9 = 4

mayores :: Seq Int -> Int
mayores s = let (xs, xss) = (scan max maxBound s)
                s' = drop 1 (append xs xss)
                zips = zip s s'
            in reduce (+) 0 (map compare zips)
            where
                compare (a, b) | a > b = 1
                               | otherwise = 0


--2)
--Dar una definicion de la funcion fibSeq : Nat → Seq Nat, que dado un natural n calcule la secuencia de los primeros n numeros de Fibonnacci, cuyo trabajo y profundidad sean W (n) = n y S(n) = lg(n). Utilizar la funcion scan.

fibSeq :: Nat -> Seq Nat 
fibSeq n = tabulate (\i -> ) n

--3)

aguaHist :: Seq Int -> Int
aguaHist s = let s' = append 0 s
                 s'' = append s' 0
                 maxL = scan max maxBound s
                 maxR = reverse (scan max maxBound (reverse s))
                 newS = zip3 maxL maxR s''
                 water = map (\(a, b, c) -> (min a b) - c) newS
             in
                reduce (+) 0 water

reverse :: Seq a -> Seq a 
reverse s = tabulate (\i -> nth (length s - i) s) (length s)

zip3 :: Seq a -> Seq b -> Seq c -> Seq (a, b, c)
zip3 :: Seq a -> Seq b -> Seq (a, b)
zip3 s1 s2 s3 = if isEmpty s1 
                then empty 
                else if s2 == empty 
                     then empty
                     else if s3 == empty 
                          then empty
                          else tabulate (\i-> (nth i s1, nth i s2, nth i s3)) (min (lentgh s) (length s2) (length s3))