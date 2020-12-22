import Data.List
import Data.List.Split
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . result . parseInput $ input

parseInput :: String -> (Int, [Int])
parseInput input = playGame (Game player1 player2 []) 
    where player1 = buildDeck (split!!0)
          player2 = buildDeck (split!!1)
          split = splitOn "\n\n" input
          buildDeck = map (\ x -> read x :: Int) . tail . splitOn "\n"

playGame :: GameState -> (Int, [Int])
playGame (Game x [] _) = (1, x) 
playGame (Game [] y _) = (2, y)
playGame (Game (x:xs) (y:ys) s)
    | elem ((x:xs), (y:ys)) s = (1,(x:xs))
    | x <= length xs && y <= length ys = if fst (playGame (Game (take x xs) (take y ys) [])) == 1 
                                             then playGame (Game (xs ++ x:[y]) ys prev) 
                                         else playGame (Game xs (ys ++ y:[x]) prev)
    | x > y = playGame (Game (xs ++ x:[y]) ys prev)
    | otherwise = playGame (Game xs (ys ++ y:[x]) prev) 
    where prev = (x:xs, y:ys) :s

data GameState = Game [Int] -- deck player 1
                      [Int] -- deck player 2
                      [([Int], [Int])] -- previous gamestates

result ::(Int, [Int]) -> Int
result (_, list) = foldr (\(a,b) x -> a*b + x) 0 zipped
    where zipped = zip (iterate (\x -> x-1) (length list)) list
