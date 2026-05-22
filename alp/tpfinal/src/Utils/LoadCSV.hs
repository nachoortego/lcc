module Utils.LoadCSV (loadCSV, loadCSVsFromDir) where

import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Char8 as B8
import qualified Data.Vector as V
import qualified Data.Map as M
import qualified Data.Set as S
import Data.Csv (decode, HasHeader(NoHeader))
import Text.Read (readMaybe)
import Data.List (isSuffixOf)
import System.Directory (listDirectory)
import System.FilePath (takeBaseName, (</>))

import Types.Common (Relation(..), Value(..))
import Core.Schema (mkSchema)

toValue :: String -> Value
toValue s = case readMaybe s of
              Just n  -> VInt n
              Nothing -> VStr s

loadCSV :: FilePath -> IO (Either String Relation)
loadCSV path = do
  csvData <- BL.readFile path
  case decode NoHeader csvData of
    Left err -> return $ Left ("Error al parsear CSV: " ++ err)
    Right v  -> case V.toList v of
      [] -> return $ Left "El archivo está vacío"
      (header : rows) -> do
        let colNames = map B8.unpack (V.toList header)
        let esquema = mkSchema colNames
        let mkTup row = M.fromList $ zip colNames (map toValue (map B8.unpack (V.toList row)))
        let tuplas = S.fromList $ map mkTup rows
        return $ Right (Rel esquema tuplas)

loadCSVsFromDir :: FilePath -> IO ([(String, Relation)], [String])
loadCSVsFromDir dir = do
  contents <- listDirectory dir
  let csvFiles = filter (".csv" `isSuffixOf`) contents
  results <- mapM loadOne csvFiles
  let (oks, errs) = foldr partitionResult ([], []) results
  return (oks, errs)
  where
    loadOne f = do
      let path = dir </> f
      rel <- loadCSV path
      return (takeBaseName f, rel)
    partitionResult (name, Left msg) (oks, errs) = (oks, (name ++ ": " ++ msg) : errs)
    partitionResult (name, Right rel) (oks, errs) = ((name, rel) : oks, errs)
