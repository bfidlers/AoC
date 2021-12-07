import Data.List
import Data.List.Split

main :: IO()
main = do input <- readFile "input.txt"
          print . sum . f . parse $ input
    
f :: [Int] -> [Int]
f list = map (fuel a) list
    where a = avg list

avg :: [Int] -> Int
avg list = floor (s / len)
    where len = fromIntegral . length $ list
          s = fromIntegral . sum $ list

fuel :: Int -> Int -> Int
fuel dist org = sum [1..end]
    where end = abs (org-dist)

parse :: String -> [Int]
parse = map read . splitOn "," 
