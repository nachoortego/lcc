--1)
--a)
insert k v (insert k' v' d) = if k == k' 
                              then insert k v d
                              else insert k' v' (insert k v) d

erase k empty = empty
erase k (insert k' v' d) = if k == k' 
                           then d 
                           else insert k' v' (erase k d)

isKey k empty = False
isKey k (insert k' v' d) = if k == k' 
                           then True
                           else isKey k d

lookup k empty = Nothing
lookup k (insert k' v' d) = if k == k' 
                            then Just v'
                            else lookup k d

--b)

data BST k v = E | N (BST k v) (k v) (BST k v)

lookup k E = Nothing 
lookup k (N l (q, v) r) | k == q = Just v 
                        | k < q = lookup k l 
                        | otherwise = lookup k r 

insert k v E = N E (k, v) E 
insert k v (N l (q, w) r) | k == q = N l (k, v) r 
                          | k < q = N (insert k v l) (q, w) r
                          | otherwise = N l (q, w) (insert k v r)


P(t) = lookup k (insert k v t) = Just v

CB:

P(E) = lookup k (insert k v E) =  <def insert.1>
       lookup k (N E (k, v) E) =  <def lookup.2> <k == k>
       Just v

CI:
HI1) lookup k (insert k v l) = Just v 
HI2) lookup k (insert k v r) = Just v 

k == q:

P(N l (q, v') r) = lookup k (insert k v (N l (q, w) r))   <def insert.2> <k == q>
                 = lookup k (N l (k, v) r)                <def lookup.2> <k == k>
                 = Just v 

k < q:

P(N l (q, v') r) = lookup k (insert k v (N l (q, w) r))   <def insert.2> <k < q>
                 = lookup k (N (insert k v l) (q, w) r)   <def lookup.2> <k < k>
                 = lookup k (insert k v l)                <HI1> 

k > q: ANALOGO con HI2


--2)
data Tree a = E | N Int (Tree a) a (Tree a)

filterPrefix :: (a -> Bool) -> Tree a -> Tree a
filterPrefix p E           = E
filterPrefix p (N _ l x r) = let l' = filterPrefix l
                                 px = p x && (l' /= E || l == E)
                             in 
                               if px 
                               then (N l x filterPrefix r)
                               else E

-- Agregar un parametro bool cuando no se cumple la condicion 
-- y recibir en la llamda recursiva

--3)
longestStreak :: Float -> Seq Float -> Int 
longestStreak val s = let s' = map (\x -> if x > val then 1 else 0) s
                          s'' = map (\v -> (v, v, v, v)) s'
                          (s_red, r) = scan g (nth 0 s') (drop 1 s') 
                          ans = append s_red (singleton r)
                      in reduce max 0 ans
                      where g (v1, l1, s1, r1) (v2, l2, s2, r2) | v1 == 0 && v2 == 0 = (0, 0, max s1 s2, 0)
                                                                | v1 == 0 && v2 == 1 = (1, 0, max s1 s2, r2)
                                                                | v1 == 1 && v2 == 0 = (1, l1, max s1 s2, 0)
                                                                | v1 == 1 && v2 == 1 = (1, l1, max (max s1 s2) (r1 + l2), r2)
        