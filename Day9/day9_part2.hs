main :: IO ()
main = do input <- readFile "input.txt"
          print . checkInput . (map (\ x -> read x :: Int)) . words $ input
          
checkInput :: [Int] -> Int
checkInput list = computeResult (findContNumbers 0 0 list (checkNumbers (take 25 list) (drop 25 list))) 

checkNumbers :: [Int] -> [Int] -> Int 
checkNumbers (x:xs) (y:ys) = if checkCondition (x:xs) y 
                             then checkNumbers (xs ++ [y]) ys 
                             else y

checkCondition :: [Int] -> Int -> Bool
checkCondition list nb = length [True | a <- list, b <- list, a + b == nb] /= 0

findContNumbers :: Int -> Int -> [Int] -> Int -> [Int]
findContNumbers tmp i list nb 
    | tmp + list!!i > nb = findContNumbers 0 0 (tail list) nb
    | tmp + list!!i == nb = [list!!n | n <- [0..i-1]]
    | otherwise = findContNumbers (tmp + list!!i) (i+1) list nb         
                                 
computeResult :: [Int] -> Int
computeResult list = minimum list + maximum list
