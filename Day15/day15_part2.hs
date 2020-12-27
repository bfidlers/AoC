import Data.List
import Data.List.Split
import Data.Maybe
import qualified Data.Map.Strict as Map
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . game 30000000 . map (\x -> read x :: Int) . splitOn "," $ input
          
game :: Int -> [Int] -> Int
game turns input = turn turns mapping index (input!!(index -1))
    where index = length input
          mapping = Map.fromList (zip (init input) [1..index-1]) 

turn :: Int -> Map.Map Int Int -> Int -> Int -> Int
turn limit state index nb 
    | index >= limit = nb
    | otherwise = case Map.lookup nb state of 
        Nothing -> turn limit newState (index+1) 0
        Just newNb -> turn limit newState (index+1) (index - newNb) 
     where newState = (Map.insert nb index state)
