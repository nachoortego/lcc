data Bin a = Hoja | Nodo (Bin a) a (Bin a)

minimumBST :: Bin a -> a
minimumBST (Nodo Hoja a r) = a
minimumBST (Nodo l a r) = minimumBST l

maximumBST :: Bin a -> a
maximumBST (Nodo l a Hoja) = a
maximumBST (Nodo l a r) = maximumBST r

checkBST :: Ord a => Bin a -> Bool
checkBST Hoja = True
checkBST (Nodo Hoja a Hoja) = True
checkBST (Nodo Hoja a r) = checkBST r && a < minimumBST r
checkBST (Nodo l a Hoja) = checkBST l && a >= maximumBST l
checkBST (Nodo l a r) = checkBST l && checkBST r && a >= maximumBST l && a < minimumBST r

data Color = R | B
data RBT a = E | T Color (RBT a) a (RBT a)

balance :: Color -> RBT a -> a -> RBT a -> RBT a
balance B (T R (T R a x b) y c) z d = T R (T B a x b) y (T B c z d)
balance B (T R a x (T R b y c)) z d = T R (T B a x b) y (T B c z d)
balance B a x (T R (T R b y c) z d) = T R (T B a x b) y (T B c z d)
balance B a x (T R b y (T R c z d)) = T R (T B a x b) y (T B c z d)
balance c l a r = T c l a r

makeBlack :: RBT a -> RBT a
makeBlack _ l a r = B l a r

insert :: Ord a => a -> RBT a -> RBT a
insert x t = makeBlack (ins x t)
where ins x E = T R E x E
ins x (T c l y r ) | x < y = balance c (ins x l) y r
| x > y = balance c l y (ins x r )
| otherwise = T c l y r
makeBlack E = E
makeBlack (T l x r ) = T B l x r