module Heap (
    Heap,
    empty,
    isEmpty,
    insert,
    findMin,
    deleteMin,
    merge
) where

type Rank = Int
data Heap a = E | N Rank a (Heap a) (Heap a) deriving Show

merge :: Ord a => Heap a -> Heap a -> Heap a
merge h1 E = h1
merge E h2 = h2
merge h1@(N _ x a1 b1) h2@(N _ y a2 b2) =
    if x <= y then makeH x a1 (merge b1 h2)
              else makeH y a2 (merge h1 b2)

rank :: Heap a -> Rank
rank E           = 0
rank (N r _ _ _) = r

makeH :: a -> Heap a -> Heap a -> Heap a
makeH x h1 h2 = if rank h1 > rank h2
              then N (rank h2 + 1) x h1 h2
              else N (rank h1 + 1) x h2 h1

empty :: Ord a => Heap a
empty = E

isEmpty :: Heap a -> Bool
isEmpty E = True
isEmpty _ = False

insert :: Ord a => a -> Heap a -> Heap a
insert x = merge (N 1 x E E)

findMin :: Ord a => Heap a -> a
findMin (N _ x _ _) = x

deleteMin :: Ord a => Heap a -> Heap a
deleteMin (N _ x h1 h2) = merge h1 h2