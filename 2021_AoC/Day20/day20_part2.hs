import Data.List
import Data.List.Split
import qualified Data.Set as S
import qualified Data.Map as M
import Data.Ord

main :: IO () 
main = do input <- readFile "input.txt"
          print . answer . f . parse $ input

type Point = (Int,Int)
type Image = M.Map Point Char

-- functions

answer :: Image -> Int
answer = M.size . M.filter (== '#') 

f :: (String,Image) -> Image
f (alg,img) = (\(a,b,c) -> b) . (!!50) . iterate step $ (alg,img,'.')

step :: (String,Image,Char) -> (String,Image,Char)
step (alg,img,def) = (alg,new_image,new_def)
    where eligible  = S.fromList . concat . map neighbours . M.keys $ img 
          new_image = M.fromList . foldr (replace) [] $ eligible 
          replace p l = (p, alg!!(toNumber . readNeigh img def . neighbours $ p)):l
          new_def = if def == '.' then '#' else '.'

neighbours :: Point -> [Point]
neighbours (r,c) = [(r+dr,c+dc) | dr <- [-1..1],
                                  dc <- [-1..1]]

readNeigh :: Image -> Char -> [Point] -> String
readNeigh img def = foldr repl [] 
    where repl a b = M.findWithDefault def a img : b 

toNumber :: String -> Int 
toNumber = toInt . toBin  
    where toBin = map (\x -> if x == '.' then 0 else 1)
          toInt = foldl (\a b -> 2*a + b) 0
-- parsing

parse :: String -> (String,Image)
parse input = (alg,image)
    where [alg,img] = splitOn "\n\n" input
          image = parseImage img

parseImage :: String -> M.Map Point Char
parseImage input = M.fromList [((r,c),v) | (r,row) <- zip [0..] rows,
                                           (c,v) <- zip [0..] row]
    where rows = words input
