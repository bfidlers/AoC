import Data.Char
import Data.List
import Data.List.Split
import Data.Maybe
import qualified Data.Map as M
import Data.Ord
import qualified Data.Set as S
import qualified Data.PQueue.Prio.Min as PQ

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

-- Types

type Grid = M.Map Point Int
type Point = (Int,Int)
type Visited = M.Map Point Int
type Unvisited = PQ.MinPQueue Int Point

-- Functions

answer :: Visited -> Point -> Int
answer v p = v M.! p 

start :: (Int,Int)
start = (0,0)

f :: [[Int]] -> Int
f l = answer nodes (w-1,h-1)
    where grid = makeGrid l
          visited = M.empty
          unvisited = PQ.singleton 0 start
          (w,h) = (length l, length . head $ l)
          nodes = expand grid unvisited visited (w-1,h-1)

makeGrid :: [[Int]] -> Grid
makeGrid l = M.fromList [((x,y),n) | (y,row)  <- zip [0..] l,
                                     (x,n)    <- zip [0..] row]

expand :: Grid -> Unvisited -> Visited -> Point -> Visited
expand grid u v g
    | p == g = newV
    | M.member p v = expand grid (PQ.deleteMin u) v g
    | otherwise = expand grid newU newV g
    where ((c,p),q) = PQ.deleteFindMin u
          n = neighbours p g
          newU = expandQueue grid c q v n
          newV = M.insert p c v

neighbours :: Point -> Point -> [Point]
neighbours (x,y) (w,h) = [(x1,y1) | (x1,y1) <- n,
                                    x1 >= 0, y1 >= 0,
                                    x1 <= w, y1 <= h]
    where n = [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]

expandQueue :: Grid -> Int -> Unvisited -> Visited -> [Point] -> Unvisited
expandQueue grid c u v p = foldr check u p
    where check :: Point -> Unvisited -> Unvisited
          check p queue
              | M.member p v = queue
              | otherwise = PQ.insert (c + get p grid) p queue 

get :: Point -> Grid -> Int
get p grid = grid M.! p 

parse :: String -> [[Int]] 
parse = map (map digitToInt) . lines
