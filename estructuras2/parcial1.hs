data Treap p k = E | N (Treap p k) p k (Treap p k)

key :: Treap p k -> k
key (N _ _ k _) = k

priority :: Treap p k -> p 
priority (N _ p _ _) = p

isTreap :: (Ord k, Ord p) => Treap p k -> Bool 
isTreap E = True
isTreap t = isBinSearch t && isMaxHeap t 
            where
              isBinSearch E = True
              isBinSearch (N l _ k r) = k >= key l && k <= key r && isBinSearch l && isBinSearch r
              isMaxHeap E = True
              isMaxHeap (N l p _ r) = p >= priority r && p >= priority l && isMaxHeap l && isMaxHeap r

-- isTreap(0) = c1
-- isTreap(h) = isBinSearch(h) + isMaxHeap(h)
-- isBinSearch(0) = c2
-- isBinSearch(h) = c3 + c4 + 2*isBinSearch(h-1)
-- isMaxheap(0) = c5
-- isMaxheap(h) = c6 + c7 + 2*isMaxHeap(h-1)

rotateL (N l' p' k' (N l p k r)) = N (N l' p' k' l) p k r
rotateR (N (N l p k r) p' k' r' ) = N l p k (N r p' k' r' )

insert :: (Ord k, Ord p) => k -> p -> Treap p k -> Treap p k
insert k p E = N E p k E
insert k p (N l p' k' r) | k == k'  = N l p k r
                         | k < k'   = let l' = insert k p l
                                      in if priority l' > p' then rotateR (N l' p' k' r)
                                                             else N l' p' k' r
                         | k > k'   = let r' = insert k p r
                                      in if priority r' > p' then rotateL (N l p' k' r')
                                                             else N l p' k' r'

split :: (Ord k, Ord p, Num p) => k -> Treap p k -> (Treap p k, Treap p k)
split _ E = (E, E)
split k t@(N _ p _ _) =  let (N l _ _ r) = insert k (p + 1) t
                         in (l, r)