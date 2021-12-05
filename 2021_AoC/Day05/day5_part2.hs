import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . parse $ input
          print . f . parse $ input

--f :: [[Point]] -> Int
f = length . filter (/= 1) . map length . group . sort . list . map createLine
--f = map createLine
    where list = foldr (++) []

createLine :: [Point] -> [Point]
createLine ((x1,y1):(x2,y2):[])
    | x1 - x2 == y1 - y2 && x1 > x2 = [(x1-d,y1-d) | d <- [0..x1-x2]]
    | x1 - x2 == y1 - y2 && x2 >= x1 = [(x1+d,y1+d) | d <- [0..x2-x1]]
    | x1 - x2 == y2 - y1 && x1 > x2 = [(x1-d,y1+d) | d <- [0..x1-x2]]
    | x1 - x2 == y2 - y1 && x2 >= x1 = [(x1+d,y1-d) | d <- [0..x2-x1]]
    | x1 == x2 = if y1 < y2 then [(x1,y) | y <- [y1..y2]]
                 else [(x1,y) | y <- [y2..y1]]
    | y1 == y2 = if x1 < x2 then [(x,y1) | x <- [x1..x2]]
                 else [(x,y1) | x <- [x2..x1]]
    | otherwise = []
    where minX = min x1 x2
          maxX = max x1 x2
          minY = min y1 y2
          maxY = max y1 y2

type Point = (Int, Int)

--parse :: String -> [(Point, Point)]
parse :: String -> [[Point]]
parse input = coords
    where line = lines input
          coords = map (map (toPoints . splitOn ",") . splitOn " -> ") line
          toPoints (x:y:[]) = (read x, read y)
