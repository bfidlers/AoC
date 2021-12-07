import Data.List
import Data.List.Split

main :: IO()
main = do input <- readFile "input.txt"
          print . sum . f . parse $ input

f :: [Int] -> [Int]
f list = diff m list
    where m = mean list

mean :: [Int] -> Int
mean list = if odd len then sorted !! (index + 1) 
            else div (sorted !! index + sorted !! index+1) 2
    where sorted = sort list
          len = length list
          index = div len 2

diff :: Int -> [Int] -> [Int]
diff nb = map (\x -> abs (x-nb))

parse :: String -> [Int]
parse = map read . splitOn "," 
