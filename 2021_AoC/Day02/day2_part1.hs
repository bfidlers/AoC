import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . mult . f (0,0) . readInput $ input

data Input = Forward Int | Down Int | Up Int
    deriving Show

mkInput :: [String] -> Input
mkInput (dir:nb:[]) 
    | dir == "forward" = Forward (read nb)
    | dir == "down"    = Down (read nb)
    | dir == "up"      = Up (read nb)

mult :: (Int, Int) -> Int
mult (a,b) = a*b

f :: (Int, Int) -> [Input] -> (Int,Int)
f pos []                  = pos
f (x,y) ((Forward nb):xs) = f (x+nb,y) xs
f (x,y) ((Down nb):xs)    = f (x,y+nb) xs
f (x,y) ((Up nb):xs)      = f (x,y-nb) xs

readInput :: String -> [Input]
readInput = map (mkInput . words) . lines
