tad Lista (A : Set) where
  import Bool
  nil   : Lista A
  cons  : A -> Lista A -> Lista A
  null  : Lista A -> Bool
  head  : Lista A -> A
  tail  : Lista A -> Lista A


--a)
null nil         = True
null (cons x xs) = False
head (cons x xs) = x 
tail (cons x xs) = xs

--b)
instance Lista[] where
  nil         = ⟨⟩ 
  cons x ⟨x1,..,xn⟩  = ⟨x,x1,..,xn⟩
  null ⟨⟩            = True
  null ⟨x1,..,xn⟩    = False
  head ⟨x1,..,xn⟩    = x1
  tail ⟨x1,x2,..,xn⟩ = ⟨x2,..,xn⟩ 

--c)
inL : List A -> A -> Bool
inL nil x         = False
inL (cons y ys) x = if y == x then True else inL ys x

--d)
delE : List A -> A -> List A
delE nil x = nil
delE (cons y ys) x = if y == x then delE ys x else cons y (delE ys x)