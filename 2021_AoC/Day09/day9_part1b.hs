import Data.List
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . parse $ input
          print . f . parse $ input
          print . sum . risk . f . parse $ input

risk :: [Int] -> [Int]
risk = map (1+)

f :: [[Int]] -> [Int]
f l@(r:rs) = map (\i -> get i l) [(x,y) | x <- [0..lx-1], y <- [0..ly-1],
                                          let n = neighbours (x,y) (lx,ly)
                                              in isLowest (x,y) n l]
    where lx = length r
          ly = length l

get :: (Int,Int) -> [[Int]] -> Int
get (x,y) l = (l!!y)!!x

neighbours :: (Int,Int) -> (Int,Int) -> [(Int,Int)]
neighbours (x,y) (lx,ly) = [(x+dx,y+dy) | dx <- [-1,0,1],
                                      dy <- [-1,0,1],
                                      x + dx >= 0, y + dy >= 0,
                                      x + dx < lx, y + dy < ly,
                                      abs dx /= abs dy]

isLowest :: (Int,Int) -> [(Int,Int)] -> [[Int]] -> Bool
isLowest (x,y) neigh l = c < n
    where c = get (x,y) l
          n = minimum . map (\i -> get i l) $ neigh

parse :: String -> [[Int]]
parse = map (map digitToInt) . lines
