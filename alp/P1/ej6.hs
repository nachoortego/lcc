import Parsing
import Control.Applicative hiding (many)

--data HL = (C Char HL) | ()   

data HElem = C Char | I Int deriving Show
type HList = [HElem]

hlist :: Parser HList
hlist = do
  symbol "["
  xs <- sepBy elemP (symbol ",")
  symbol "]"
  return xs

elemP :: Parser HElem
elemP = pChar <|> pInt
  where
    pChar = do
      char '\''
      c <- item
      char '\''
      return (C c)
    pInt = do
      n <- natural
      return (I n)


