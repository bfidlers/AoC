import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . nb_fish . f cycles . parse $ input

nb_fish :: [(Int,Int)] -> Int
nb_fish = sum . map snd

f :: Int -> [(Int,Int)] -> [(Int,Int)]
f 0 input = input
f nb input = f (nb-1) (cycle' input)

cycle' :: [(Int,Int)] -> [(Int,Int)]
cycle' [] = []
cycle' ((a,b):xs)
    | a == 0 = cycle' xs ++ [(6,b),(8,b)]
    | otherwise = (a-1,b) : cycle' xs

cycles :: Int
cycles = 256

parse :: String -> [(Int,Int)]
parse = map (\l -> (head l, length l)) . group . sort . map read . splitOn "," 
