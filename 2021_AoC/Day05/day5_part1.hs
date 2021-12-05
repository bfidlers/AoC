import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

f :: [[Point]] -> Int
f = length . filter (/= 1) . map length . group . sort . concat . map createLine

createLine :: [Point] -> [Point]
createLine ((x1,y1):(x2,y2):[])
    | x1 == x2 = [(x1,y) | y <- [y1,y1+dy..y2]]
    | y1 == y2 = [(x,y1) | x <- [x1,x1+dx..x2]]
    | otherwise = []
    where dx = div (x2 - x1) (abs (x2 - x1))
          dy = div (y2 - y1) (abs (y2 - y1))

type Point = (Int, Int)

parse :: String -> [[Point]]
parse input = coords
    where line = lines input
          coords = map (map (toPoints . splitOn ",") . splitOn " -> ") line
          toPoints (x:y:[]) = (read x, read y)
