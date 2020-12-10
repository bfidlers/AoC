import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . mult . parse . (0:) . sort . (map (\ x -> read x :: Int)) . words $ input
          
parse :: [Int] -> (Int, Int)
parse (x1:[]) = (0,1)
parse (x1:x2:xs) = ( \(a,b) -> if x2 - x1 == 1 then (a+1, b) else (a, b+1)) (parse (x2:xs))

mult :: (Int, Int) -> Int
mult (a,b) = a*b
