--1)

data BTree a = E | L a | N Int (BTree a) (BTree a)

size :: BTree a -> Int 
size (N n _ _) = n 

stripSufix :: Eq a => BTree a -> BTree a -> Maybe (BTree a)
stripSufix E t = Just t
stripSufix suf t | size suf > size = Nothing 
                 | otherwise = let (l, r) = splitAt (size t - size suf) t
                               in if (eq r suf) 
                                  then Just l 
                                  else Nothing 

splitAt :: Int -> BTree a -> (BTree a, BTree a)
splitAt _ E = (E, E)
splitAt i t@(L a) | i <= 0    = (E, t)
                  | otherwise = (t, E)
splitAt i (N n l r) | i < sizeL = let (l1, l2) = splitAt i l
                                  in (l1, N (size l2 + size r) l2 r)
                    | i == sizeL = (l, r)
                    | otherwise  = let (r1, r2) = splitAt (i - sizeL) r
                                   in (N (size l + size r1) l r1, r2)
                      where
                        sizeL = size l


inorder :: BTree a -> [a]
inorder t = go t []
  where
    go E acc = acc
    go (L a) acc = a : acc
    go (N _ l r) acc = go l (go r acc)

eq :: Eq a => BTree a -> BTree a -> Bool
eq t1 t2 = let (t1', t2') = inorder t1 ||| inorder t2 
           in t1' == t2'

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

dimension (set i v arr) = dimension arr 
dimension (new d v) = d 

get i (set j v arr) = if i == j 
                      then v 
                      else get i arr
get i (new d v) = v

slicing i j arr = slicing' i i j arr

slicing' t i j arr = if t <= j 
                     then set (t - i) (get t arr) (slicing' (t + 1) i j arr)
                     else new (j - i + 1) (get 0 arr)

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


