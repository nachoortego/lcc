--1)
-- a) promedios : Seq Int → Seq Float, que dada una secuencia de enteros calcule el promedio de cada comienzo de la lista. Por ejemplo,

-- promedios〈2, 4, 3, 7, 9〉 = 〈2, 3, 3, 4, 5〉

promedios :: Seq Int -> Seq Float
promedios s = let (xs, xss) = scan (+) 0 s
                  s' = drop 1 (append xs xss)
                  l = length s'
              in tabulate (\i -> (nth i s') / i) l   

zip :: Seq a -> Seq b -> Seq (a, b)
zip s s' = if isEmpty s 
           then empty 
           else if isEmpty s'
                then empty
                else tabulate (\i-> (nth i s, nth i s')) (min (length s) (length s'))

-- b) mayores : Seq Int → Int, que dada una secuencia de enteros devuelva la cantidad de enteros en la secuencia que son mayores a todos los anteriores. Por ejemplo,

-- mayores〈1, 2, 5, 3, 5, 2, 7, 9 = 4

mayores :: Seq Int -> Int
mayores s = let (s', v) = (scan max maxBound s)
                s'' = append (drop 1 s) (singleton v)                
                zips = zip s s''
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
zip3 s1 s2 s3 = if isEmpty s1 
                then empty 
                else if isEmpty s2 
                     then empty
                     else if isEmpty s3
                          then empty
                          else tabulate (\i-> (nth i s1, nth i s2, nth i s3)) (min (lentgh s) (length s2) (length s3))

--4)
data Paren = Open | Close

matchParen :: Seq Paren -> Bool
matchParen s = matchP s == (0, 0)

matchP :: Seq Paren -> (Int, Int)
matchP s = showT s


matchParenScan :: Seq Paren -> Bool
matchParenScan s = let delta Open  = 1
                       delta Close = -1
                       acc = scan (+) 0 (map delta s)
                   in all (>= 0) acc && (nth (length i) acc) == 0

all :: (a -> Bool) -> Seq a -> Bool
all p s = reduce (&&) True (map p s)

--5)

combine :: (Int, Int, Int, Int, Int, Int) -> (Int, Int, Int, Int, Int, Int) -> (Int, Int, Int, Int, Int, Int)
combine (s, pref, suf, p, u, l) (s', pref', suf', p', u', l') = 
    if u <= p'  
    then let v = pref' + suf -- une ambos largos de secuencia 
         in if pref == l && suf' == l' then (max v s s', pref+pref', suf+suf', p, u', l+l') -- sufijo es toda la lista y prefijo es toda la lista
            else if pref == l -- si es solo el pref 
                 then (max v s s', pref+pref', suf, p, u', l+l')
                 else if suf' == l' -- si es solo el suf
                      then (max v s s', pref, suf+suf', p, u', l+l')
                      else (max v s s', pref, suf', p, u', l+l') -- otro caso
    else (max s s', pref, suf', p, u', l+l') -- no se pueden unir

base v = (1, 1, 1, v, v, 1)

val = (0, 0, 0, minBound, minBound, 0)

sccml :: Seq Int -> Int
sccml s = fst (reduce combine val (map base s))

--6)

cantMultiplos :: Seq Int -> Int
cantMultiplos s = let s' = tabulate (\i -> drop i s) (length s - 1) 
                      modSeq s = reduce (+) 0 (tabulate (\i -> p (nth 1 s) (nth i+1) ) (length s - 1))
                  in mapreduce (+) 0 modSeq s'

p :: Int -> Int -> Bool
p a b = if mod a b == 0 then 1 else 0

--7)
--a)
merge :: (a -> a -> Ordering) -> Seq a -> Seq a -> Seq a
merge ord s1 s2 = case showT s1 of
                    EMPTY -> s2
                    ELT x -> let (f1, f2) = (filter (ord x) s2) ||| (filter (not (ord x)) s2)
                             in append (append f1 x) f2
                    NODE l r -> let lastL = nth (length l - 1) l
                                    (f1, f2) = (filter (ord lastL) s2) ||| (filter (not (ord lastL)) s2)
                                    (l1, r1) = merge l f1 ||| merge r f2
                                in append l1 r1


--b)
sort :: (a -> a -> Ordering) -> Seq a -> Seq a
sort ord s = reduce empty (merge ord) s

--c)
maxE :: (a -> a -> Ordering) -> Seq a -> a
maxE ord s = reduce (maxf ord) (nth 1 s) s

maxf :: (a -> a -> Ordering) -> Seq a -> Seq a -> Seq a
maxf (ord a b) = if (ord a b) then b else a

--d)
maxS :: (a -> a -> Ordering) -> Seq a -> Nat
maxS ord s = let ordZ (i1, a) (i2, b) = if (ord a b) then (i2, b) else (i1, a)
                 zippedS = zip (0..(length s)) s
             in fst (maxE ordZ zippedS)

--e)
group :: (a -> a -> Ordering) -> Seq a -> Seq a
group ord s = case showT s of
                EMPTY -> empty
                ELT x -> x
                NODE l r -> if (eq ord) (nth (length s) l) (nth 1 r) then append l (drop 1 r) else append l r  

groupAux ord l r = if (eq ord) (nth (length s) l) (nth 1 r) then append l (drop 1 r) else append l r

groupReduce ord s = flatten reduce (groupAux ord) empty (map singleton s)

eq :: (a -> a -> Ordering) -> a -> a -> Bool 
eq ord a b = (ord a b) == (ord b a)

--f)
--Recolecta todos los datos asociados a cada clave y devuelve una
--secuencia de pares ordenada seg´un el primer elemento. Por ejemplo,
--collect 〈(2, "A"), (1, "B"), (1, "C"), (2, "D")〉 = 〈(1, 〈"B", "C"〉), (2, 〈"A", "D"〉)

collect :: Seq (a, b) -> Seq (a, Seq b)
collect chancho = groupCollect (sort eo chancho) 

groupCollectAux eo l r = let ll = (nth (length s) l)
                             fr = (nth 1 r)
                         in
                            if (eq eo) ll fr 
                            then append (append (take ((length l) -1) l) (aka (ll fr))) (drop 1 r) 
                            else append l r

aka:: (a, b) -> (a,b) -> (a,b)
aka (a, x) (b, y) = (a, append x y)

groupCollect ord s = flatten (reduce (groupCollectAux ord) empty (map mapCol s))

eo:: a -> a -> Bool
eo (a, _) (b, _) = a <= b

mapCol (a, b) = singleton (a, singleton b)

--8)
datosIngreso :: Seq (String, Seq Int) -> Seq (Int, Int) 
datosIngreso s = mapCollectReduce apv red s

apv :: (String, Seq Int) -> Seq (Int, Float)
apv (_, s) = let prom = meanSeq s
             in 
                if prom >= 70 
                then singleton (1, prom)
                else if prom >= 50 
                     then singleton (2, prom)
                     else singleton (3, prom) 

red :: (Int, Seq Float) -> (Int, Float)
red (i, xs) = (i, maxE (<=) xs)