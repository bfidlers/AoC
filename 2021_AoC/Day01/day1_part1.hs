import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . count . map read . words $ input

count :: [Int] -> Int
count (x:xs) = f x xs
    where f :: Int -> [Int] -> Int
          f _ [] = 0
          f nb (x:xs)
              | x > nb = 1 + f x xs
              | otherwise = f x xs
