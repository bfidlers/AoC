import Data.List
import Data.List.Split
import qualified Data.Map as M

main :: IO ()
main = do input <- readFile "input.txt"
          print . answer . f . parse $ input
          
answer :: String -> Int
answer l = maximum freq - minimum freq
    where freq = map length . group . sort $ l

f :: (String,Rules) -> String
f (input,rules) = (!! 10) . iterate (step rules) $ input

step :: Rules -> String -> String
step r (a:[])   = [a]
step r (a:b:xs) = a : (r M.! (a:b:[])) ++ step r (b:xs)

type Rules = M.Map String String

parse :: String -> (String,Rules)
parse input = (first, M.fromList rules)
    where [first,second] = splitOn "\n\n" input
          rules = map ((\[x,y] -> (x,y)) . splitOn " -> ") . lines $ second
