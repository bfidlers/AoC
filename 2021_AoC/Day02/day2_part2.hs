import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . mult . f (0,0,0) . readInput $ input

data Input = Forward Int | Down Int | Up Int
    deriving Show

mkInput :: [String] -> Input
mkInput (dir:nb:[]) 
    | dir == "forward" = Forward (read nb)
    | dir == "down"    = Down (read nb)
    | dir == "up"      = Up (read nb)

mult :: (Int,Int,Int) -> Int
mult (a,b,_) = a*b

f :: (Int,Int,Int) -> [Input] -> (Int,Int,Int)
f pos []                    = pos
f (x,y,a) ((Forward nb):xs) = f (x+nb,y+a*nb,a) xs
f (x,y,a) ((Down nb):xs)    = f (x,y,a+nb) xs
f (x,y,a) ((Up nb):xs)      = f (x,y,a-nb) xs

readInput :: String -> [Input]
readInput = map (mkInput . words) . lines
