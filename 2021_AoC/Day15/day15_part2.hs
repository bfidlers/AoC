import Data.Char
import Data.List
import Data.List.Split
import Data.Maybe
import qualified Data.Map as M
import qualified Data.PQueue.Prio.Min as PQ
import Data.Ord

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

-- Types

type Point = (Int,Int)
type Grid = M.Map Point Int
type Visited = M.Map Point Int
type Unvisited = PQ.MinPQueue Int Point

-- Functions

start :: (Int,Int)
start = (0,0)

f :: [[Int]] -> Int
f l = nodes M.! (5*w-1,5*h-1) 
    where grid = makeGrid l
          visited = M.empty 
          unvisited = PQ.singleton 0 start
          (w,h) = (length l, length . head $ l)
          nodes = expand grid (w,h) visited unvisited (5*w-1,5*h-1)

makeGrid :: [[Int]] -> Grid
makeGrid l = M.fromList [((x,y),n) | (y,row) <- zip [0..] l,
                                     (x,n)   <- zip [0..] row]

expand :: Grid -> Point -> Visited -> Unvisited -> Point -> Visited
expand grid s v u g
    | p == g       = newV
    | M.member p v = expand grid s v q g
    | otherwise    = expand grid s newV newU g
    where n = neighbours p g
          ((c,p),q) = PQ.deleteFindMin u
          newU = expandQueue grid s c v q n
          newV = M.insert p c v

neighbours :: Point -> Point -> [Point]
neighbours (x,y) (w,h) = [(x1,y1) | (x1,y1) <- n,
                                    x1 >= 0, y1 >= 0,
                                    x1 <= w, y1 <= h]
    where n = [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]

expandQueue :: Grid -> Point -> Int -> Visited -> Unvisited -> [Point] -> Unvisited
expandQueue grid s c v u ps = foldr extend u ps
    where extend :: Point -> Unvisited -> Unvisited
          extend p q 
              | M.member p v = q
              | otherwise = PQ.insert (c + get p s grid) p q 

get :: Point -> Point -> Grid -> Int
get (x,y) (w,h) grid 
    | v > 9 = mod v 10 + 1
    | otherwise = v
    where (qx,rx) = quotRem x w
          (qy,ry) = quotRem y h
          v = grid M.! (rx,ry) + qx + qy
    
-- parsing

parse :: String -> [[Int]] 
parse = map (map digitToInt) . lines
