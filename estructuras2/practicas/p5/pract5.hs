-- 4a)
tad PQ (V: Set, K: Ordered Set) where
    import Bool
    {
        vacia: PQ V K
        poner: V -> K -> PQ V K -> PQ V K
    }

    primero: PQ V K -> V 
    sacar: PQ V K -> PQ V K


-- a dos elementos distintos le corresponden prioridades distintas
pover v k q = if prioridad? k q 
              then q
              else poner v k q

poner v k (poner v' k q) = poner v' k q 
poner v k (poner v' k' q) = poner v' k' (poner v k q)

-- Ejemplo:

poner "a" 1 (poner "b" 1 e) = poner "b" 1 e


sacar vacia = vacia
sacar (poner v k vacia) = vacia
sacar (poner v k (poner v' k' q)) = if k > k' 
                                    then poner v' k' (sacar (poner v k q))
                                    else if k' > k 
                                         then poner v k (sacar (poner v' k' q))
                                         else sacar (poner v' k' q)


sacar' k vacia = vacia
sacar' k (poner v k' q) = if k==k'
                          then sacar' k q
                          else poner v k' (sacar' k q)

sacar vacia = vacia
sacar (poner v k q) = sacar' (maxP (poner v k q)) (poner v k q)


-- 5)

tad BalT (A: Ordered Set) where
    import Maybe
    {
        empty: BalT A 
        join: BaltT A -> Maybe A -> BalT A -> BalT A 
    }
    size: BaltT A -> N
    expose: BalT A -> Maybe (BalT A, A, BalT A)



-- No funciona especificando entrada
expose empty = Nothing
expose (join l x r) -- join NO es un constructor

-- Se hace por salida

-- (probablemente mal copiado de clase)
t = Maybe (expose t) empty
          join (p1 (fromJust (expose t)))
               (Just (p2 (fromJust (expose t))))
               (p3 (fromJust (expose t)))

-- (solución válida que se me ocurre)
-- size
size empty = 0
size t = case expose t of
    Nothing -> 0
    Just (l, x, r) -> 1 + size l + size r

-- expose
expose empty = Nothing

t = case expose t of
      Nothing -> empty
      Just (l, x, r) -> join l (Just x) r

-- 6)
HI: (uncurry zip) . unzip ps = ps

Prueba para (a,b):ps

(uncurry zip) . unzip ((a,b):ps)    <def '.'>
(uncurry zip) (unzip ((a,b):ps))    <def unzip.3>
(uncurry zip) (a:xs, b:ys)          <def uncurry>
zip (a:xs) (b:ys)                   <def zip.3>
(a, b) : zip xs ys                  <def uncurry>
(a, b) : (uncurry zip) (xs, ys)     <def unzip.3>
(a, b) : (uncurry zip) (unzip ps)   <def '.'>
(a, b) : (uncurry zip) . unzip ps    <HI>
(a, b) : ps


-- 12)
data Bin a = Nodo (Bin a) a (Bin a) | Hoja

isBST :: (Ord a) => Bin a -> Bool
isBST Hoja = True
isBST (Nodo l a r) = (isHoja l || a >= maxT l) 
                  && (isHoja r || a < minT r)
                  && isBST l && isBST r
                  where
                    isHoja Hoja = True
                    isHoja _ = False
                    maxT (Nodo _ x Hoja) = x
                    maxT (Nodo _ x r) = maxT r
                    minT (Nodo Hoja x _) = x
                    minT (Nodo l x _) = minT l


insert :: (Ord a) => a -> Bin a -> Bin a
insert x Hoja = Nodo Hoja x Hoja
insert x (Nodo l b r)
    | x <= b = Nodo (insert x l) b r
    | otherwise = Nodo l b (insert x r)


Probar que 
isBST t = True => isBST (insert x t) = True

CB:

(HIP) isBST Hoja = True

isBST (insert x Hoja)                        = <def insert.1>
isBST (Nodo Hoja x Hoja)                     = <def isBST.2>
(isHoja Hoja || a >= maxT Hoja) 
&& (isHoja Hoja || a < minT Hoja) 
&& isBST Hoja && isBST Hoja                  = <def isHoja.1> <def || > <def isBST.1>
True && True && True && True                 = <def &&>
True


CI:
(HI1) isBST l => isBST (insert x l)
(HI2) isBST r => isBST (insert x r)

(HIP) isBST (Node l a r) = True           

Desarrollo de (HIP):
  (isHoja l || a >= maxT l)   (HIP1)
  (isHoja r || a < minT r)    (HIP2)
  isBST l                     (HIP3)
  isBST r                     (HIP4)


(TESIS) isBST (insert x (Node l a r)) = True


isBST (insert x (Node l a r)) = 

Análisis por casos

(CASO I) x <= a:
    isBST (Nodo (insert x l) a r)                               = <def insert.2 , (x <= a)>

    (isHoja (insert x l) || a >= maxT (insert x l)) 
    && (isHoja r || a < minT r)
    && isBST (insert x l) && isBST r                            = <def isBST.2>

    (isHoja (insert x l) || a >= maxT (insert x l)) 
    && (isHoja r || a < minT r)
    && isBST (insert x l) && isBST r                            = <Lema 1>
                                                                  <HIP2> <HIP3 -> HI1> <HIP 4>
    
    a >= maxT (insert x l)
    && True && True && True                                     = <{**}>
 
    True                                                        = <def &&>


    Lema 1:
    isHoja (insert x t) = False

    Lema 2: 
    maxT (insert x t) = x   ||   maxT (insert x t) = maxT t
    Se demuestra por induccion estructural

    {*}:
    Por induccion en l:
      (i) l = Hoja                
          maxT (insert x Hoja)    =
          maxT (Nodo Hoja x Hoja) =
          x
      
      (ii) l = Nodo l' a' r'
          Por HIP1 + (isHoja l) = False   =>    a >= maxT l (**)
          Por Lema 2   =>   maxT (insert x l) = x      (C1)
                            maxT (insert x l) = maxT l (C2)

    (C1) => Por (i) x >= a
    (C2) => maxT <= a por (**)


(CASO II) x > a: ANALOGO



-- ej9)

data GTree a = Node a [GTree a]

ponerProfs n (Node x xs) = Node n (map (ponerProfs (n + 1)) xs)

mapG f (Node x xs) = Node (f x) (map (mapG f) xs)

-- a)
altura (Node x xs) = 1 + maximum (map altura xs)

-- b)
maxAGT (Node x xs) = max x (maximum (map maxAGT xs))

                     maximum (x : map maxAGT xs) -- Otra opcion

P(t) : altura t = maxAGT (ponerProfs 1 t)
       
(HI) Para todo t' perteneciente a xs: P(t)  =>  (TESIS) Para todo x: P(Node x xs)


Paso Inductivo:

    (HI) Para todo t' perteneciente a xs: P(t)
    (TESIS) Para todo x: P(Node x xs)

    altura (Node x xs)              = <def altura>
    1 + maximum (map altura xs)     = <HI, def map>
    1 + maximum (map (maxAGT . ponerProfs 1) xs)


    Por otro lado:

    maxAGT (ponerProfs 1 (Node x xs))                            = <ponerProfs.1>
    maxAGT (Node 1 (map (ponerProfs 2) xs))                      = <maxAGT.1>
    max 1 (maximum (map maxAGT (map (ponerProfs 2) xs)))         = <map (f.g) = map f . map g>
    max 1 (maximum (map (maxAGT . ponerProfs 2) xs))             = <lema 1: ponerProfs (n+1) = mapG (+1) . ponerProfs n>
    max 1 (maximum (map (maxAGT . mapG (+1) . ponerProfs 1) xs)) = <lema 2: maxAGT . mapG (+1) = (+1) . maxAGT>
    max 1 (maximum (map ((+1) . maxAGT . ponerProfs 1) xs))      = <map (f.g) = map f . map . g>
    max 1 (maximum (map (+1) (map (maxAGT . ponerProfs 1) xs))) 


Caso xs /= []:
    max 1 (maximum (map (+1) (map (maxAGT . ponerProfs 1) xs)))  = <maximum []>
    max 1 0                                                      = <max.1>
    1                                                            = <antisimetrica>
    1+0                                                          = <maximum.1, map>
    1 + maximum (map (maxAGT . ponerProfs) [])


Caso xs /= []:
    max 1 (maximum (map (+1) (map (maxAGT . ponerProfs 1) xs)))  = <lema 3: xs /= [] => maximum (map (+1) xs) = 1 + maximum xs>
    max 1 (1 + maximum (map (maxAGT . ponerProfs 1) xs))         = < x>=0  =>  max 1 (1+x) , maximum ... >= 0 >
    1 + maximum (map (maxAGT . ponerProfs 1) xs)  


-- 10)

data Tree a = Leaf a | Node a (Tree a) (Tree a)

flatten (Leaf x ) = [x]
flatten (Node x lt rt) = flatten lt ++ [x] ++ flatten rt

mapTree f (Leaf x ) = Leaf (f x )
mapTree f (Node x lt rt) = Node (f x ) (mapTree f lt) (mapTree f rt)

CB:
    (map f . flatten) (Leaf x)     = <def .>
    map f (flatten (Leaf x))       = <def flatten.1>
    map f [x]                      = <def map>
    [f x]
        
    (flatten . mapTree f) (Leaf x) = <def .>
    flatten (mapTree f (Leaf x))   = <def mapTree.1>
    flatten (Leaf (f x))           = <def flatten.1>
    [f x]


CI:
    (HI1) (map f . flatten) l = (flatten . mapTree) f l 
    (HI2) (map f . flatten) r = (flatten . mapTree) f r 

    (TESIS) (map f . flatten) (Node x l r) = (flatten . mapTree f) (Node x l r)

    (map f . flatten) (Node x l r)                                    = <def .>
    map f (flatten (Node x l r))                                      = <def flatten.2>
    map f (flatten l ++ [x] ++ flatten r)                             = <lema: map f (ls ++ rs) = (map f ls) ++ (map f rs)>
                                                                        <def .><def map>
    (map f . flatten) l + [f x] + (map f . flatten) r                 = <HI1><HI2>
    (flatten . mapTree) f l ++ [f x] ++ (flatten . mapTree) f r       


    (flatten . mapTree f) (Node x l r)                                = <def .>
    flatten (mapTree f (Node x l r))                                  = <def mapTree.2>
    flatten (Node (f x ) (mapTree f l) (mapTree f r))                 = <def flatten.2>
    flatten (mapTree f l) ++ [f x] ++ flatten (mapTree f r)           = <def .>
    (flatten . mapTree) f l ++ [f x] ++ (flatten . mapTree) f r       
