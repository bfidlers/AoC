import Data.List
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . uncurry (*) . f . parseInput $ input

f :: [[Int]] -> (Int, Int)
f input = (oxy, co2)
    where oxy = bin . compare' input $ mostCommon
          co2 = bin . compare' input $ leastCommon

compare' :: [[Int]] -> ([Int] -> Int) -> [Int]
compare' l f = compareBit 0 l f
          
compareBit :: Int -> [[Int]] -> ([Int] -> Int) -> [Int]
compareBit nb l f
    | length l == 1 = head l
    | otherwise = compareBit (nb+1) new_l f 
        where current_bits = map (!!nb) l
              cond = f current_bits
              new_l = filter (\x -> x!!nb == cond) l 

mostCommon :: [Int] -> Int
mostCommon l = if fromIntegral (sum l) >= fromIntegral (length l) / 2 
                   then 1 
               else 0  

leastCommon :: [Int] -> Int
leastCommon l = if fromIntegral (sum l) < fromIntegral (length l) / 2 
                    then 1 
                else 0

bin :: [Int] -> Int
bin digits = foldl (\acc d -> acc*2 + d) 0 digits

parseInput :: String -> [[Int]]
parseInput = map (\x -> map (digitToInt) x) . lines 
