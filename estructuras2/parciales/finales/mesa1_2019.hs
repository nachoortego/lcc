--1) 

type Art = Char

aumentos : Seq (Art, Int) -> (Art, Int)

aumentos s = let s'         = map (\(a, p) -> (a, p, 0, p)) s
                 (s_red, r) = scan f (nth 0 s') (drop s' 1)
                 s_res      = append s_red (singleton r)
             in 
                 reduce mayor ("?", 0) (map (\(_, m) -> m) s_res)
             where
                 -- f es asociativa: combina segmentos con su info acumulada
                 f (a1, p1, c1, last1) (a2, p2, c2, last2)
                   | a1 == a2  = (a1, p1, c1 + (if last1 < p2 then 1 else 0), last2)
                   | otherwise = (a2, p2, c2, last2)  -- reinicia para nuevo artículo

                 mayor (_, c1) (_, c2) = if c1 >= c2 then (_, c1) else (_, c2)


type Name = String 
type Path = [String]
data DirTree a = Dir Name [DirTree a] | File Name a

getName (Dir name _) = name 
getName (File name a) = name

names :: [DirTree a] -> [Name]
names [] = []
names (x:xs) = getName x : names xs


mkDir :: Path -> Name -> DirTree a -> DirTree a
mkDir p n d = mkdir ("/" : p) n d

mkdir :: Path -> Name -> DirTree a -> DirTree a
mkdir [] n (Dir dname dtree) = if elem n (names dtree)
                               then Dir dname dtree
                               else Dir dname (Dir n [] : dtree)

mkdir (p:ps) n (Dir dname dtree) = Dir dname (map actualizar dtree)
                                     where
                                       actualizar sub@(Dir name subdirs)
                                         | name == p = mkdir ps n sub
                                         | otherwise = sub
                                       actualizar file@(File _ _) = file 


ls :: Path -> DirTree a -> [Name]
ls p t = ls' ("/" : p) t

ls' [] (Dir dname dtree)     = names dtree

ls' (p:ps) (Dir dname dtree) | p == "/" = ls' ps (Dir "/" dtree)
                             | concatMap f dtree 
                                 where 
                                   f sub@(Dir name subdirs) | name == p = ls' ps sub 
                                                            | otherwise = []
                                   f _ = []



elem x [] = False
elem x (y:ys) = x == y || elem x ys 

concatMap f = concat . map f 

allNames (Dir n xs) = n : concatMap allNames xs
allNames (File n x) = [n]

isName y (Dir n xs) = y == n || or (map (isName y) xs)
isName y (File n x) = y == n


LEMA) elem x (concat css) = or (map (elem x) xss)


P(t) === elem n (allNames t) = isName t 


CI) 

HI) elem y (allNames x) = isName y x       <x perteneciente a xs>

TESIS) elem y (allNames (Dir n xs)) = isName y (Dir n xs)


elem y (allNames (Dir n xs))                  = <allNames.1>
elem y (n : concatMap allNames xs)            = <concatMap.1>
elem y (n : concat (map allNames xs))         = <elem.2>
y == n || elem y (concat (map allNames xs))   = <LEMA 
                                                 (css = map allNames xs)
                                                 (xss = allNames xs)>
y == n || or (map (elem y) (allNames xs))     = <HI>
y == n || or (map (isName y) xs)              = <isName.1>
isName y (Dir n xs)







CB)

elem y (allNames (File n x)) = <def allNames.2>
elem y [n]                   = <elem.2>
y == n || elem y []          = <elem.1>
y == n || False              = < || >
y == n                       = <isName.2>
isName y (File n x)
