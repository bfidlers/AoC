import Data.Char
import Data.List
import Data.List.Split
import Data.Maybe
import Data.Ord

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

answer :: [[Int]] -> [Point] -> Int
answer input pos = sum [get p input | p <- pos] 

answer' p = cCost . head . filter (\n -> pos n == p)

start :: (Int,Int)
start = (0,0)

end :: [[Int]] -> Point
end l = (length l, length . head $ l)

--f :: [[Int]] -> [Point]
--f l = unvisited 
f l = answer' (w-1,h-1) nodes 
    where visited = []
          unvisited = [N start 0 0 start]
          (w,h) = end l
          nodes = expand l unvisited visited (w-1,h-1)

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
expand :: [[Int]] -> [Node] -> [Node] -> Point -> [Node]
--expand [] v _ = v
expand l (u:us) v g
    | pos u == g = u:v
    | otherwise = expand l newU (u:v) g
    where n = neighbours (pos u) g
          newU = calculateCosts l u n v us

get :: Point -> [[Int]] -> Int
get (x,y) l = (l!!y)!!x
    
neighbours :: Point -> Point -> [Point]
neighbours (x,y) (w,h) = [(x1,y1) | (x1,y1) <- n,
                                    x1 >= 0, y1 >= 0,
                                    x1 <= w, y1 <= h]
    where n = [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]

calculateCosts :: [[Int]] -> Node -> [Point] -> [Node] -> [Node] -> [Node]
calculateCosts l c points v u = foldr (calculateCost l c v) u points

calculateCost :: [[Int]] -> Node -> [Node] -> Point -> [Node] -> [Node]
calculateCost l n0 v p u 
    | isJust vIndex    = u
    | isNothing uIndex = insert' (N p c (c+c0) (pos n0)) u
    | otherwise        = insert' middle (before ++ after) 
    where vIndex = findIndex (\n -> pos n == p) v
          uIndex = findIndex (\n -> pos n == p) u
          i = fromJust uIndex
          before = take i u
          after = drop (i+1) u
          middle = (\n@(N p1 bc cc p2) -> if c0+bc < cc then N p1 bc (c0+bc) (pos n0)
                                          else n) (u!!i)
          c0 = cCost n0
          c = get p l

insert' :: Node -> [Node] -> [Node]
insert' x l = lower ++ x : greater
    where (lower, greater) = span (\n -> cCost n < cCost x) l

path :: Point -> Point -> [Node] -> [Point]
path b e nodes
    | pos node == b = []
    | otherwise = pos node : path b next nodes 
    where node = head . filter (\n -> pos n == e) $ nodes
          next = prev node

type Point = (Int,Int)

parse :: String -> [[Int]] 
parse = map (map digitToInt) . lines
