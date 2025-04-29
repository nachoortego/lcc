{- 
--1)
--completo :: a → Int → Tree a, tal que dado un valor x de tipo a y un entero d , crea un arbol binario completo de altura d con el valor x en cada nodo.


data Tree a = E | N (Tree a) a (Tree a)

completo :: a -> Int -> Tree
completo x 0 = E 
completo x h = let ch = completo x (h-1) in N ch x ch 

--balanceado :: a → Int → Tree a, tal que dado un valor x de tipo a y un entero n, crea un ´arbol binario balanceado de tamano n, con el valor x en cada nodo.

-- la diferencia entre tamaño de sub-hijo izquierdo y derecho es a lo sumo 1
balanceado :: a -> Int -> Tree a 
balanceado x 0 = E 
balanceado x n = if (mod n 2) == 0 then completo x n
                                   else impar x n

impar :: a -> Int -> Tree a 
--impar x h = 

-}


--2)
data BST a = E | N (BST a) a (BST a)

maximumBST :: Ord a => BST a -> a
maximumBST (N _ x E) = x
maximumBST (N l x r) = maximumBST r

--checkBST :: Ord a => BST a -> Bool
--checkBST E = True
--checkBST (N l x r) = 

splitBST:: Ord a => BST a -> a -> (BST a, BST a)
splitBST E _ = (E, E)
splitBST (N l y r) x | x == y = (N l y E, r)
                     | x < y = let (l', r') = splitBST l x
                               in (l', N r' y r)
                     | x > y = let (l', r') = splitBST r x
                               in (N l y l', r')

--join :: Ord a => BST a -> BST a -> BST a

--6)

-- Lista de numeros -> Lista de heaps unicos -> Merge a la lista de heaps

{-
Opcion 1:
    map + aplico merge
Opcion 2:
    folde (Funcion que toma un heap y un int, hace heap el de la derecha y mergea los 2)
-}

--7)
data PHeaps a = Empty | Root a [PHeaps a ]

-- cualquier nodo es menor que sus hijos
isPHeap :: Ord a => PHeaps a -> Bool
isPHeap Empty = True
isPHeap (Root a hs) = isRootLegChild a hs && areChildrenPH hs
    where
        isRootLegChild a [] = True
        isRootLegChild a (Empty:hs) = isRootLegChild a hs
        isRootLegChild a ((Root x chs) : hs) = a <= x && isRootLegChild a hs 
        
        areChildrenPH [] = True
        areChildrenPH (t:hs) = isPHeap t && areChildrenPH hs
        