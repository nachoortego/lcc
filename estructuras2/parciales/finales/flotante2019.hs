--1)
type Set a = Set.Set a

neightboors :: Graph a -> a -> Set a
neightboors null v = empty
neightboors (addVertex g x) v = neightboors g v
neightboors (addEdge g (x,y)) v = if x == v 
                                  then union (singleton y) (neightboors g v)
                                  else if y == v
                                       then union (singleton x) (neightboors g v)
                                       else neightboors g v

isPath :: Graph a -> a -> a -> Bool
isPath g v w = dfs g v w S.empty

dfs :: Graph a -> a -> a -> Set a -> Bool
dfs g v w visited
  | v == w = True
  | S.member v visited = False
  | otherwise = any (\u -> dfs g u w (S.insert v visited)) (S.toList (neightboors g v))


data Bit = Zero | One deriving Eq
type Vertex = Int
type Graph = [[Bit]]

neighbours :: Graph -> Vertex -> S.Set Vertex
neighbours [] _ = S.empty
neighbours g v  = collect 0 (g !! v)
  where
    collect _ [] = S.empty
    collect i (x:xs)
      | x == One  = S.insert i (collect (i+1) xs)
      | otherwise = collect (i+1) xs

delEdge :: Graph -> (Vertex, Vertex) -> Graph
delEdge [] _        = []
delEdge g (v, w)    = delE 0 0 g (v, w)

delE _ [] _          = []
delE i (g:gs) (v, w) = (delE' i 0 g (v, w)) : (delE (i+1) 0 gs (v, w))
                           where 
                             delE' _ _ [] _             = []
                             delE' i' j (x:xs) (v', w') | i' == v' && j == w = Zero : (delE' i' (j+1) xs (v, w))
                                                        | otherwise          = x : (delE' i' (j+1) xs (v, w))

delEdge g (v,w) = [ x | ]

inverso :: Graph -> Graph
inverso g = [[toggle bit | bit <- row] | row <- g]
  where
    toggle Zero = One
    toggle One = Zero



ventas : Seq Float -> (Seq Float, Float)
ventas s = let (sums, u) = scan (+) 0 s
               s' = append (singleton 0) (tabulate (\i -> (nth (i+1) sums) / (i+1)) (length sums - 1))
               s_z = tabulate (\i -> (nth i s, nth i s')) (length s)
               s'' = filter (\(x,y) -> x > y ) s_z
               min_c = mapreduce min 0 (/(x,y) -> x) s''
           in 
            if length s'' == 0 
               then (s'', -1) 
               else (s'', min_c)


data Cadena = E | L Char | N Cadena Cadena deriving Show

(|||) :: a -> b -> (a,b)
x ||| y = (x, y)

palindromo :: Cadena -> Bool
palindromo c = eq c (inv c)

inv :: Cadena -> Cadena
inv E = E 
inv (L a) = (L a)
inv (N l r) = let (l', r') = inv l ||| inv r 
              in N r' l'

eq :: Cadena -> Cadena -> Bool 
eq E E = True
eq (L a) (L b) = a == b
eq (N l1 r1) (N l2 r2) = let (l', r') = eq l1 l2 ||| eq r1 r2
                         in l' && r'
eq _ _ = False
        
c1 = N (N (L 'a') (L 'b')) (N (L 'b') (L 'a'))

c2 = N (N (L 'r') (L 'a')) (N (L 'd') (N (L 'a') (L 'r')))

c2' = N (N (L 'r') (L 'a')) (N (N (L 'd') (L 'a')) (L 'r') )

c3 = N (N (L 'h') (L 'o')) (N (L 'l') (L 'a'))


crear :: Int -> (Int -> Char) -> Cadena 
crear n f = N (N (L "*") (crear' n 0 f)) (L "*")

crear' 0 _ _ = E
crear' 1 i f = L (f i)
crear' n i f = let h = div n 2
                   (l, r) = crear' h i f ||| crear' (n - h) (i + h) f 
               in N l r


















