(|||):: (a,b)->(a,b)
x|||y = (x, y)

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

--5)
data Col = R | B
data RBT a = Emp | N Col (RBT a) a (RBT a)

-- los arbol T123 son una mierda !!!
data T123 a = E
    | N1 a (T123 a) (T123 a)
    | N2 a a (T123 a) (T123 a) (T123 a)
    | N3 a a a (T123 a) (T123 a) (T123 a) (T123 a)


-- los arboles 123 son CLAVE ! <----
trans :: RBT a -> T123 a
trans Emp = E
trans (N x B (N y R h1 h2) (N z R h3 h4)) =
    let ((r1, r2), (r3, r4)) = (trans h1 ||| trans h2) ||| (trans h3 ||| trans h4)
    N3 y x z r1 r2 r3 r4
--trans N3 y x z  --raiz negra, dos hijos rojos
--trans N2 y x    --raiz negra y hijo izq rojo / raiz negra hijo derecho rojo
--trans N1 x      --raiz negra (INVARIANTE en este caso)

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
        