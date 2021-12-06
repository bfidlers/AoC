import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . nb_fish . (!!cycles) . iterate cycle' . parse $ input

nb_fish :: [(Int,Int)] -> Int
nb_fish = sum . map snd

cycle' :: [(Int,Int)] -> [(Int,Int)]
cycle' [] = []
cycle' ((a,b):xs)
    | a == 0 = cycle' xs ++ [(6,b),(8,b)]
    | otherwise = (a-1,b) : cycle' xs

cycles :: Int
cycles = 80

parse :: String -> [(Int,Int)]
parse = map (\l -> (head l, length l)) . group . sort . map read . splitOn "," 
