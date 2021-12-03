import Data.List
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . uncurry (*) . f . parseInput $ input

f :: [[Int]] -> (Int, Int)
f input = (gamma, eps)
    where fold = foldr (merge) base input
          merge [] [] = []
          merge (x:xs) (y:ys) = x+y : merge xs ys 
          base = replicate w 0
          l = length input
          w = length . head $ input
          mostCommon = map (\x -> if x > div l 2 then 1 else 0) fold
          gamma = bin mostCommon
          eps = 2^w - gamma - 1

bin :: [Int] -> Int
bin digits = foldl (\acc d -> acc*2 + d) 0 digits

parseInput :: String -> [[Int]]
parseInput = map (\x -> map (digitToInt) x) . lines 
