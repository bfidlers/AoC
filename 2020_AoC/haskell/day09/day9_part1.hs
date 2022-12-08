main :: IO ()
main = do input <- readFile "input.txt"
          print . checkInput . (map (\ x -> read x :: Int)) . words $ input
          
checkInput :: [Int] -> Int
checkInput list = checkNumbers (take 25 list) (drop 25 list) 

checkNumbers :: [Int] -> [Int] -> Int 
checkNumbers (x:xs) (y:ys) = if checkCondition (x:xs) y
                             then checkNumbers (xs ++ [y]) ys 
                             else y

checkCondition :: [Int] -> Int -> Bool
checkCondition list nb = length [True | a <- list, b <- list, a + b == nb] /= 0
