module Huffman where

import Data.Map as DM (Map, fromList, toList, insertWith, findWithDefault)
import Heap

{-
Integrantes grupo:
- Ignacio Ortego
- Baltazar Lynn Bosio
- Agustín Lopez
-}

-- Bits y códigos

data Bit = Zero | One deriving (Eq, Show)

type Code = [Bit]

-- Árbol de codificación

data HTree = Leaf Char Int
           | Node HTree HTree Int
           deriving Show

weight :: HTree -> Int
weight (Leaf _ w)   = w
weight (Node _ _ w) = w

-- Diccionarios de frecuencias y códigos

type FreqMap = Map Char Int

type CodeMap = Map Char Code


-- Ejercicio 1

instance Eq HTree where 
    (==) (Leaf _ i) (Leaf _ j) = i == j
    (==) (Node _ _ i) (Leaf _ j) = i == j
    (==) (Leaf _ i) (Node _ _ j) = i == j
    (==) (Node _ _ i) (Node _ _ j) = i == j

instance Ord HTree where 
    (<=) (Leaf _ i) (Leaf _ j) = i <= j
    (<=) (Node _ _ i) (Leaf _ j) = i <= j
    (<=) (Leaf _ i) (Node _ _ j) = i <= j
    (<=) (Node _ _ i) (Node _ _ j) = i <= j

-- Ejercicio 2

buildFreqMap :: String -> FreqMap
buildFreqMap [] = fromList([])
buildFreqMap (x:xs) = insertWith (+) x 1 (buildFreqMap xs)

-- Ejercicio 3

buildHTree :: FreqMap -> HTree
buildHTree f = findMin (buildHTree' (makeHeap f))

buildHTree' :: Heap HTree -> Heap HTree
buildHTree' heap | isEmpty heap             = empty
                 | isEmpty (deleteMin heap) = heap
                 | otherwise                = buildHTree' (insert (Node l r (weight l + weight r)) (deleteMin (deleteMin heap)))
                                                where l = findMin heap
                                                      r = findMin (deleteMin heap)

makeHeap :: FreqMap -> Heap HTree
makeHeap fmap = if (toList fmap == []) 
                    then empty 
                    else insert (Leaf c i) (makeHeap (fromList xs))
                        where 
                            ((c, i):xs) = toList fmap 

-- Ejercicio 4

buildCodeMap :: HTree -> CodeMap
buildCodeMap a = fromList (buildCodeMap' a [])

buildCodeMap' :: HTree -> Code -> [(Char, Code)]
buildCodeMap' (Leaf c i) code = [(c, code)]
buildCodeMap' (Node l r i) code = (buildCodeMap' l (code ++ [Zero])) ++ (buildCodeMap' r (code ++ [One]))  

-- Ejercicio 5

encode :: CodeMap -> String -> Code
encode _ [] = []
encode codemap (x:xs)  = (findWithDefault [] x codemap) ++ (encode codemap xs)

-- Ejercicio 6

decode' :: HTree -> Code -> (Char, Code)
decode' (Leaf c i) xs = (c, xs) 
decode' (Node l r i) (Zero:xs) = decode' l xs
decode' (Node l r i) (One:xs) = decode' r xs 

decode :: HTree -> Code -> String
decode t [] = []
decode t code = c : decode t xs 
            where (c, xs) = decode' t code

-- Ejercicio 7

engFM :: FreqMap
engFM = fromList [
    ('a', 691),
    ('b', 126),
    ('c', 235),
    ('d', 360),
    ('e', 1074),
    ('f', 188),
    ('g', 170),
    ('h', 515),
    ('i', 589),
    ('j', 13),
    ('k', 65),
    ('l', 340),
    ('m', 203),
    ('n', 571),
    ('o', 635),
    ('p', 163),
    ('q', 8),
    ('r', 506),
    ('s', 535),
    ('t', 766),
    ('u', 233),
    ('v', 83),
    ('w', 200),
    ('x', 13),
    ('y', 167),
    ('z', 6),
    (' ', 1370),
    (',', 84),
    ('.', 89)
    ]


-- 1) Árbol de codificación para engFM
tree = buildHTree engFM

-- 2) Strings ejemplos 
f1 = "i guess you either die a hero or you live long enough to see yourself become the villain."
f2 = "actually, seth, muhammad is the most commonly used name on earth."
f3 = "we have known each other many years, but this is the first time you came to me for counsel, for help. i cant remember the last time that you invited me to your house for a cup of coffee, even though my wife is godmother to your only child. but lets be frank here, you never wanted my friendship. and uh, you were afraid to be in my debt."
f4 = "with great power comes great responsibility"
f5 = "let me tell you what i do know. every day i come by to pick you up, and we go out drinkin or whatever and we have a few laughs. But you know what the best part of my day is. the ten seconds before i knock on the door cause i let myself think i might get there, and youd be gone. id knock on the door and you wouldnt be there. you just left."
f6 = "theres no time i feel the same, going around i feel so empty, and this time i feel the rain, going around i feel so empty"
f7 = "skinhead, deadhead everybody gone bad situation aggravation everybody, allegation in the suite on the news everybody, dog food bang bang, shock dead everybody is gone mad all i wanna say is that they dont really care about us"
f8 = "fear is the path to the dark side. fear leads to anger, anger leads to hate, hate leads to suffering."
f9 = "everybody wants to know what id do if i didnt win. i guess well never know."
f10 = "good morning, and in case i dont see ya, good afternoon, good evening, and good night"

fList = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10]

generateLengths :: [[Char]] -> [(Int, Int)]
generateLengths [] = []
generateLengths (f:fs) = aux f : (generateLengths fs)
  where
    aux f = let f_code = encode (buildCodeMap tree) f
                       in (length f_code, length f * 5)

results = [(370,445),(285,325),(1439,1685),(182,215),(1465,1700),(496,605),(969,1125),(414,505),(330,375),(362,425)]

charLengthDiff :: [(Int, Int)] -> [Float]
charLengthDiff xs = [fromIntegral a / fromIntegral b * 100.0 | (a, b) <- xs]

promedio :: [(Int, Int)] -> Float
promedio xs = sum resultados / fromIntegral (length resultados)
  where resultados = charLengthDiff xs

diferencia = promedio results

{-
Podemos ver que los strings codificados con árboles de Huffman son más livianos 
que los codificados por longitud fija. En promedio, los árboles de Huffman ocupan
un 85.03% de lo que ocupan los codificados por 5 bits cada caracter, siendo esta
una buena optimización.
-}