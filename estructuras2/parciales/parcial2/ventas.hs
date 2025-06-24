{-
2.Debido a las bajas en la venta de celulares, una empresa decide hacer un remate de los mismos 
por internet. Las personas tendran dos horas para hacer una unica oferta sobre el precio de 
los mismos, pero solo podran terminar su compra aquellas ofertas que superen al promedio de 
las ofertas anteriores y superen cierto valor X.

Definir  una  funcion ventas: Seq Float → (Seq  Float,Float)  
que  dada  una  secuencia  cronologica  con  los  precios ofertados, devuelva una secuencia con 
los precios correspondientes a personas que pudieron terminar la compra junto con la menor oferta 
terminada en compra o -1 si ninguna oferta termino en compra.

Definir ventas utilizando la funcion scan, con profundidad de orden O(lg(n)), donde n es el 
largo de la secuencia. Calcular costos.
-}

ventas : Seq Float -> (Seq Float, Float)  

[ 2, 3, 4, 2, 6] -> ([2, 3, 4, 6],2)

s'    = [ 0, 2, 2.5, 3 , 11/3  , 17/5 ]
s_red = [ 2, 5, 9  , 11, 17 ]

ventas s = let (s_red, r) = scan (+) 0 s
               s' = append (singleton 0) (tabulate (\i -> (nth (i+1) s_red) / (i+1)) (length s_red - 1))
               s_z = tabulate (\i -> (nth i s, nth i s')) (length s)
               comp = filter (\(c, p) -> c > p) s_z 
               min_c = mapreduce min 0 (\(c, p) -> c) comp'
           in
            (comp', min_c)