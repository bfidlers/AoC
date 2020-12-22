import Data.List
import Data.List.Split
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . result . parseInput $ input

parseInput :: String -> [Int]
parseInput input = playGame player1 player2
    where player1 = buildDeck (split!!0)
          player2 = buildDeck (split!!1)
          split = splitOn "\n\n" input
          buildDeck = map (\ x -> read x :: Int) . tail . splitOn "\n"

playGame :: [Int] -> [Int] -> [Int]
playGame [] y = y 
playGame x [] = x
playGame (x:xs) (y:ys) 
    | x > y = playGame (xs ++ x:[y]) ys
    | otherwise = playGame xs (ys ++ y:[x]) 

result :: [Int] -> Int
result list = foldr (\(a,b) x -> a*b + x) 0 zipped
    where zipped = zip (iterate (\x -> x-1) (length list)) list
