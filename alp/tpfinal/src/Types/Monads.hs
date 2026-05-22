module Types.Monads (
  StateErrorTrace, runStateErrorTrace,
  MonadState(lookfor, update), MonadError(throw), MonadTrace(addTrace),
  getContext, getDepth, putDepth, maxViewDepth
) where

import Types.Common ()
import Types.RelContext (Context, Resource(..))
import Core.AST (Error(..), NombreRelacion)
import Control.Monad  (liftM, ap)
import qualified Data.Map as M

type Trace = String

type RunnerState = (Context, Int)

newtype StateErrorTrace a = StateErrorTrace {
  runStateErrorTrace :: RunnerState -> Either Error (a, RunnerState, Trace)
}

-- | Profundidad máxima al expandir vistas (evita consultas circulares)
maxViewDepth :: Int
maxViewDepth = 20

class Monad m => MonadState m where
  lookfor :: NombreRelacion -> m Resource
  update  :: NombreRelacion -> Resource -> m ()

class Monad m => MonadError m where
  throw :: Error -> m a

class Monad m => MonadTrace m where
  addTrace :: String -> m ()

getContext :: StateErrorTrace Context
getContext = StateErrorTrace (\(ctx, d) -> Right (ctx, (ctx, d), ""))

getDepth :: StateErrorTrace Int
getDepth = StateErrorTrace (\(ctx, d) -> Right (d, (ctx, d), ""))

putDepth :: Int -> StateErrorTrace ()
putDepth d' = StateErrorTrace (\(ctx, _) -> Right ((), (ctx, d'), ""))


instance Functor StateErrorTrace where
  fmap = liftM

instance Applicative StateErrorTrace where
  pure x = StateErrorTrace (\s -> Right (x, s, ""))
  (<*>) = ap

instance Monad StateErrorTrace where
  return = pure
  m >>= f = StateErrorTrace (\s -> case runStateErrorTrace m s of
    Left err -> Left err
    Right (v, s', t1) -> case runStateErrorTrace (f v) s' of
      Left err -> Left err
      Right (v', s'', t2) -> Right (v', s'', t1 ++ t2))

instance MonadError StateErrorTrace where
  throw err = StateErrorTrace (\_ -> Left err)

instance MonadState StateErrorTrace where
  lookfor v = StateErrorTrace (\(ctx, d) -> case M.lookup v ctx of
                                  Just r  -> Right (r, (ctx, d), "")
                                  Nothing -> Left UndefVar)
  update v res = StateErrorTrace (\(ctx, d) -> Right ((), (M.insert v res ctx, d), "Vista/tabla actualizada: " ++ v ++ "\n"))

instance MonadTrace StateErrorTrace where
  addTrace msg = StateErrorTrace (\(ctx, d) -> Right ((), (ctx, d), msg ++ "\n"))
