--1)

data BTree a = E | L a | N Int (BTree a) (BTree a)

stripSufix :: Eq a => BTree a -> BTree a -> Maybe (BTree a)
stripSufix E s = Just s
stripSufix _ E = Nothing
stripSufix suf s = let ((lsuf, suf'),(ls, s')) = last suf ||| last s
                   in
                     if lsuf == ls
                     then stripSufix suf' s'
                     else Nothing

last :: BTree a -> (BTree a, Maybe a)
last E = (E, Nothing)
last (L a) = (E, Just a) 
last (N n l E) = let (l', a) = last l
                 in (N (n-1) l' E, a)
last (N n l r) = let (r', a) = last r
                 in (N (n-1) l r', a)

-- agarrar tamaño del primer argumento O(1) y comparar 

splitTree :: BTree a -> n -> (BTree a, BTree a)
splitTree E _ = (E, E)
splitTree (L a) _ = a


--2) 

maxBalance :: Seq Int -> Int 
maxBalance s = let s' = map (\a -> (a, a, a, a)) s
                   (s_red, last) = scan g (nth 0 s') (drop 1 s')
                   s'' = append s_red (singleton last)
                   ans = map (\(_, _, _, s) -> s) s''
               in
                 reduce max -9999 ans
               where 
                 g (n1, l1, r1, s1) (n2, l2, r2, s2) =
                let n = n1 + n2
                    l = max l1 (n1 + l2)
                    r = max r2 (r1 + n2)
                    s = maximum [s1, s2, r1 + l2]
                in (n, l, r, s)


--3)

dimension (new 0 v) = 0
dimension (new n v) = n
dimension (set i v a) = dimension a
dimension (slicing i j a) = j - i + 1

get i (new n v) = v
get j (set i v a) = if i == j then v else get j a
get k (slicing i j a) = get (i + k) a


--4) 

P(t) = map f . flatten t = flatten . mapRose f t 

CB:

P(E) = map f . flatten E = <def .>
       map f (flatten E) = <def flatten.1>
       map f []          = <def map.1>
       [] 

P(E) = flatten . mapRose f E = <def .>
       flatten (mapRose f E) = <def mapRose.1>
       flatten E             = <def flatten.1>
       []

CI:

HI) map f (flatten x) = flatten (mapRose f x) | x perteneciente a xs

LEMA) concat (map (map f) xs) = map f (concat xs)

TESIS) P(N a xs)

      map f . flatten (N a xs)                            = <def .>
      map f (flatten (N a xs))                            = <def flatten.2>
      map f (a : concat (map flatten xs))                 = <def map.2>
      f a : map f (concat (map flatten xs))               = <LEMA> 
      f a : concat (map (map f) (map flatten xs))         = <HI>
      f a : concat (map flatten (map (mapRose f) xs))     

      flatten (mapRose f (N a xs))                        = <def mapRose.2>
      flatten (N (f a) (map (mapRose f) xs))              = <def flatten.2>
      f a : concat (map flatten (map (mapRose f) xs))


