data Treap p k = E | N (Treap p k) p k (Treap p k)

key :: Treap p k -> k
key (N _ _ k _) = k

priority :: Treap p k -> p 
key (N _ p _ _) = p

isTreap :: (Ord k, Ord p) => Treap p k -> Bool 
isTreap E = True
isTreap t = isBinSearch t && isMaxHeap t 
            where
              isBinSearch E = True
              isBinSearch (N l p k r) = True