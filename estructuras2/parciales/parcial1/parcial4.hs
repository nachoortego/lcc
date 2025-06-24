data Color = R | B deriving (Eq, Show)
data AATree a = N Color a (AATree a) (AATree a) | E deriving (Eq, Show)

isEmpty :: AATree a -> Bool
isEmpty E = True
isEmpty _ = False

isBST :: Ord a => AATree a -> Bool
isBST E = True
isBST (N _ x l r) = checkR r && checkL l && isBST l && isBST r 
                    where
                      checkL t@(N _ x1 _ _) = if isEmpty t then True else x > x1
                      checkR t@(N _ x2 _ _) = if isEmpty t then True else x <= x2

{- Variante mas corta
isBST :: Ord a => AATree a -> Bool
isBST E = True
isBST (N _ x l@(N _ xl _ _) r@(N _ xr _ _)) = x > xl && x <= xr && isBST l && isBST r
isBST (N _ x E r@(N _ xr _ _))              = x <= xr && isBST r
isBST (N _ x l@(N _ xl _ _) E)              = x > xl && isBST l
isBST (N _ _ E E)  
-}

getColor :: AATree a -> Color
getColor (N c _ _ _) = c

isAATree :: Ord a => AATree a -> Bool
isAATree E = True 
isAATree t@(N c _ _ _) = c == B && checkColors t && checkH t && isBST t
             where
              checkColors E = True
              checkColors (N c _ l@(N cl _ _ _) r@(N cr _ _ _)) = cl /= R && (if c == R then c /= cr else True) && checkColors r && checkColors l
              checkColors (N c _ E r@(N cr _ _ _)) = (if c == R then c /= cr else True) && checkColors r
              checkColors (N c _ l@(N cl _ _ _) E) = cl /= R && checkColors l
              checkColors (N c _ E E) = True
              checkH E = True
              checkH (N c _ l r) = let bl = blackH l
                                       br = blackH r
                                  in bl == br && bl /= -1 && checkH l && checkH r
              blackH E = 0
              blackH (N c _ l r) | blackH l /= blackH r = -1
                                 | otherwise = blackH l + if c == B then 1 else 0

member :: Ord a => a -> AATree a -> Bool
member a E = False
member a (N _ x l r) | a < x = member a l
                     | a > x = member a r
                     | otherwise = True

insert :: Ord a => a -> AATree a -> AATree a
insert a t = makeBlack (ins a t)
             where
               ins a E = (N R a E E)
               ins a (N c x l r) | a < x = let l' = ins a l
                                           in rebalance (N c x l' r)
                                 | a > x = let r' = ins a r
                                           in rebalance (N c x l r')
                                 | a == x = (N c a l r)
               rebalance t = split (skew t)
               skew t@(N _ _ E _) = t
               skew t@(N _ _ (N B _ _ _) _) = t
               skew (N c y (N R x lx rx) r) = N c x lx (N R y rx r)
               split t@(N _ _ _ E) = t
               split t@(N _ _ _ (N _ _ _ E)) = t
               split (N c x lx (N R y ly (N R z lz rz))) = N R y (N B x lx ly) (N B z lz rz)
               makeBlack (N _ x l r) = (N B x l r)
