pairs :: [a] -> [(a, a)]
pairs xs = zip xs (tail xs)

sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x, y ) <- pairs xs ]

list = [2,6,3,7,4,9,5,8]
sList = [1,2,3,4,5]
