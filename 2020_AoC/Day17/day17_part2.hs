import Data.List
import qualified Data.Map as M

main :: IO ()
main = do input <- readFile "input.txt"
          print . result . run 6 . expand . parse . words $ input

parse :: [String] -> Pocket
parse input = Pocket (M.unions [map1, map2, map3, map4, map5, map6, map7, map8]) 0 7 0 7 0 0 0 0
    where coords0 = [(x, 0, 0, 0) | x <- [0 .. 7]]
          coords1 = [(x, 1, 0, 0) | x <- [0 .. 7]]
          coords2 = [(x, 2, 0, 0) | x <- [0 .. 7]]
          coords3 = [(x, 3, 0, 0) | x <- [0 .. 7]]
          coords4 = [(x, 4, 0, 0) | x <- [0 .. 7]]
          coords5 = [(x, 5, 0, 0) | x <- [0 .. 7]]
          coords6 = [(x, 6, 0, 0) | x <- [0 .. 7]]
          coords7 = [(x, 7, 0, 0) | x <- [0 .. 7]]
          map1 = M.fromList . zip coords0 $ (input!!0)
          map2 = M.fromList . zip coords1 $ (input!!1)
          map3 = M.fromList . zip coords2 $ (input!!2)
          map4 = M.fromList . zip coords3 $ (input!!3)
          map5 = M.fromList . zip coords4 $ (input!!4)
          map6 = M.fromList . zip coords5 $ (input!!5)
          map7 = M.fromList . zip coords6 $ (input!!6)
          map8 = M.fromList . zip coords7 $ (input!!7)

data Pocket = Pocket 
              (M.Map (Int,Int,Int,Int) Char) -- map 
              Int -- minX 
              Int -- maxX 
              Int -- minY 
              Int -- maxY 
              Int -- minZ 
              Int -- maxZ 
              Int -- minW
              Int -- maxW
    deriving (Show)

result :: Pocket -> Int 
result (Pocket mapping _ _ _ _ _ _ _  _) = length . filter (\ x -> x == '#') . M.elems $ mapping

run :: Int -> Pocket -> Pocket 
run 0 pocket = pocket 
run n pocket = run (n-1) . loop . expand $ pocket

loop :: Pocket-> Pocket
loop (Pocket mapping x1 x2 y1 y2 z1 z2 w1 w2) = Pocket (M.fromList (loopHelp entries mapping)) x1 x2 y1 y2 z1 z2 w1 w2
    where entries = M.toList mapping
          loopHelp :: [((Int,Int,Int,Int), Char)] -> M.Map (Int,Int,Int,Int) Char -> [((Int,Int,Int,Int), Char)]
          loopHelp [] m = []
          loopHelp ((a,b):xs) m = (a, checkNeighbours a b m) : loopHelp xs m 

expand :: Pocket -> Pocket
expand (Pocket mapping x1 x2 y1 y2 z1 z2 w1 w2) = Pocket newMap x1' x2' y1' y2' z1' z2' w1' w2'
    where newMap = M.unions [mapping, ex1, ex2, ey1, ey2, ez1, ez2, ew1, ew2]
          ex1 = M.fromList [((x1',y,z,w), '.') | y <- [y1..y2], z <- [z1..z2], w <- [w1..w2]] 
          ex2 = M.fromList [((x2',y,z,w), '.') | y <- [y1..y2], z <- [z1..z2], w <- [w1..w2]] 
          ey1 = M.fromList [((x,y1',z,w), '.') | x <- [x1'..x2'], z <- [z1..z2], w <- [w1..w2]] 
          ey2 = M.fromList [((x,y2',z,w), '.') | x <- [x1'..x2'], z <- [z1..z2], w <- [w1..w2]] 
          ez1 = M.fromList [((x,y,z1',w), '.') | x <- [x1'..x2'], y <- [y1'..y2'], w <- [w1..w2]] 
          ez2 = M.fromList [((x,y,z2',w), '.') | x <- [x1'..x2'], y <- [y1'..y2'], w <- [w1..w2]] 
          ew1 = M.fromList [((x,y,z,w1'), '.') | x <- [x1'..x2'], y <- [y1'..y2'], z <- [z1'..z2']] 
          ew2 = M.fromList [((x,y,z,w2'), '.') | x <- [x1'..x2'], y <- [y1'..y2'], z <- [z1'..z2']] 
          x1' = x1 - 1
          x2' = x2 + 1
          y1' = y1 - 1
          y2' = y2 + 1
          z1' = z1 - 1
          z2' = z2 + 1
          w1' = w1 - 1
          w2' = w2 + 1

checkNeighbours :: (Int, Int, Int, Int) -> Char -> M.Map (Int,Int,Int,Int) Char -> Char
checkNeighbours pos state mapping
    | state == '.' && activeNeighbours == 3 = '#'
    | state == '#' && (activeNeighbours == 3 || activeNeighbours == 2) = '#' 
    | otherwise = '.'
    where activeNeighbours = foldr f 0 neighbourPos 
          neighbourPos = neighbours pos 
          f x y = case M.lookup x mapping of 
                     Nothing -> 0 + y 
                     Just a -> if a == '.' then 0 + y else 1 + y  

neighbours :: (Int, Int, Int, Int) -> [(Int, Int, Int, Int)]
neighbours (x,y,z,w) = delete (x,y,z,w) [(x-x1,y-y1,z-z1,w-w1) | x1 <- [-1..1], y1 <- [-1..1], z1 <- [-1..1], w1 <- [-1..1]] 
