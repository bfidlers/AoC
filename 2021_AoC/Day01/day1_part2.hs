import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . count . merge . map read . words $ input

merge :: [Int] -> [Int]
merge list
    | length(list) < 3 = []
    | otherwise = (sum . take 3 $ list) : (merge (tail list))

count :: [Int] -> Int
count (x:xs) = f x xs
    where f :: Int -> [Int] -> Int
          f _ [] = 0
          f nb (x:xs)
              | x > nb = 1 + f x xs
              | otherwise = f x xs
