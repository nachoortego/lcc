type Name = String 
data DirTree a = Dir Name [DirTree a] | File Name a deriving Show

type Path = [Name]

createDir :: Path -> Name -> DirTree a -> DirTree a
createDir [] newName (Dir name xs)
  | newName `elem` [ n | Dir n _ <- xs ] = Dir name xs
  | otherwise = Dir name (Dir newName [] : xs)

createDir (p:ps) newName (Dir name xs)
  | p == name = Dir name (map (createDir ps newName) xs)
  | otherwise = Dir name xs

createDir _ _ f@(File _ _) = f


content :: Path -> DirTree a -> Maybe a
-- caso: llegamos a un archivo
content [p] (File name x) | p == name = Just x
                          | otherwise = Nothing

-- caso: llegamos a un directorio, seguimos bajando
content (p:ps) (Dir name hijos) | p == name = case buscaHijo (head ps) hijos of
                                                Just h  -> content ps h
                                                Nothing -> Nothing
                                | otherwise = Nothing

-- si la ruta está vacía o no coincide
content _ _ = Nothing


-- auxiliar: busca un hijo por nombre
buscaHijo :: Name -> [DirTree a] -> Maybe (DirTree a)
buscaHijo _ [] = Nothing
buscaHijo n (h:hs) | nodeName h == n = Just h
                   | otherwise       = buscaHijo n hs

-- obtener nombre de un nodo
nodeName :: DirTree a -> Name
nodeName (File n _) = n
nodeName (Dir n _)  = n



mapF :: (a -> b) -> DirTree a -> DirTree b
mapF f (Dir n xs) = Dir n (map (mapF f) xs)
mapF f (File n x) = File n (f x)

files :: DirTree a -> Int
files (Dir _ xs) = sum (map files xs)
files (File _ _) = 1


HI) files (mapF f x) = files x  | x := xs


files (mapF f (Dir n xs))         = <mapF.1>
files (Dir n (map (mapF f) xs))   = <files.1>
sum (map files (map (mapF f) xs)) = <map f (map g xs) = map (f g) xs>
sum (map (files . mapF f) xs)     = <HI> <def map>
sum (map files xs)                = <files.1>
files (Dir n xs)



-- Ej b con mapCollectReduce

mesMax s = if isEmpty s
           then s
           else 
             mapCollectReduce apv red s 
               where
                 apv (m, y, t) = singleton (y, (m, reduce (+) (nth 0 t) (drop 1 t)))
                 red (y, s') = (y, fst (reduce f (nth 0 s') (drop 1 s')))
                 f (m1, t1) (m2, t2) | t1 > t2   = (m1, t1)
                                     | otherwise = (m2, t2)