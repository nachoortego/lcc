module Core.Eval (module Core.Eval) where

import qualified Data.Set as S
import qualified Data.Map as M
import qualified Data.Sequence as Seq
import qualified Data.Foldable as Foldable
import Control.Monad (filterM)
import Core.Schema
import Core.AST
import Types.Common
import Types.Monads (StateErrorTrace, lookfor, throw, addTrace, getDepth, putDepth, maxViewDepth)
import Types.RelContext (Resource(..))

eval :: RAExp -> StateErrorTrace Relation

-- 1. Caso Base: Una variable (nombre de tabla o vista)
-- Si es Table: devuelve la relación. Si es View: evalua la expresión con límite de profundidad.
eval (Tabla nombre) = do
  res <- lookfor nombre
  case res of
    Table rel -> return rel
    View viewExpr -> do
      d <- getDepth
      if d >= maxViewDepth
        then throw (CustomError "Profundidad de vistas excedida (posible referencia circular)")
        else do
          putDepth (d + 1)
          result <- eval viewExpr
          putDepth d
          return result

-- 2. Unión (R U S)
-- Requiere mismo esquema.
eval (Union r1 r2) = do rel1 <- eval r1
                        rel2 <- eval r2
                        addTrace "Calculando unión..."
                        if attributes rel1 == attributes rel2 
                        then return (Rel (attributes rel1) (S.union (tuples rel1) (tuples rel2)))
                        else throw IncompatibleSchemes

-- 3. Diferencia (R - S)
-- Requiere mismo esquema.
eval (Diferencia r1 r2) = do rel1 <- eval r1 
                             rel2 <- eval r2 
                             addTrace "Calculando diferencia..."
                             if attributes rel1 == attributes rel2
                             then return (Rel (attributes rel1) (S.difference (tuples rel1) (tuples rel2)))
                             else throw IncompatibleSchemes

-- 4. Producto Cartesiano (R x S)
-- Combina todas las filas de R con todas las de S.
-- El esquema resultante es la concatenación de atributos.
eval (Producto r1 r2) = do
  rel1 <- eval r1
  rel2 <- eval r2
  addTrace "Calculando producto cartesiano..."
  let sch1 = attributes rel1
      sch2 = attributes rel2
      fixKey = avoidClash (S.union (attrSet sch1) (attrSet sch2))
      sch2Fixed = mapSchema fixKey sch2 -- Aplica avoidClash parcialmente si hay atributos repetidos
      tups2Fixed = S.map (M.mapKeys fixKey) (tuples rel2)
      newSchema = combineSchemas sch1 sch2Fixed
      newTups = S.fromList [ M.union t1 t2 | t1 <- S.toList (tuples rel1), t2 <- S.toList tups2Fixed ]
  return (Rel newSchema newTups)


-- 5. Selección (σ[cond] (R))
-- Filtra las tuplas que cumplen el predicado. Mismo esquema.
eval (Seleccion cond r) = do rel <- eval r 
                             addTrace "Filtrando filas (Selección)..."
                             newTupsList <- filterM (evalCond cond) (S.toList (tuples rel))
                             return (Rel (attributes rel) (S.fromList newTupsList))

-- 6. Proyección (π[attrs] (R))
-- Selecciona un subconjunto de columnas.
eval (Proyeccion attrs r) = do rel <- eval r 
                               addTrace $ "Aplicando proyección sobre " ++ show attrs
                               let faltantes = filter (\a -> not (hasAttr a (attributes rel))) attrs
                               case faltantes of
                                 (f : _) -> throw (UndefColumn f)
                                 []      -> do let sch = mkSchema attrs
                                                   newTups = S.map (\t -> M.restrictKeys t (attrSet sch)) (tuples rel)
                                               return (Rel sch newTups)
                                 
-- 7. Renombre (ρ[old → new] (R))
-- Cambia el nombre de un atributo en el esquema y actualiza las claves en todas las tuplas.
eval (Renombre nOld nNew r) = do rel <- eval r
                                 addTrace $ "Aplicando renombre de " ++ nOld ++ " a " ++ nNew
                                 let sch = attributes rel
                                 if not (hasAttr nOld sch)
                                 then throw (UndefColumn nOld)
                                 else if hasAttr nNew sch
                                      then throw (CustomError $ "La columna " ++ nNew ++ " ya existe en la relación")
                                      else do 
                                              let replace x = if x == nOld then nNew else x
                                                  newAttrs = mapSchema replace sch
                                                  newTups = S.map (M.mapKeys replace) (tuples rel)
                                              return (Rel newAttrs newTups) 

-- 8. Intersección (R ∩ S)
-- Retorna las tuplas que están en ambas relaciones. Mismo esquema.
eval (Interseccion r1 r2) = do rel1 <- eval r1
                               rel2 <- eval r2
                               addTrace "Calculando interseccion..."
                               if attributes rel1 == attributes rel2 
                               then return (Rel (attributes rel1) (S.intersection (tuples rel1) (tuples rel2)))
                               else throw IncompatibleSchemes

-- 9. Join Natural (R ⋈ S)
-- Une filas donde los valores de los atributos con el mismo nombre coinciden.
-- El esquema resultante es la unión de atributos sin repetidos.
eval (Join r1 r2) = do rel1 <- eval r1
                       rel2 <- eval r2
                       addTrace "Calculando producto natural..."
                       let s1 = attributes rel1
                           s2 = attributes rel2
                           common = intersectSchemas s1 s2
                           r2only = Seq.filter (\a -> not (hasAttr a s1)) (attrSeq s2)
                           newSchema = combineSchemas s1 (mkSchema (Foldable.toList r2only))
 
                       let match t1 t2 = M.restrictKeys t1 common == M.restrictKeys t2 common
 
                       let joinedTuples = S.fromList 
                               [ M.union t1 t2 | t1 <- S.toList (tuples rel1), t2 <- S.toList (tuples rel2), match t1 t2 ]
                       return (Rel newSchema joinedTuples)

-- 10. División (R ÷ S)
-- Identifica los valores de R que están combinados con todas las tuplas de S.
eval (Division r1 r2) = do rel1 <- eval r1
                           rel2 <- eval r2 
                           addTrace "Calculando división..."
                           let s1 = attributes rel1
                               s2 = attributes rel2
                               xAttrs = filter (\a -> not (hasAttr a s2)) (schemaAttrs s1)
                               xSchema = mkSchema xAttrs
                               candidatos = S.map (\t -> M.restrictKeys t (attrSet xSchema)) (tuples rel1)
                               ideal = [ M.union c t2 | c <- S.toList candidatos, t2 <- S.toList (tuples rel2) ]
                               fallas = filter (\t -> not (S.member t (tuples rel1))) ideal
                               deudores = S.fromList [ M.restrictKeys f (attrSet xSchema) | f <- fallas ]
                               resultTups = S.difference candidatos deudores
                           return (Rel xSchema resultTups)

evalCond :: Condition -> Tuple -> StateErrorTrace Bool
evalCond (Comp attr op v) tup = case M.lookup attr tup of
                                  Just v' -> evalOp v' op v 
                                  Nothing -> throw (UndefColumn attr)
evalCond (And c1 c2) tup = do b1 <- evalCond c1 tup
                              b2 <- evalCond c2 tup
                              return (b1 && b2)
evalCond (Or c1 c2) tup = do b1 <- evalCond c1 tup
                             b2 <- evalCond c2 tup
                             return (b1 || b2)
evalCond (Not c) tup = do b <- evalCond c tup
                          return (not b)

evalOp :: Value -> Op -> Value -> StateErrorTrace Bool
evalOp v1 Eq v2                = return (v1 == v2)
evalOp v1 NEq v2               = return (v1 /= v2)
evalOp (VInt v1) Gt (VInt v2)  = return (v1 > v2)
evalOp (VInt v1) Lt (VInt v2)  = return (v1 < v2)
evalOp (VInt v1) Ge (VInt v2)  = return (v1 >= v2)
evalOp (VInt v1) Le (VInt v2)  = return (v1 <= v2)
evalOp v1 _ v2                 = throw (CustomError $ "Tipos incompatibles: " ++ show v1 ++ " y " ++ show v2)

-- Si k está en avoid, devuelve k_i, donde i es el menor entero tal que k_i no está en avoid.
avoidClash :: S.Set String -> String -> String
avoidClash avoid k
  | S.member k avoid = ac (2 :: Int)
  | otherwise        = k
  where ac i = let candidate = k ++ "_" ++ show i
               in if S.member candidate avoid then ac (i + 1) else candidate