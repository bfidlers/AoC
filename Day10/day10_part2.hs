import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . calculateResult . countGroups . removeUpperB . parse . (0:) . sort . (map (\ x -> read x :: Int)) . words $ input
          
parse :: [Int] -> [Int]
parse (x1:[]) = []
parse (x1:x2:xs) = (if x2 - x1 == 1 then [x2] else []) ++ (parse (x2:xs))

removeUpperB :: [Int] -> [[Int]]
removeUpperB (x:[]) = [[]]
removeUpperB (x1:x2:xs) = (\ (a:as) -> if x2 - x1 == 1 then (x1:a):as else [] : (a:as)) (removeUpperB (x2:xs))

countGroups :: [[Int]] -> (Int, Int)
countGroups [] = (0,0)
countGroups (x:xs) 
    | length x == 1 = (\ (a,b) -> (a+1,b)) (countGroups xs)
    | length x == 2 = (\ (a,b) -> (a+2,b)) (countGroups xs)
    | length x == 3 = (\ (a,b) -> (a,b+1)) (countGroups xs)
    | otherwise = (countGroups xs)
    
calculateResult :: (Int, Int) -> Int
calculateResult (a,b) = (7^b)*(2^a)
