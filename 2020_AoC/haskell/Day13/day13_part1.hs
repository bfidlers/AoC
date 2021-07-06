import Debug.Trace

main :: IO()
main = do input <- readFile "input.txt"
          print . result . calculate (0, 0) . parseInput . lines $ input
                             
parseInput :: [String] -> (Int, [Int])
parseInput (x1:x2:xs) = (read x1, map read . filter (/= "x") . splitBy ',' $ x2)

splitBy :: Eq a => a -> [a] -> [[a]]
splitBy seperator [] = []
splitBy seperator (x:xs) 
    | null xs = [[x]]
    | x == seperator = [[]] ++ (splitBy seperator xs)
    | otherwise = (\ (y:ys) -> (x:y):ys) (splitBy seperator xs)
  
calculate :: (Int, Int) -> (Int, [Int]) -> (Int, Int)
calculate (a,b) (x, []) = (a,b) 
calculate (a,b) (x, (y:ys)) 
    | a == 0 = calculate (y, nb) (x, ys)
    | nb < b = calculate (y, nb) (x, ys)
    | otherwise = calculate (a, b) (x, ys)
        where nb = (div x y + 1) * y - x
        
result :: (Int, Int) -> Int
result (a,b) = a*b
