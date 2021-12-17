import Data.List
import Data.List.Split

main :: IO () 
main = do input <- readFile "input.txt"
          print . f . parse $ input

type Point = (Int,Int)
type Velocity = (Int,Int)
type State = (Point,Velocity)
type Target = (Point,Point)

f :: Target -> Int
f t@((x0,x1),(y0,y1)) = length valid
    where valid = filter (hitsTarget t . (\p -> (start,p))) pos
          pos = [(x,y) | y <- [y0,y0+1..(abs y0)], 
                         x <- [1..x1]]

start :: Point
start = (0,0)

step :: State -> State
step ((x,y),(vx,vy)) = ((x+vx,y+vy),(nvx,vy-1))
    where nvx 
            | vx == 0 = 0
            | vx < 0  = vx + 1
            | vx > 0  = vx - 1 

hitsTarget :: Target -> State -> Bool
hitsTarget t@((x0,x1),(y0,y1)) s@((x,y),(vx,vy))
    | x >= x0 && x <= x1 && y >= y0 && y <= y1 = True
    | x > x1 = False
    | x < x0 && vx == 0 = False
    | y < y0 = False
    | otherwise = hitsTarget t next
    where next = step s

parse :: String -> Target
parse input = ((read x0, read x1),(read y0, read y1))
    where [_,rest] = splitOn ":" input
          [h,v]    = splitOn "," rest
          [_,x]    = splitOn "=" h  
          [_,y]    = splitOn "=" v
          [x0,x1]  = splitOn ".." x
          [y0,y1]  = splitOn ".." y
  
