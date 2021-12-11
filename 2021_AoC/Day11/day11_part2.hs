import Data.Char
import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

f :: [Entry] -> Int
f = length . takeWhile (not . allFlash) . iterate (pulse . increase)

allFlash :: [Entry] -> Bool
allFlash = all (\(_,b) -> b == 0)

increase :: [Entry] -> [Entry]
increase = map (\((x,y),v) -> ((x,y),v+1))

pulse :: [Entry] -> [Entry]
pulse l
    | null pulses = l
    | otherwise = pulse (executePulses pulses l)
    where pulses = findPulses l

findPulses :: [Entry] -> [Point]
findPulses = map fst . filter (\(a,b) -> b > 9)

executePulses :: [Point] -> [Entry] -> [Entry]
executePulses [] l = l
executePulses (p:ps) l = executePulses ps (executePulse p l)

executePulse :: Point -> [Entry] -> [Entry]
executePulse p l = foldr g [] l
    where n = neighbours p (length l) 
          g e@(p1,v) r
              | p == p1 = (p,0):r
              | elem p1 n && v <= 9 && v /= 0 = (p1,v+1):r
              | otherwise = e:r
 
neighbours :: Point -> Int -> [Point]
neighbours (x,y) s = [(x+dx,y+dy) | dx <- [-1,0,1], dy <- [-1,0,1],
                                    x+dx >= 0, y+dy >= 0,
                                    x+dx < s, y+dy < s]

parse :: String -> [Entry]
parse = transform . map (map digitToInt) . lines

type Point = (Int,Int)
type Entry = (Point,Int)

transform :: [[Int]] -> [Entry]
transform l = [((x,y),(l!!y)!!x) | x <- [0..(length l) - 1],
                                   y <- [0..(length l) - 1]]
