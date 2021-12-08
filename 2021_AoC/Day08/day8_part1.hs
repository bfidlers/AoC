import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . sum . f . parse $ input

simple :: [Int]
simple = [2,3,4,7]

f :: [([String], [String])] -> [Int]
f = map (length . filter (\ x -> elem x simple)) . map (\(a,b) -> map length b)

parse :: String -> [([String], [String])] 
parse = map ((\l -> (l!!0, l!!1)) . map words . splitOn (" | ")) . lines 
