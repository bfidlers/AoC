import Data.Char
import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

type State = (Int,Point,Score)
type Point = (Int,Int)
type Score = (Int,Int)

f :: Point -> Int
f p = answer . game $ (0,p,(0,0))

answer :: State -> Int
answer (r,_,(a,b)) = r * min a b

end :: Score -> Bool
end (a,b)
    | a >= 1000 = True
    | b >= 1000 = True 
    | otherwise = False

turn :: State -> State 
turn (r,(x,y),(s1,s2)) 
    | mod r 6 == 0 = (r+3,(nextX,y),(s1+nextX,s2))
    | otherwise    = (r+3,(x,nextY),(s1,s2+nextY))
    where roles = sum [mod' (r + nb) 100 | nb <- [1..3]]
          nextX = mod' (x + roles) 10
          nextY = mod' (y + roles) 10

game :: State -> State
game (r,p,s) 
    | end s = (r,p,s)
    | otherwise = game . turn $ (r,p,s)

mod' :: Int -> Int -> Int
mod' a b
    | mod a b == 0 = b
    | otherwise = mod a b

parse :: String -> Point
parse = (\[x,y] -> (digitToInt x, digitToInt y)) . map last . lines
