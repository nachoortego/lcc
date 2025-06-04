import Control.Applicative (Alternative(empty))
--1)
data BTree a = Empty | Node Int (BTree a) a (BTree a) deriving Show

t :: BTree Char
t = Node 8 
            (Node 3 (Node 1 Empty 'a' Empty) 'b' (Node 1 Empty 'c' Empty)) 
            'd' 
            (Node 4 (Node 1 Empty 'e' Empty) 'f' (Node 2 Empty 'g' (Node 1 Empty 'h' Empty)) )
inorder :: BTree a -> [a]
inorder Empty = []
inorder (Node n l a r) = (inorder l) ++ [a] ++ (inorder r)

size :: BTree a -> Int
size Empty = 0
size (Node n _ _ _) = n

nth :: BTree a -> Int -> a
nth Empty _ = error "index out of range"
nth (Node n l a r) i | i == sl = a
                     | i < sl = nth l n
                     | i > sl = nth r n
                    where
                        sl = size l
{-
Wnth(h) <= Wnth(h-1) + c1
Wmth(0) = c2

Wnth(h) pertenece a O(h)
-}

(|||) :: a -> b -> (a, b)
x ||| y = (x, y)

cons :: a -> BTree a -> BTree a
cons a Empty = Node 1 Empty a Empty
cons a (Node _ l _ _) = cons a l

tabulate :: (Int -> a) -> Int -> BTree a
tabulate f 0 = Empty
tabulate f n = cons (f n) (tabulate f (n-1))
{-
tabulate :: (Int -> a) -> Int -> Tree a
tabulate f n =  let m = div n 2
                    ((l, r), x) == (tabulate f m ||| tabulate (f.(+m+1)) (n-m-1)) ||| f m
                in N l x r

tabulate' f n m | m < n = E
                | True = let me = div (n+m) 2
                            ((l, r), x) = tabulate' f n (me - 1) ||
                            tabulate' f (me + 1) m ||
                            f me
                         in N l x r

-}
{-Cambia el trabajo no la profundidad (?)-}

mapBT :: (a -> b) -> BTree a -> BTree b
mapBT f Empty = Empty
mapBT f (Node n l a r) = let ((l', r'), a') = (mapBT f l ||| mapBT f r) ||| f a
                         in
                         Node n l' a' r'

{-
Wmap(h) = Wmap(h-1) + Wmap(h-1) + c1 + c2
Wmap(h) = 2*Wmap(h-1) + c
Wmap(0) = d

(En realidad es <=, se asume que los dos subarboles tienen la misma altura) (c1 es el trabajo de (f a), c2 es el trabajo de hacer el let y la construccion del nodo)

Smap(h) = max{Smap(h-1), Smap(h-1), c1} + c2
Smap(h) = Smap(h-1) + c2
Smap(h) = d
-}

takeBT :: Int -> BTree a -> BTree a
takeBT c Empty = Empty
takeBT 0 _ = Empty
takeBT c (Node n l a r) | c - sr == 0 = Node c l a Empty
                        | c - sr < 0 = takeBT c l
                        | c - sr > 0 = Node c l a (takeBT (c - sr) r)
                          where 
                            sr = size l

dropBT :: Int -> BTree a -> BTree a
dropBT c Empty = Empty
dropBT c (Node n l a r) | c < 0 = Empty
                        | c == sl = Node (sr + 1) Empty a r
                        | c < sl = Node (n - c) (dropBT c l) a r
                        | c > sl = dropBT (c - (sl + 1)) r
                          where 
                            sr = size r
                            sl = size l
--2)
data Tree a = E | Leaf a | Join (Tree a) (Tree a) deriving Show

{-
mcss' :: Tree Int -> (Int, Int, Int, Int)
mcss E = (0, 0, 0, 0)
mcss (Leaf x) = (max 0 x, max 0 x, max 0 x, x)
mcss' (Join l r) = let 
                    ((s1, suf1, pre1, l1), (s2, suf2, pre2, l2)) = mcss' l ||| mcss' r
                  in 
                    (max (max s1 s2) (suf1 + pre2), 
                     max suf2 (l2 + suf1),
                     max pre1 (l1 + pre2),
                     l1 + l2)

-- mcss :: (Num a, Ord a) => Tree a -> a
-- mcss = (\(x,y,z,w) -> x) mcss'

--3)
-}

mejorGanancia :: Tree Int -> Int
mejorGanancia = undefined

isEmpty :: Tree a -> Bool
isEmpty E = True
isEmpty _ = False

sufijos :: Tree Int -> Tree (Tree Int)
sufijos t = fst (sufijosDesde t E)

sufijosDesde :: Tree Int -> Tree Int -> (Tree (Tree Int), Tree Int)
sufijosDesde E acc = (E, acc)
sufijosDesde (Leaf x) acc = let newAcc = if isEmpty acc 
                                      then Leaf x 
                                      else Join (Leaf x) acc
                            in (Leaf acc, newAcc)
sufijosDesde (Join l r) acc = let (r', accR) = sufijosDesde r acc
                                  (l', accL) = sufijosDesde l accR
                              in (Join l' r', accL)

conSufijos :: Tree Int -> Tree (Int, Tree Int)
conSufijos t = fst (conSufijos' t E)

{-
conSufijos' :: Tree Int -> Tree Int -> Tree (Int, Tree Int)
conSufijos' E = Leaf (0, E)
conSufijos' (Leaf x) = Leaf (x, suf_x)
conSufijos' t@(Join l r) = let t_suf = sufijos t
                           in 
-}
conSufijos' :: Tree Int -> Tree Int -> (Tree (Int, Tree Int), Tree Int)
conSufijos' E acc = (E, acc)
conSufijos' (Leaf x) acc = let newAcc = if isEmpty acc 
                                      then Leaf x 
                                      else Join (Leaf x) acc
                            in (Leaf (x, acc), newAcc)
conSufijos' (Join l r) acc = let (r', accR) = conSufijos' r acc
                                 (l', accL) = conSufijos' l accR
                             in (Join l' r', accL)

reduceT :: Tree a -> (a -> a -> a) -> a -> a
reduceT E f e = e
reduceT (Leaf x) f e = x
reduceT (Join l r) f e = let (l', r') = reduceT l f e ||| reduceT r f e
                         in f l' r'

maxT :: Tree Int -> Int
maxT t = reduceT t max (-999999)

mapreduce :: (a -> b) -> (b -> b -> b) -> b -> Tree a -> b
mapreduce f g e  = mr
                  where mr E = e
                        mr (Leaf a) = f a
                        mr (Join l r ) = let (l', r') = mr l ||| mr r
                                         in g l' r'

maxAll :: Tree (Tree Int) -> Int
maxAll = mapreduce maxT max (-999999)

t3 :: Tree Int
t3 = Join (Join (Leaf 9) (Leaf 11)) (Leaf 33)

--4)
{-

data T a = E | N (T a) a (T a) 
altura :: T a -> Int
altura E = 0
altura (N l x r ) = 1 + max (altura l) (altura r)

combinar :: T a -> T a -> T a
combinar E t = t
combinar (N l x r) t2 = (N (combinar l r) x t2)

filterT :: (a -> Bool) -> T a -> T a 
filterT _ E = E
filterT p (N l x r) = let (l', r') = (filterT p l) ||| (filterT p r)
                      in 
                        if p x 
                        then N l' x r'
                        else combinar l' r'

quicksort :: Ord a => T a -> T a
quicksort E = E 
quicksort t@(N l x r) = let (l', r') = filterT (< x) t ||| filterT (> x) t
                      in N (quicksort l') x (quicksort r')

inorderT :: T a -> [a]
inorderT E = []
inorderT (N l a r) = (inorderT l) ++ [a] ++ (inorderT r)

t1 = (N (N E 4 (N E 9 E)) 2 (N E 3 E))

-}

--5)

-- data BTree a = Empty | Node Int (BTree a) a (BTree a)

splitAtBT :: BTree a -> Int -> (BTree a, BTree a)
splitAtBT t i = let (t', d ) = takeBT i t ||| dropBT i t
                in (t', d)

elemBT :: BTree a -> a
elemBT Empty = error "Elem vacio"
elemBT (Node _ _ x _) = x

rebalance :: BTree a -> BTree a
rebalance Empty = Empty
rebalance t@(Node i l x r) = let (l', r') = splitAtBT t (div i 2)
                                 (x', r'') = splitAtBT r' 1
                             in Node i (rebalance l') (elemBT x') (rebalance r'')

-- Árbol desbalanceado de ejemplo
arbolDesbalanceado :: BTree Int
arbolDesbalanceado =
  Node 7
    (Node 4
      (Node 2
        (Node 1 Empty 1 Empty)
        2
        Empty)
      3
      (Node 1 Empty 4 Empty))
    5
    (Node 2
      Empty
      6
      (Node 1 Empty 7 Empty))

{-
            5
          /   \
         3     6
        / \     \
       2   4     7
      /
     1
-}
