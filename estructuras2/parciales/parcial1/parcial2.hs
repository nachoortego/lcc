type Interval = (Int, Int)
data ITree = E | N ITree Interval ITree deriving Show

right :: ITree -> Int
right (N _ (_, b) E) = b
right (N _ _ r) = right r

left :: ITree -> Int
left (N _ (a, _) E) = a
left (N l _ _) = left l

checkIT :: ITree -> Bool
checkIT E = True
checkIT (N l (a, b) r) = a <= b && checkRight r && checkLeft l && checkIT l && checkIT r
                        where
                          checkRight E = True
                          checkRight r = right r > b + 1
                          checkLeft E = True
                          checkLeft l = left l < a - 1

-- WcheckIT (0) = c0
-- WcheckIT (h) = c1 + WcheckRight(h-1) + WcheckLeft(h-1) + WcheckIT(h-1) + WcheckIT(h-1)
-- WheckRight (0) = c2
-- WheckRight (h) = Wright(h-1) + c3
-- Wright (0) = c4
-- Wright (h) = Wright(h-1) 

-- O(h)

tree = N (N E (1, 2) E) (4, 5) (N E (7, 8) (N E (10,11) E))

splitMax :: ITree -> (Interval, ITree)
splitMax (N l i E) = (i, l)
splitMax (N l i r) = let (maxI, newR) = splitMax r
                     in (maxI, N l i newR)

merge :: ITree -> ITree -> ITree
merge E r = r 
merge l r = let (maxI, newL) = splitMax l
            in N newL maxI r

delElem :: ITree -> Int -> ITree
delElem E _ = E 
delElem (N l (a,b) r) i | i < a = N (delElem l i) (a, b) r
                        | i > b = N l (a, b) (delElem r i)
                        | i == a && i == b = merge l r
                        | i == a = N l (a+1, b) r
                        | i == b = N l (a, b-1) r
                        | otherwise = N l (a, i-1) (N E (i+1, b) r)
