module Interface.Repl (repl, showTables, showHelp) where

import System.Directory (doesDirectoryExist)
import qualified Data.Map as M

import Core.AST (RAExp(..))
import Types.Common ()
import Types.RelContext (Context, Resource(..))
import Core.Parser (parseRA, parseViewDef)
import Core.Eval (eval)
import Types.Monads (runStateErrorTrace, update, getContext)
import Interface.PPRel (renderTable, renderRA)
import Core.Optimizer (optimize)
import Utils.LoadCSV (loadCSVsFromDir)

dataDir :: FilePath
dataDir = "data"

repl :: Context -> IO ()
repl ctx = do
  putStr "\nRA> "
  input <- getLine
  case input of
    "exit"    -> putStrLn "¡Adiós!"
    "help"    -> showHelp >> repl ctx
    "h"       -> showHelp >> repl ctx
    "tablas"  -> showTables ctx >> repl ctx
    "refresh" -> handleRefresh ctx >>= repl
    "r"       -> handleRefresh ctx >>= repl
    _         -> handleQuery input ctx >>= repl

handleRefresh :: Context -> IO Context
handleRefresh _ = do
  exists <- doesDirectoryExist dataDir
  if not exists
    then putStrLn "data/ no existe." >> return M.empty
    else do
      (loaded, errs) <- loadCSVsFromDir dataDir
      mapM_ putStrLn errs
      let ctx = foldl (\c (name, rel) -> M.insert name (Table rel) c) M.empty loaded
      putStrLn ("Tablas recargadas: " ++ show (length loaded))
      return ctx

handleQuery :: String -> Context -> IO Context
handleQuery input ctx =
  case parseViewDef input of
    Right (name, viewExp) -> do
      case runStateErrorTrace (update name (View viewExp) >> getContext) (ctx, 0) of
        Left err -> putStrLn ("Error: " ++ show err) >> return ctx
        Right (newCtx, _, _) -> putStrLn ("Vista '" ++ name ++ "' creada.") >> return newCtx
    Left _ -> do
      case parseRA input of
        Left err -> print err >> return ctx
        Right ast -> do
          let pipeline = do astOpt <- optimize ast
                            rel <- eval astOpt
                            return (astOpt, rel)
          case runStateErrorTrace pipeline (ctx, 0) of
            Left evalErr -> putStrLn ("Error: " ++ show evalErr) >> return ctx
            Right ((astOpt, rel), _, trace) -> do
              putStrLn $ "\n" ++ trace
              putStrLn $ "\nConsulta parseada: " ++ renderRA ast
              putStrLn $ "\nConsulta optimizada: " ++ renderRA astOpt
              putStrLn $ "\n" ++ renderTable rel
              return ctx

showTables :: Context -> IO ()
showTables ctx = do
  putStrLn "\nTablas y vistas en el contexto:"
  mapM_ (\name -> do
           putStrLn $ "\n--- " ++ name ++ " ---"
           case runStateErrorTrace (eval (Tabla name)) (ctx, 0) of
             Left err -> putStrLn $ "  Error al resolver: " ++ show err
             Right (rel, _, _) -> putStrLn $ renderTable rel
        ) (M.keys ctx)

showHelp :: IO ()
showHelp = putStrLn $ unlines
  [ ""
  , "Manual Rápido de Álgebra Relacional"
  , "===================================="
  , "Operaciones Unarias:"
  , "  PROY[col1, col2](R)       - Proyección de columnas"
  , "  SEL[col == valor](R)      - Selección (Soporta ==, !=, >, <, >=, <=)"
  , "  REN[viejo -> nuevo](R)    - Renombrar un atributo"
  , ""
  , "Operaciones Binarias (Infix):"
  , "  R1 UNION R2               - Unión de relaciones"
  , "  R1 DIFF R2                - Diferencia de conjuntos"
  , "  R1 INTER R2               - Intersección"
  , "  R1 JOIN R2                - Natural Join"
  , "  R1 PROD R2                - Producto Cartesiano"
  , "  R1 DIV R2                 - División"
  , ""
  , "Condiciones Complejas:"
  , "  SEL[id > 5 && nota <= 10](R)"
  , "  SEL[!(nombre == \"Juan\")](R)"
  , ""
  , "Comandos:"
  , "  refresh, r                 - Recargar CSV desde data/"
  , "  tablas                     - Listar tablas y vistas"
  , "  VIEW nombre AS (expr)      - Crear vista"
  , "  help , h                   - Mostrar este manual"
  , "  exit                      - Salir del programa"
  ]
