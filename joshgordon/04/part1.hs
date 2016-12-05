import System.Environment
import qualified Data.Map as Map
import qualified Data.Text as Text
import qualified Data.List as List


main = do
  [s] <- getArgs
  f <- readFile s
  putStr ((unlines . map getChecksum . lines) f)

dict s = show(Map.toList $ Map.fromListWith (+) [(c, 1) | c <- s])
process = dict . removeDashes . Text.unpack . (Text.dropEnd 10) . Text.pack
getChecksum = Text.unpack . (Text.takeEnd 5) . (Text.dropEnd 1) . Text.pack
--computeChecksum = map fst . take 5 . List.sortBy (comparing $ (snd))
removeDashes xs = [ x | x <- xs, not (x `elem` "-") ]
--valid s = 
