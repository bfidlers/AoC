import Data.Char
import Data.List
import Data.List.Split
import Data.Ord

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

start :: (Int,Int)
start = (0,0)

end :: [[Int]] -> Point
end l = (length l, length . head $ l)

f :: [[Int]] -> Int
f l = sum [get pos l | pos <- p]
    where visited = []
          unvisited = begin : map (\p -> (N p (get p l) 10000000000 p)) is 
          (i:is) = [(x,y) | x <- [0..w-1], y <- [0..h-1]]
          begin = N start 0 0 start
          (w,h) = end l
          nodes = expand unvisited visited (w-1,h-1)
          p = path start (w-1,h-1) nodes

data Node = N Point Int Int Point
    deriving Show

pos :: Node -> Point
pos (N p _ _ _) = p

bCost :: Node -> Int
bCost (N _ c _ _) = c

cCost :: Node -> Int
cCost (N _ _ c _) = c

prev :: Node -> Point
prev (N _ _ _ p) = p

--expand unvisited visited end
expand :: [Node] -> [Node] -> Point -> [Node]
--expand [] v _ = v
expand (u:us) v g
    | pos u == g = u:v
    | otherwise = expand newU (u:v) g
    where n = neighbours (pos u) g
          newU = sortBy (comparing cCost) . calculateCosts u n $ us

get :: Point -> [[Int]] -> Int
get (x,y) l = (l!!y)!!x
    
neighbours :: Point -> Point -> [Point]
neighbours (x,y) (w,h) = [(x1,y1) | (x1,y1) <- n,
                                    x1 >= 0, y1 >= 0,
                                    x1 <= w, y1 <= h]
    where n = [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]

calculateCosts :: Node -> [Point] -> [Node] -> [Node]
calculateCosts c p u = map (calculateCost c p) u

calculateCost :: Node -> [Point] -> Node -> Node
calculateCost n0 points n@(N p bc cc p2)
    | null p0 = n
    | otherwise = if c0 + bc < cc then N p bc (c0+bc) (pos n0)
                  else n 
    where p0 = filter (p==) points
          c0 = cCost n0

path :: Point -> Point -> [Node] -> [Point]
path b e nodes
    | pos node == b = []
    | otherwise = pos node : path b next nodes 
    where node = head . filter (\n -> pos n == e) $ nodes
          next = prev node

type Point = (Int,Int)

parse :: String -> [[Int]] 
parse = map (map digitToInt) . lines
