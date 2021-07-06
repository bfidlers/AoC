import Data.List
import Data.List.Split
import qualified Data.Map as Map
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . result . execute . parseInput $ input
          
parseInput :: String -> [(String, [(Int, String)])]
parseInput = format . lines' . tail . splitOn "mask = "

lines' :: [String] -> [[String]]
lines' = foldr (\ x y -> lines x : y) [] 

format :: [[String]] -> [(String, [(Int, String)])]
format [] = []
format (x:xs) = (head x, formatMem (tail x)) : format xs

formatMem :: [String] -> [(Int, String)]
formatMem [] = []
formatMem (x:xs) = (read . drop 4 . init $ entry!!0, extendBinaryString . toBinaryString . read $ entry!!1) : formatMem xs
    where entry = splitOn " = " x
    
toBinaryString :: Int -> String
toBinaryString 0 = ""
toBinaryString nb 
    | r == 1 = toBinaryString q ++ "1"
    | otherwise = toBinaryString q ++ "0"
        where r = mod nb 2
              q = div nb 2
              
extendBinaryString :: String -> String 
extendBinaryString s = replicate l '0' ++ s 
    where l = 36 - length s
    
applyMask :: String -> String -> String 
applyMask [] [] = ""
applyMask (x:xs) (y:ys) 
    | y == 'X' = x : applyMask xs ys
    | otherwise = y : applyMask xs ys
    
execute :: [(String, [(Int, String)])] -> Map.Map Int Int
execute [] = Map.empty
execute (x:xs) = Map.union (execute xs) (applySetOfMasks (fst x) (snd x))

applySetOfMasks :: String -> [(Int, String)] -> Map.Map Int Int
applySetOfMasks mask [] = Map.empty
applySetOfMasks mask (x:xs) = Map.union (applySetOfMasks mask xs) (Map.singleton (fst x) (bti (applyMask (snd x) mask)))

bti :: String -> Int
bti = foldl (\ acc x -> 2 * acc + digitToInt x) 0

result :: Map.Map Int Int -> Int
result = Map.foldr (+) 0
