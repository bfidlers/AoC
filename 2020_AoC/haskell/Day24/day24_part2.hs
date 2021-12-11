import Data.List

main = do input <- readFile "input.txt"
          print . length . f . parse $ input

f :: [Coord] -> [Coord]
f input  = (\x -> x!!100) . iterate loop $ begin
    where begin = map head . filter (\x -> odd (length x)) . group . sort $ input

loop :: [Coord] -> [Coord]
loop input = (input \\ blacks) ++ whites
    where blacks = filter (blackCond input) input
          whites = filter (whiteCond input) whiteTiles
          whiteTiles = eligible \\ input
          eligible = allNeighbours input

blackCond :: [Coord] -> Coord -> Bool
blackCond l pos = count == 0 || count > 2
    where n = neighbours pos
          count = length . filter (\x -> elem x l) $ n

whiteCond :: [Coord] -> Coord -> Bool
whiteCond l pos = count == 2
    where n = neighbours pos
          count = length . filter (\x -> elem x l) $ n

neighbours :: Coord -> [Coord]
neighbours (x,y) = [(x+2,y),(x-2,y),(x-1,y-1),(x-1,y+1),(x+1,y+1),(x+1,y-1)]

allNeighbours :: [Coord] -> [Coord]
allNeighbours = nub . concat . map neighbours

type Coord = (Int,Int) -- (e,n)

findCoord :: [String] -> Coord
findCoord [] = (0,0)
findCoord (x:xs)
    | x == "e" =  (\(e,n) -> (e+2,n)) (findCoord xs)
    | x == "w" =  (\(e,n) -> (e-2,n)) (findCoord xs)
    | x == "ne" = (\(e,n) -> (e+1,n+1)) (findCoord xs)
    | x == "sw" = (\(e,n) -> (e-1,n-1)) (findCoord xs)
    | x == "se" = (\(e,n) -> (e+1,n-1)) (findCoord xs)
    | x == "nw" = (\(e,n) -> (e-1,n+1)) (findCoord xs)

parse :: String -> [Coord]
parse = map (findCoord . parseChar) . lines

parseChar :: String -> [String]
parseChar [] = []
parseChar (x:xs)
    | x == 'e' || x == 'w' = [x] : parseChar xs
    | otherwise = (x:[head xs]) : parseChar (tail xs)
