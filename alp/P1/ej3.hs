import Parsing
import Control.Applicative hiding (many)

paren :: Parser a -> Parser a
paren p = p <|> do symbol "("
                   t <- p
                   symbol ")"
                   return t