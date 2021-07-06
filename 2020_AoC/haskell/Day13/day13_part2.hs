import Data.List
import Debug.Trace

main :: IO()
main = do input <- readFile "input.txt"
--          print . crt . sortOn snd .  parseInput . lines $ input
          print . crt . parseInput . lines $ input
                             
parseInput :: [String] -> [(Integer, Integer)] 
parseInput (x1:x2:xs) = addOffSet 0 . splitBy ',' $ x2

splitBy :: Eq a => a -> [a] -> [[a]]
splitBy seperator [] = []
splitBy seperator (x:xs) 
    | null xs = [[x]]
    | x == seperator = [[]] ++ (splitBy seperator xs)
    | otherwise = (\ (y:ys) -> (x:y):ys) (splitBy seperator xs)
    
addOffSet :: Integer -> [String] -> [(Integer, Integer)]
addOffSet nb [] = [] 
addOffSet nb (x:xs) = if x /= "x" 
                          then (-nb, read x) : addOffSet (nb + 1) xs
                      else addOffSet (nb + 1) xs

eea :: Integral a => a -> a -> (a, a) 
eea a b = eeaHelper a b 1 0 0 1
     where eeaHelper r0 r1 a0 a1 b0 b1 
             | r1 == 0 = (a0, b0) 
             | otherwise = eeaHelper r1 r2 a1 a2 b1 b2
                             where
                                 q = div r0 r1
                                 r2 = mod r0 r1
                                 a2 = a0 - q * a1
                                 b2 = b0 - q * b1  

crt :: Integral a => [(a, a)] -> a
crt (x:[]) = mod (fst x) (snd x)
crt ((a, m):(b, n):xs) = crt (x:xs)
    where x = (mod x1 x2, x2)
          x2 = m * n
          x1 = b * alpha * m + a * beta * n
          (alpha, beta) = eea m n
