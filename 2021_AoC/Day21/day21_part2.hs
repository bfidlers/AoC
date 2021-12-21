import Data.Char
import Data.List
import qualified Data.Map as M

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input

type State = (Int,Point,Score)
type Point = (Int,Int)
type Score = (Int,Int)
type Universes = M.Map State Int
type Result = (Score,Int)

f :: Point -> Int
f p = answer . fst . playAll $ ([], M.singleton (0,p,(0,0)) 1)

answer :: [Result] -> Int
answer = (\(a,b) -> max a b) . foldr (g) (0,0)
    where g ((s1,s2),nb) (a,b) 
            | s1 > s2   = (a+nb,b)
            | otherwise = (a,b+nb)

playAll :: ([Result],Universes) -> ([Result],Universes)
playAll (r,uni)
    | M.null uni = (r,uni)
    | otherwise = playAll . M.foldrWithKey (g) (r,M.empty) $ uni
    where g :: State -> Int -> ([Result],Universes) -> ([Result],Universes)
          g s@(t,p,score) nb (a,b)
              | end score = ((score,nb):a,b)
              | otherwise = (a,M.unionWith (+) (M.map (*nb) (turn s)) b)
                
end :: Score -> Bool
end (a,b)
    | a >= 21 = True
    | b >= 21 = True 
    | otherwise = False

turn :: State -> Universes
turn (t,(x,y),(s1,s2)) 
    | t == 0    = M.fromListWith (+) . zip nextX $ (repeat 1)
    | otherwise = M.fromListWith (+) . zip nextY $ (repeat 1)
    where nt = mod (t+1) 2
          r = [r1+r2+r3 | r1 <- [1..3], r2 <- [1..3], r3 <- [1..3]]
          nextX = [(nt,(nx,y),(s1+nx,s2)) | r0 <- r, let nx = mod' (x+r0) 10]
          nextY = [(nt,(x,ny),(s1,s2+ny)) | r0 <- r, let ny = mod' (y+r0) 10]

mod' :: Int -> Int -> Int
mod' a b
    | mod a b == 0 = b
    | otherwise = mod a b

parse :: String -> Point
parse = (\[x,y] -> (digitToInt x, digitToInt y)) . map last . lines
