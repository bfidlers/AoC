import Data.List
import Data.List.Split
import Data.Ord

main :: IO ()
main = do input <- readFile "input.txt"
          mapM_ putStrLn . matrix . f . parse $ input
        
matrix :: [Point] -> [[Char]]
matrix input = map (row) [0..maxY]
    where maxX = fst . maximumBy (comparing fst) $ input 
          maxY = snd . maximumBy (comparing snd) $ input 
          row r = map (\x -> if elem (x,r) input then 'X' else ' ') [0..maxX]

f :: ([Point],[Split]) -> [Point]
f (p,s) = foldl g p s
    where g :: [Point] -> Split -> [Point]
          g b (V nb) = nub . map (\(x,y) -> if x > nb then (x-(2*x-2*nb),y)
                                            else (x,y)) $ b
          g b (H nb) = nub . map (\(x,y) -> if y > nb then (x,y-(2*y-2*nb))
                                            else (x,y)) $ b
  
type Point = (Int,Int)

data Split = V Int | H Int
    deriving Show

parse :: String -> ([Point],[Split])
parse input = (points,splits)
    where [x,y] = splitOn "\n\n" input
          points = map (\s -> read ("(" ++ s ++ ")")) . lines $ x
          splits = map ((\[a,b] -> g (last a) b) . splitOn "=") . lines $ y
          g s nb 
              | s == 'x' = V (read nb)
              | otherwise = H (read nb)
