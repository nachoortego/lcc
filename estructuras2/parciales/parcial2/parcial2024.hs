--1)
--a)
insert k v (insert k' v' d) = if k == k' 
                              then insert k (v ++ v') d 
                              else insert k v d 

erase k v empty = empty
erase k v (insert k' v' d) = if k == k' 
                             then d 
                             else erase k v d

lookup k empty = EmptySet
lookup k (insert k' v' d) = if k == k' 
                            then v' 
                            else lookup k d

isValue k v empty = False
isValue k v (insert k' v' d) = if k == k' 
                               then v == v' 
                               else isValue k v d

toMap empty = EmptySet
toMap (insert k v d) = (k,v) ++ toMap d


--b) 
data MultiDic k v = E | N (MultiDic k v) (k, Tree v) (MultiDic k v)

data Tree a = Empty | Leaf a | Node Int (Tree a) (Tree a)

isValue :: (Ord k, Eq v) => k -> v -> MultiDic k v -> Bool
isValue k v E = False 
isValue k v (N l (k', t) r) | k == k' = search t
                            | k <= k' = isValue k v l
                            | k > k'  = isValue k v r
                              where 
                                search Empty        = False 
                                search (Leaf v')    = v == v'
                                search (Node _ l r) = let (ls, rs) = search l ||| search 
                                                      in ls || rs

toMap :: Ord k => MultiDic k v -> Tree (k, Int, v)
toMap E = Empty 
toMap (N l (k, t) r) = let (l', r') = toMap l ||| toMap r 
                       in join l' (join (flatten 0 t) r')
                         where
                          flatten i Empty        = Empty
                          flatten i (Leaf v)     = Leaf (k, i, v)
                          flatten i (Node n l r) = let (lf, rf) = flatten i k l ||| flatten (i + size l) k r
                                                   in join lf rf

size :: Tree a -> Int
size Empty        = 0
size (Leaf _)     = 1
size (Node n _ _) = n

join :: Tree a -> Tree a -> Tree a
join Empty r = r
join l Empty = l 
join l r     = Node (size l + size r) l r

-- toMap ⟨⟨1, ⟨a, f, g⟩⟩,⟨2, ⟨m,a⟩⟩⟩ = ⟨(1,0,a), (1, 1, f), (1, 2, g), (2, 0, m), (2, 1, a)⟩

--c)

erase :: (Ord k, Eq v) => k -> v -> MultiDic k v -> MultiDic k v
erase k v (N l (k', vs) r) | k === k' = N l (k elim v vs) r 
                           | k < k'   = N (erase k v l) (k', vs) r 
                           | k > k'   = N l (k', vs) (erase k v r) 
erase k v E = E


isBST (N l (k, _) r) = (isHoja l || maxT l <= k) && 
                       (isHoja r || minT r > k) 
                       && isBST l && isBST r
                        where
                          isHoja E = True 
                          isHoja _ = False
                          maxT (N _ (k, _) E) = k
                          maxT (N _ _ r)      = maxT r
                          minT (N E (k, _) _) = k
                          minT (N l _ _)      = minT l
isBST E = True

CB:
(HIP) isBST E = True

isBST (erase k v E) = <def erase.2>
isBST E             = <HIP>
True

CI:
(HIP) isBST (N l (k, _) r) = True

(HI1) isBST l => isBST (erase k v l)
(HI2) isBST r => isBST (erase k v r)

Desarrollo de (HIP):
  (isHoja l || k >= maxT l)   (HIP1)
  (isHoja r || k < minT r)    (HIP2)
  isBST l                     (HIP3)
  isBST r                     (HIP4)


(TESIS) isBST (erase k v (N l (k', _) r)) = True 

CASO k == k':

isBST (erase k v (N l (k', vs) r))     = <erase.1> <k==k'>

isBST (N l (k (elim v vs)) r )          = <isBST.1>

(isHoja l || maxT l <= k) && 
(isHoja r || minT r > k) && 
isBST l && isBST r                    = <HIP 1,2,3,4>

True 

CASO k < k': 
isBST (erase k v (N l (k', vs) r))                     = <erase.1> <k<k'>

isBST (N (erase k v l) (k', vs) r)                    = <isBST.1>

(isHoja (erase k v l) || maxT (erase k v l) <= k) && 
(isHoja r || minT r > k) && 
isBST (erase k v l) && isBST r                        = <HIP3->HI1> <HIP2> <HIP4>

(isHoja (erase k v l) || maxT (erase k v l) <= k)     = <Lema: maxT t >= maxT (erase k v t)>
                                                        <Lema: isHoja E == isHoja (erase k v E)> 
                                                        <HIP1>
True 

CASO k > k': ANALOGO

--2)

spaml :: Seq Int -> Int
spaml s | n <= 2     = n
        | otherwise = spaml_aux s
  where n = length s

spaml_aux :: Seq Int -> Int
spaml_aux s =
  let
    n     = length s
    s_dif = tabulate (\i -> nth (i + 1) s - nth i s) (n - 1)

    s_info = map f s_dif
    (s_red, r) = scan g (nth 0 s_info) (drop s_info 1)
    s_res  = map h (append s_red (singleton r))
    f = (\x -> (1, x, x, 1, 1, 1))
    g = g'
    h = fst
  in
    1 + reduce max 0 s_res
  where g' (s1, p1, u1, pref1, suf1, l1) (s2, p2, u2, pref2, suf2, l2) = 
    if u1 == p2 
    then let v = suf1+pref2
         in if pref1 == l1 && suf2 == l2
            then (maximum [s1, s2, v], p1, u2, pref1+pref2, suf1+suf2, l1+l2)
            else if pref1 == l1 
                  then (maximum [s1, s2, v], p1, u2, pref1+pref2, suf2, l1+l2)
                  else if suf2 == l2 
                      then (maximum [s1, s2, v], p1, u2, pref1, suf1+suf2, l1+l2)
                      else (maximum [s1, s2, v], p1, u2, pref1, suf2, l1+l2)
    else (max s1 s2, p1, u2, pref1, suf2, l1+l2)