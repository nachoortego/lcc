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
    size
    expose: BalT A -> Maybe (BalT A, A, BalT A)



-- No funciona especificando entrada
expose empty = Nothing
expose (join l x r)

-- Se hace por salida

t = maybe (expose t) empty
          Join (p1 (fromJust (exposet)))
               (Just (p2 (fromJust (expose t))))
               (p3 (fromJust (expose t)))

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

