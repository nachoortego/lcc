--1)
(|||) :: a -> b -> (a,b)
x ||| y = (x, y)

data BTree a = E | L a | N Int (BTree a) (BTree a)

size :: BTree a -> Int 
size E = 0
size (L _) = 1
size (N n _ _) = n

mapIndex :: (a -> Int -> b) -> BTree a -> BTree b
mapIndex f t = mapi 0 f t
  where
    mapi i f E = E
    mapi i f (L a) = L (f a i)
    mapi i f (N n l r) = let (l', r') = mapi i f l ||| mapi (i + size l) f r 
                         in N n l' r'

fromSlow :: Int -> Int -> Int -> BTree Int 
fromSlow n m k = let t = createBtree m
                 in mapIndex f t 
                   where 
                     createBtree 0 = E
                     createBtree 1 = L 0 
                     createBtree m = let h = div m 2
                                         (l, r) = createBtree h ||| createBtree (m-h)
                                     in N m l r
                     f _ i = n + div i k


--2

type Pesos = Int 
type Hora = [Char]

alarma :: Seq (Pesos, Hora) -> Pesos -> Maybe Hora
alarma s m = let (s',l) = scan f (nth 0 s) (drop 1 s)
                 f_s    = filter (\(p, _) -> p >= m) s'
             in if isEmpty f_s 
                then Nothing 
                else Just (snd (nth 0 f_s))
             where 
               f (p1, h1) (p2, h2) = (p1 + p2, h2)
