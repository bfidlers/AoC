import Data.Char
import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . length . paths [["start"]] . parse $ input

extendable :: [[String]] -> Bool 
extendable = not . all (\x -> head x == "end")

paths :: [[String]] -> [(String,String)] -> [[String]]
paths p rules 
    | extendable p = paths next rules
    | otherwise = p
    where next = concat . map (extend rules) $ p

extend :: [(String,String)] -> [String] -> [[String]]
extend rules l@(x:xs)
    | x == "end" = [l]
    | otherwise = if null next then [] 
                  else map (\a -> a:l) next
    where next = [b | (a,b) <- rules, a == x, exception b l] ++ 
                 [a | (a,b) <- rules, b == x, exception a l] 

exception :: String -> [String] -> Bool
exception x l
    | bigCave x = True
    | x == "start" = False
    | poss l = True
    | otherwise = not . elem x $ l

poss :: [String] -> Bool
poss input = (length . nub $ small) == length small
    where small = filter (smallCave) input

smallCave :: String -> Bool
smallCave (x:_) = isLower x

bigCave :: String -> Bool
bigCave (x:_) = isUpper x

parse :: String -> [(String,String)]
parse = map ((\(x:y:[]) -> (x,y)) . splitOn "-") . lines
