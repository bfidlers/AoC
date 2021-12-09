import Data.List
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . sum . risk . f . parse $ input

risk :: [Int] -> [Int]
risk = map (1+)

f :: [[Int]] -> [Int]
f l@(r:rs) = [(l!!y)!!x | x <- [0..lx-1], y <- [0..ly-1],
                          (l!!y)!!x < minimum (getElems x y l)]
    where lx = length r
          ly = length l

getElems :: Int -> Int -> [[Int]] -> [Int]
getElems x y l = e (x-1) y l ++ e x (y-1) l ++ e (x+1) y l ++ e x (y+1) l

e :: Int -> Int -> [[Int]] -> [Int]
e x y l
    | x < 0 = []
    | y < 0 = []
    | x >= length (head l) = []
    | y >= length l = []
    | otherwise = [(l!!y)!!x]

parse :: String -> [[Int]]
parse = map (map digitToInt) . lines
