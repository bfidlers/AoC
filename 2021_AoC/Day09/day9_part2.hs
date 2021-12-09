import Data.List
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
         -- print . parse $ input
         -- print . f . parse $ input
         -- print . map (map (\x -> get x (parse input))) . f . parse $ input
          print . result . f . parse $ input

result :: [[(Int,Int)]] -> Int
result = product . take 3 . reverse . sort . map length

f :: [[Int]] -> [[(Int,Int)]]
f input = map (\x -> basin [x] input) lowest
    where lowest = lowestPoints input

lowestPoints :: [[Int]] -> [(Int,Int)]
lowestPoints l@(r:rs) = [(x,y) | x <- [0..lx-1], y <- [0..ly-1],
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

basin :: [(Int,Int)] -> [[Int]] -> [(Int,Int)]
basin current input
    | null eligible = nub current
    | otherwise = basin (current ++ eligible) input
    where neigh = concat . map (\i -> neighbours i s) $ current
          s = (length . head $ input, length input)
          eligible = filter (\i -> (get i input /= 9) 
                                   && (not . elem i $ current)) neigh

parse :: String -> [[Int]]
parse = map (map digitToInt) . lines
