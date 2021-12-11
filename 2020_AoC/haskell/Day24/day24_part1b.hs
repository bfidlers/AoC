import Data.List

main = do input <- readFile "input.txt"
--          print . f . parse $ input
          print . length . f . parse $ input

f :: [Coord] -> [Coord]
f = map head . filter (\x -> odd (length x)) . group . sort

type Coord = (Int,Int) -- (n,e)

makePath :: [String] -> Coord
makePath [] = (0,0)
makePath (x:xs)
    | x == "e" =  (\(n,e) -> (n,e+2)) (makePath xs)
    | x == "w" =  (\(n,e) -> (n,e-2)) (makePath xs)
    | x == "ne" = (\(n,e) -> (n+1,e+1)) (makePath xs)
    | x == "sw" = (\(n,e) -> (n-1,e-1)) (makePath xs)
    | x == "se" = (\(n,e) -> (n-1,e+1)) (makePath xs)
    | x == "nw" = (\(n,e) -> (n+1,e-1)) (makePath xs)

parse :: String -> [Coord]
parse = map (makePath . parseChar) . lines

parseChar :: String -> [String]
parseChar [] = []
parseChar (x:xs)
    | x == 'e' || x == 'w' = [x] : parseChar xs
    | otherwise = (x:[head xs]) : parseChar (tail xs)
