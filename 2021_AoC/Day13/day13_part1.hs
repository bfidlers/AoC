import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . length . f . parse $ input
        
f :: ([Point],[Split]) -> [Point]
f (p,((V nb):_)) = nub . map (\(x,y) -> if x > nb then (x-2*(x-nb),y)
                                       else (x,y)) $ p
f (p,((H nb):_)) = nub . map (\(x,y) -> if y > nb then (x,y-2*(y-nb))
                                       else (x,y)) $ p
  
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
