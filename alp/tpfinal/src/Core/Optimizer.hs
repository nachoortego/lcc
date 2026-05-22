module Core.Optimizer (optimize) where

import Core.AST
import Types.Common (attributes, Value(..))
import Types.RelContext (Resource(..))
import Types.Monads
import Core.Schema
import qualified Data.Set as S

optimize :: RAExp -> StateErrorTrace RAExp
optimize e = do
  let eSimple = simplifyCascades e
  ePushed <- pushSelections eSimple
  if e == ePushed
  then return ePushed
  else optimize ePushed

simplifyCascades :: RAExp -> RAExp
simplifyCascades (Proyeccion l1 (Proyeccion _ r)) = simplifyCascades (Proyeccion l1 r)

simplifyCascades (Seleccion c1 (Seleccion c2 r)) = simplifyCascades (Seleccion (And c1 c2) r)

simplifyCascades (Seleccion (Or p (And q s)) r) = simplifyCascades (Seleccion (And (Or p q) (Or p s)) r)

simplifyCascades (Proyeccion l r)     = Proyeccion l (simplifyCascades r)
simplifyCascades (Seleccion c r)      = Seleccion c (simplifyCascades r)
simplifyCascades (Renombre o n r)     = Renombre o n (simplifyCascades r)
simplifyCascades (Union r1 r2)        = Union (simplifyCascades r1) (simplifyCascades r2)
simplifyCascades (Diferencia r1 r2)   = Diferencia (simplifyCascades r1) (simplifyCascades r2)
simplifyCascades (Producto r1 r2)     = Producto (simplifyCascades r1) (simplifyCascades r2)
simplifyCascades (Interseccion r1 r2) = Interseccion (simplifyCascades r1) (simplifyCascades r2)
simplifyCascades (Join r1 r2)         = Join (simplifyCascades r1) (simplifyCascades r2)
simplifyCascades (Division r1 r2)     = Division (simplifyCascades r1) (simplifyCascades r2)

simplifyCascades x = x


pushSelections :: RAExp -> StateErrorTrace RAExp
pushSelections (Seleccion c (Producto r1 r2)) = do
  s1 <- getSchema r1
  s2 <- getSchema r2
  let attrsC = getAttrsCond c

  -- Verificamos dónde están las columnas de la condición
  let inR1 = all (\a -> hasAttr a s1) attrsC
  let inR2 = all (\a -> hasAttr a s2) attrsC

  case (inR1, inR2) of
    (True, _) -> do
      -- Toda la condición pertenece a R1: bajamos a la izquierda
      r1Opt <- pushSelections (Seleccion c r1)
      r2Opt <- pushSelections r2
      return (Producto r1Opt r2Opt)

    (_, True) -> do
      -- Toda la condición pertenece a R2: bajamos a la derecha
      r1Opt <- pushSelections r1
      r2Opt <- pushSelections (Seleccion c r2)
      return (Producto r1Opt r2Opt)

    _ -> do
      -- La condición mezcla columnas de ambos, se queda arriba
      r1Opt <- pushSelections r1
      r2Opt <- pushSelections r2
      return (Seleccion c (Producto r1Opt r2Opt))

pushSelections (Seleccion c (Union r1 r2)) = do
  r1Opt <- pushSelections (Seleccion c r1)
  r2Opt <- pushSelections (Seleccion c r2)
  return (Union r1Opt r2Opt)

pushSelections (Proyeccion l r) = Proyeccion l <$> pushSelections r
pushSelections (Seleccion c r)  = Seleccion c <$> pushSelections r
pushSelections (Renombre o n r) = Renombre o n <$> pushSelections r
pushSelections (Union r1 r2)    = Union <$> pushSelections r1 <*> pushSelections r2
pushSelections (Diferencia r1 r2) = Diferencia <$> pushSelections r1 <*> pushSelections r2
pushSelections (Producto r1 r2) = Producto <$> pushSelections r1 <*> pushSelections r2
pushSelections (Interseccion r1 r2) = Interseccion <$> pushSelections r1 <*> pushSelections r2
pushSelections (Join r1 r2)     = Join <$> pushSelections r1 <*> pushSelections r2
pushSelections (Division r1 r2) = Division <$> pushSelections r1 <*> pushSelections r2
pushSelections (Tabla n)        = return (Tabla n)


getSchema :: RAExp -> StateErrorTrace Schema
getSchema (Tabla n) = do
  res <- lookfor n
  case res of
    Table rel -> return (attributes rel)
    View viewExpr -> getSchema viewExpr

getSchema (Proyeccion attrs _) = return (mkSchema attrs)
getSchema (Seleccion _ r)      = getSchema r
getSchema (Renombre v n r)     = mapSchema (\a -> if a == v then n else a) <$> getSchema r

getSchema (Union r1 _)         = getSchema r1
getSchema (Diferencia r1 _)    = getSchema r1
getSchema (Interseccion r1 _)  = getSchema r1

getSchema (Producto r1 r2) = do
  s1 <- getSchema r1
  s2 <- getSchema r2
  let fixKey = avoidClash (attrSet s1)
      s2Fixed = mapSchema fixKey s2
      newSchema = combineSchemas s1 s2Fixed
  return newSchema

getSchema (Join r1 r2) = do
  s1 <- getSchema r1
  s2 <- getSchema r2
  return (combineSchemas s1 (mkSchema [ a | a <- schemaAttrs s2, not (hasAttr a s1) ]))

getSchema (Division r1 r2) = do
  s1 <- getSchema r1
  s2 <- getSchema r2
  return (mkSchema [ a | a <- schemaAttrs s1, not (hasAttr a s2) ])

getAttrsCond :: Condition -> [String]
getAttrsCond (Comp a _ (VStr _)) = [a]
getAttrsCond (Comp a _ (VInt _)) = [a]
getAttrsCond (And c1 c2) = getAttrsCond c1 ++ getAttrsCond c2
getAttrsCond (Or c1 c2)  = getAttrsCond c1 ++ getAttrsCond c2
getAttrsCond (Not c)     = getAttrsCond c

avoidClash :: S.Set String -> String -> String
avoidClash avoid k
  | S.member k avoid = ac (2 :: Int)
  | otherwise        = k
  where ac i = let candidate = k ++ "_" ++ show i
               in if S.member candidate avoid then ac (i + 1) else candidate