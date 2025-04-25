module Lab02 where

{-
   Laboratorio 2
   EDyAII 2022
-}

import Data.List

-- 1) Dada la siguiente definición para representar árboles binarios:

data BTree a = E | Leaf a | Node (BTree a) (BTree a)

tree = Node ( Node (Leaf "A") (E)) ( Node (Leaf "B") (Node (Leaf "C") (Leaf "D")) )

-- Definir las siguientes funciones:
{-
          o
        /   \
       o     o
      / \   / \
     A  [] B   o
              / \
             C   D
-}

-- a) altura, devuelve la altura de un árbol binario.

maxn :: Int -> Int -> Int
maxn x y | x >= y = x
         | x < y = y

altura :: BTree a -> Int
altura E = 0
altura (Leaf a) = 0
altura (Node l r) = maxn (altura l) (altura r) + 1

-- b) perfecto, determina si un árbol binario es perfecto (un árbol binario es perfecto si cada nodo tiene 0 o 2 hijos
-- y todas las hojas están a la misma distancia desde la raı́z).

perfecto :: BTree a -> Bool
perfecto E = False
perfecto (Leaf a) = True
perfecto (Node l r) = (perfecto l) == (perfecto r) && (altura r) == (altura l)

-- c) inorder, dado un árbol binario, construye una lista con el recorrido inorder del mismo.

inorder :: BTree a -> [a]
inorder E = [] 
inorder (Leaf a) = [a]
inorder (Node l r) = inorder(l) ++ inorder(r)

-- 2) Dada las siguientes representaciones de árboles generales y de árboles binarios (con información en los nodos):

data GTree a = EG | NodeG a [GTree a] deriving Show

data BinTree a = EB | NodeB (BinTree a) a (BinTree a) deriving Show

{- Definir una función g2bt que dado un árbol nos devuelva un árbol binario de la siguiente manera:
   la función g2bt reemplaza cada nodo n del árbol general (NodeG) por un nodo n' del árbol binario (NodeB ), donde
   el hijo izquierdo de n' representa el hijo más izquierdo de n, y el hijo derecho de n' representa al hermano derecho
   de n, si existiese (observar que de esta forma, el hijo derecho de la raı́z es siempre vacı́o).
   
   
   Por ejemplo, sea t: 
       
                    A 
                 / | | \
                B  C D  E
               /|\     / \
              F G H   I   J
             /\       |
            K  L      M    
   
   g2bt t =
         
                  A
                 / 
                B 
               / \
              F   C 
             / \   \
            K   G   D
             \   \   \
              L   H   E
                     /
                    I
                   / \
                  M   J  
-}
{-
 A -> [B C D E] = x:xs
 B -> [F G H] = x:xs
 
     A 
   B  
 F   C
  G    D
   H     E
-}


g2bt :: GTree a -> BinTree a
g2bt EG = EB
g2bt (NodeG a xs) = NodeB (buildTree xs) a EB

buildTree :: [GTree a] -> BinTree a
buildTree [] = EB
buildTree ((NodeG x xs):list) = NodeB (buildTree xs) x (buildTree list)

tree2 = NodeG "A" [
                (NodeG "B" [
                    (NodeG "F" [
                        (NodeG "K" []),
                        (NodeG "L" []),
                        (NodeG "N" [])
                    ]),
                    (NodeG "G" []),
                    (NodeG "H" [])
                ]), 
                (NodeG "C" []), 
                (NodeG "D" []), 
                (NodeG "E" [
                    (NodeG "I" [(NodeG "M" [])] ),
                    (NodeG "J" [])
                ])
            ]


--NodeB (NodeB (NodeB (NodeB EB "K" (NodeB EB "L" (NodeB EB "N" EB))) "F" EB) "B" (NodeB EB "C" (NodeB EB "D" (NodeB EB "E" EB)))) "A" EB

-- 3) Utilizando el tipo de árboles binarios definido en el ejercicio anterior, definir las siguientes funciones: 
{-
   a) dcn, que dado un árbol devuelva la lista de los elementos que se encuentran en el nivel más profundo 
      que contenga la máxima cantidad de elementos posibles. Por ejemplo, sea t:
            1
          /   \
         2     3      [(1-1),2-2,4-3]
          \   / \
           4 5   6

      dcn t = [2, 3], ya que en el primer nivel hay un elemento, en el segundo 2 siendo este número la máxima
      cantidad de elementos posibles para este nivel y en el nivel tercer hay 3 elementos siendo la cantidad máxima 4.
   -}

   --2**altura - cant en el nivel

--dcn t = min (dcn_aux t)


lopeztreeB = NodeB (NodeB EB 2 (NodeB EB 4 EB)) 1 (NodeB (NodeB EB 5 EB) 3 (NodeB EB 6 EB))

dcn_aux :: BinTree a -> Int
dcn_aux (NodeB EB x EB) = 0
dcn_aux (NodeB EB x r) = 0
dcn_aux (NodeB l x EB) = 0
dcn_aux (NodeB l x r) = 1 + (min (dcn_aux l) (dcn_aux r))

dcn_aux_aux :: BinTree a -> Int -> [a]
dcn_aux_aux (NodeB l x r) 0 = [x]
dcn_aux_aux (NodeB l x r) n = (dcn_aux_aux l (n-1)) ++ (dcn_aux_aux r (n-1))

dcn :: BinTree a -> [a]
dcn t = dcn_aux_aux t (dcn_aux t)

{- b) max, que dado un árbol devuelva la profundidad del nivel completo
      más profundo. Por ejemplo, max t = 2   -}

max :: BinTree a -> Int
max = undefined

dcn_aux :: BinTree a -> Int
dcn_aux (NodeB EB x EB) = 0
dcn_aux (NodeB EB x r) = 0
dcn_aux (NodeB l x EB) = 0
dcn_aux (NodeB l x r) = 1 + (min (dcn_aux l) (dcn_aux r))

{- c) podar, que elimine todas las ramas necesarias para transformar
      el árbol en un árbol completo con la máxima altura posible. 
      Por ejemplo,
         podar t = NodeB (NodeB EB 2 EB) 1 (NodeB EB 3 EB)
-}

podar :: BinTree a -> BinTree a
podar = undefined

