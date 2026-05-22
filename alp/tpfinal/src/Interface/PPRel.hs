module Interface.PPRel (renderTable, renderRA) where

import           Core.AST
import           Types.Common (Value(..), Relation(..), valToString)
import           Core.Schema
import qualified Data.Set as S
import qualified Data.Map as M
import           Text.PrettyPrint
import           Data.List (transpose)
import           Prelude                 hiding ( (<>) )

-- | Pretty printer para Valores
pValue :: Value -> Doc
pValue (VInt n) = int n
pValue (VStr s) = text "\"" <> text s <> text "\""

-- | Pretty printer para Condiciones (usado en Seleccion)
pCond :: Condition -> Doc
pCond (Comp a op v) = text a <+> pOp op <+> pValue v
pCond (And c1 c2)   = parens (pCond c1 <+> text "&&" <+> pCond c2)
pCond (Or c1 c2)    = parens (pCond c1 <+> text "||" <+> pCond c2)
pCond (Not c)       = text "!" <> parens (pCond c)

pOp :: Op -> Doc
pOp Eq  = text "=="
pOp NEq = text "!="
pOp Gt  = text ">"
pOp Lt  = text "<"
pOp Ge  = text ">="
pOp Le  = text "<="

-- | Pretty printer para la Expresión de Álgebra Relacional (RAExp)
pRA :: RAExp -> Doc
pRA (Tabla n)       = text n
pRA (Union r1 r2)   = parens (pRA r1 <+> text "∪" <+> pRA r2)
pRA (Diferencia r1 r2) = parens (pRA r1 <+> text "-" <+> pRA r2)
pRA (Interseccion r1 r2) = parens (pRA r1 <+> text "∩" <+> pRA r2)
pRA (Producto r1 r2) = parens (pRA r1 <+> text "×" <+> pRA r2)
pRA (Join r1 r2)    = parens (pRA r1 <+> text "⋈" <+> pRA r2)
pRA (Division r1 r2) = parens (pRA r1 <+> text "÷" <+> pRA r2)
pRA (Seleccion c r) = text "σ" <> brackets (pCond c) <+> parens (pRA r)
pRA (Proyeccion attrs r) = text "π" <> brackets (hsep (punctuate comma (map text attrs))) <+> parens (pRA r)
pRA (Renombre old new r) = text "ρ" <> (brackets (text old <+> text "→" <+> text new)) <+> parens (pRA r)

-- | Renderizador para convertir la expresión en String
renderRA :: RAExp -> String
renderRA = render . pRA

-- | Formatea la relación resultante como una tabla ASCII
renderTable :: Relation -> String
renderTable rel | S.null (tuples rel) = "Resultado: [Tabla Vacía]\nEsquema: " ++ show (attributes rel)
                | otherwise = render $ vcat [rowSep, headerRow, rowSep, body, rowSep]
  where
    attrs = schemaAttrs (attributes rel)
    tups  = S.toList (tuples rel)
    
    -- Calculamos anchos de columna
    allRows = attrs : [ [ valToString (M.findWithDefault (VStr "") a t) | a <- attrs ] | t <- tups ]
    widths  = map (maximum . map length) (transpose allRows)
    
    pad n s = text s <> text (replicate (n - length s) ' ')
    rowSep = text "+" <> (hcat $ punctuate (text "+") [ text (replicate (w + 2) '-') | w <- widths ]) <> text "+"
    
    formatRow row = text "| " <> (hcat $ punctuate (text " | ") (zipWith pad widths row)) <> text " |"
    
    headerRow = formatRow attrs
    body      = vcat [ formatRow [ valToString (M.findWithDefault (VStr "") a t) | a <- attrs ] | t <- tups ]

