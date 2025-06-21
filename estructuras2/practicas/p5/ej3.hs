tad Conjunto (A : Set) where
  import Bool
  vacio        : Conjunto A
  insertar     : A -> Conjunto A -> Conjunto A
  borrar       : A -> Conjunto A -> Conjunto A
  esVacio      : Conjunto A -> Bool
  union        : Conjunto A -> Conjunto A -> Conjunto A
  interseccion : Conjunto A -> Conjunto A -> Conjunto A


insertar x (insertar x c) = insertar x c
insertar x (insertar y c) = insertar y (insertar x c)

borrar x (insertar y c) = if x == y then c else insertar y (borrar x c)

esVacio vacio = True 
esVacio (insertar x c) = False 

union vacio c = c
union c vacio = c
union (insertar x c) d = insertar x (union c d)

interseccion vacio c = vacio 
interseccion c vacio = vacio
interseccion (insertar x c) d = if elem x d 
                                then insertar x (interseccion c d)
                                else (interseccion c d)

resta vacio c = vacio
resta (insertar x c) d = if elem x d 
                         then resta c d 
                         else insertar x (resta c d)


-- aux
elem : Conjunto A -> A -> Bool
elem c vacio = false
elem x (insertar y c) = if x == y then true else elem c x


-- funcion choose

choose : Conjunto A -> A
choose (insertar x c) = x

{-
 No es correcta ya que los conjuntos no tienen orden e introduce una 
 dependencia del orden de inserción.
 Si el orden no importa, entonces no podés decir cuál es el que se va a "elegir".
-}