import Data.List
import qualified Data.Map as M

main :: IO () 
main = do input <- readFile "input.txt"
          print . f $ input

type Pos = (Int,Int)
type Dim = (Int,Int)
type Cucumber = (Pos,Char)
type Sea = M.Map Pos Char

f :: String -> Int
f input = loop dim parsed
    where parsed = parse input
          l@(x:xs) = lines input
          dim = (length l, length x)

loop :: Dim -> Sea -> Int
loop dim s 
    | end s dim = 1
    | otherwise = 1 + loop dim stepTwo
    where stepOne = east dim s
          stepTwo = south dim stepOne

south :: Dim -> Sea -> Sea
south dim s = M.fromList . M.foldrWithKey (\k a -> (down k a dim s :)) [] $ s

east :: Dim -> Sea -> Sea
east dim s = M.fromList . M.foldrWithKey (\k a -> (right k a dim s :)) [] $ s

end :: Sea -> Dim -> Bool 
end s dim = not . M.foldrWithKey (\k a b -> (possMove k a dim s) || b) False $ s

right :: Pos -> Char -> Dim -> Sea -> Cucumber 
right pos c dim sea
    | c == '>' && possMove pos c dim sea = (next pos c dim,c)
    | otherwise = (pos,c) 

down :: Pos -> Char -> Dim -> Sea -> Cucumber 
down pos c dim sea
    | c == 'v' && possMove pos c dim sea = (next pos c dim,c)
    | otherwise = (pos,c) 

possMove :: Pos -> Char -> Dim -> Sea -> Bool
possMove _ '.' _ _ = False
possMove pos c dim sea 
    | M.findWithDefault '.' n sea == '.' = True
    | otherwise = False
    where n = next pos c dim

next :: Pos -> Char -> Dim -> Pos
next (x,y) '>' (r,c)
    | y + 1 > c = (x,1)
    | otherwise = (x,y+1)
next (x,y) 'v' (r,c)
    | x + 1 > r = (1,y)
    | otherwise = (x+1,y) 

parse :: String -> Sea 
parse input = M.fromList [((r,c),x) | (r,line) <- zip [1..] (lines input),
                                      (c,x) <- zip [1..] line,
                                      x /= '.']
