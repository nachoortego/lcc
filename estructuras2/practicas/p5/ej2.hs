tad Pila (A : Set) where
  import Bool
  empty : Pila A
  push : A -> Pila A -> Pila A
  isEmpty : Pila A -> Bool
  top : Pila A -> A
  pop : Pila A -> Pila A

  push x empty = ⟨x⟩ 
  push x ⟨x1,..,xn⟩ = ⟨x,x1,..,xn⟩
  isEmpty empty = True 
  isEmpty ⟨x1,..,xn⟩ = False
  top ⟨x1,..,xn⟩ = x1
  pop ⟨x1,x2,..,xn⟩ = ⟨x2,..,xn⟩