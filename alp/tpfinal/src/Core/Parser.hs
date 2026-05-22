module Core.Parser (parseRA, parseViewDef) where

import Text.Parsec
import Text.Parsec.String (Parser)
import qualified Text.Parsec.Expr as E
import qualified Text.Parsec.Token as T
import Text.Parsec.Language (emptyDef)
import Data.Functor.Identity (Identity)

import Core.AST
import Types.Common

raDef :: T.LanguageDef st
raDef = emptyDef
    { T.commentStart    = "/*"
    , T.commentEnd      = "*/"
    , T.commentLine     = "--"
    , T.identStart      = letter
    , T.identLetter     = alphaNum <|> char '_'
    , T.reservedNames   = [ "PROY", "SEL", "REN"
                          , "UNION", "INTER", "DIFF"
                          , "JOIN", "PROD", "DIV"
                          , "VIEW", "AS"
                          , "AND", "OR", "NOT"
                          , "true", "false"
                          ]
    , T.reservedOpNames = [ "==", "!=", ">", "<", ">=", "<=", "&&", "||", "!", "->" ]
    }

lexer :: T.TokenParser st
lexer = T.makeTokenParser raDef

-- Helpers
identifier :: Parser String
identifier = T.identifier lexer

reserved :: String -> Parser ()
reserved   = T.reserved lexer

reservedOp :: String -> Parser ()
reservedOp = T.reservedOp lexer

parens :: Parser a -> Parser a
parens     = T.parens lexer

brackets :: Parser a -> Parser a
brackets   = T.brackets lexer

commaSep :: Parser a -> Parser [a]
commaSep   = T.commaSep lexer

integer :: Parser Integer
integer    = T.integer lexer

stringLit :: Parser String
stringLit  = T.stringLiteral lexer

whiteSpace :: Parser ()
whiteSpace = T.whiteSpace lexer


-- Valores y Condiciones

valueP :: Parser Value
valueP = (VInt . fromIntegral <$> integer)
  <|> (VStr <$> stringLit)

condExpr :: Parser Condition
condExpr = E.buildExpressionParser condTable condTerm

condTable :: [[E.Operator String () Identity Condition]]
condTable = 
  [ [ E.Prefix (reservedOp "!" >> return Not) ]
  , [ E.Infix  (reservedOp "&&" >> return And) E.AssocLeft ]
  , [ E.Infix  (reservedOp "||" >> return Or)  E.AssocLeft ]
  ]

condTerm :: Parser Condition
condTerm = parens condExpr
       <|> try comparisonP

comparisonP :: Parser Condition
comparisonP = do
  col <- identifier
  op  <- opP
  val <- valueP
  return (Comp col op val)

opP :: Parser Op
opP =  (reservedOp "==" >> return Eq)
  <|> (reservedOp "!=" >> return NEq)
  <|> (reservedOp ">=" >> return Ge)
  <|> (reservedOp "<=" >> return Le)
  <|> (reservedOp ">"  >> return Gt)
  <|> (reservedOp "<"  >> return Lt)


-- Expresiones 

raExpr :: Parser RAExp
raExpr = E.buildExpressionParser table term

table :: [[E.Operator String () Identity RAExp]]
table = 
  [ [ E.Infix (reserved "PROD"  >> return Producto)     E.AssocLeft
    , E.Infix (reserved "JOIN"  >> return Join)         E.AssocLeft
    , E.Infix (reserved "DIV"   >> return Division)     E.AssocLeft
    ]
  , [ E.Infix (reserved "UNION" >> return Union)        E.AssocLeft
    , E.Infix (reserved "INTER" >> return Interseccion) E.AssocLeft
    , E.Infix (reserved "DIFF"  >> return Diferencia)   E.AssocLeft
    ]
  ]

term :: Parser RAExp
term = parens raExpr
  <|> proyeccionP
  <|> seleccionP
  <|> renombreP
  <|> tablaP

tablaP :: Parser RAExp
tablaP = Tabla <$> identifier

-- PROY [col1, col2] (Exp)
proyeccionP :: Parser RAExp
proyeccionP = do
  reserved "PROY"
  attrs <- brackets (commaSep identifier)
  sub   <- parens raExpr
  return (Proyeccion attrs sub)

-- SEL [condicion] (Exp)
seleccionP :: Parser RAExp
seleccionP = do
  reserved "SEL"
  cond <- brackets condExpr
  sub  <- parens raExpr
  return (Seleccion cond sub)

-- REN [old -> new] (Exp)
renombreP :: Parser RAExp
renombreP = do
  reserved "REN"
  (old, new) <- brackets $ do
      o <- identifier
      reservedOp "->"
      n <- identifier
      return (o, n)
  sub <- parens raExpr
  return (Renombre old new sub)


-- Vistas 

-- VIEW nombre AS (Exp)
viewDefP :: Parser (String, RAExp)
viewDefP = do
  reserved "VIEW"
  name <- identifier
  reserved "AS"
  viewExpr <- parens raExpr
  return (name, viewExpr)

parseViewDef :: String -> Either ParseError (String, RAExp)
parseViewDef input = parse (whiteSpace >> viewDefP <* eof) "" input


-- Funcion principal
parseRA :: String -> Either ParseError RAExp
parseRA input = parse (whiteSpace >> raExpr <* eof) "" input