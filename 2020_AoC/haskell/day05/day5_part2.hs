import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . findGap . sort . calculateID . parseInput . words $ input
          
parseInput :: [String] -> [(String, String)]
parseInput [] = []
parseInput (x:xs) = splitAt 7 x : parseInput xs

calculateColumn :: String -> Int 
calculateColumn [] = 0
calculateColumn (x:xs)
    | x == 'L' = calculateColumn xs
    | x == 'R' = (2 ^ length xs) + calculateColumn xs
        
calculateRow :: String -> Int 
calculateRow [] = 0
calculateRow (x:xs)
    | x == 'F' = calculateRow xs
    | x == 'B' = (2 ^ length xs) + calculateRow xs
        
calculateID:: [(String, String)] -> [Int]
calculateID [] = []
calculateID (x:xs) = 8 * row + col : calculateID xs
    where row = calculateRow (fst x)
          col = calculateColumn (snd x) 
          
findGap :: [Int] -> Int
findGap (x1:x2:xs) 
    | x2 /= x1 + 1 = x2 - 1
    | otherwise = findGap (x2:xs)
