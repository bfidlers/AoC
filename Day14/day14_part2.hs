import Data.List
import Data.List.Split
import qualified Data.Map as Map
import Data.Char

main :: IO ()
main = do input <- readFile "input.txt"
          print . result . execute . parseInput $ input
          
parseInput :: String -> [(String, [(String, Int)])]
parseInput = format . lines' . tail . splitOn "mask = "

lines' :: [String] -> [[String]]
lines' = foldr (\ x y -> lines x : y) [] 

format :: [[String]] -> [(String, [(String, Int)])]
format [] = []
format (x:xs) = (head x, formatMem (tail x)) : format xs

formatMem :: [String] -> [(String, Int)]
formatMem [] = []
formatMem (x:xs) = (extendBinaryString . toBinaryString . read . drop 4 . init $ entry!!0, read $ entry!!1) : formatMem xs
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
    | y == 'X' = 'X' : applyMask xs ys
    | y == '0' = x : applyMask xs ys
    | y == '1' = '1' : applyMask xs ys
    
fillInMask :: String -> [String]
fillInMask [] = [""]
fillInMask (x:xs)
    | x == 'X' = (map (\ elem -> '0': elem) (fillInMask xs)) ++ (map (\ elem -> '1': elem) (fillInMask xs))
    | otherwise = map (\ elem -> x: elem) (fillInMask xs)
    
execute :: [(String, [(String, Int)])] -> Map.Map Int Int
execute [] = Map.empty
execute (x:xs) = Map.union (execute xs) (applySetOfMasks (fst x) (snd x))

applySetOfMasks :: String -> [(String, Int)] -> Map.Map Int Int
applySetOfMasks mask [] = Map.empty
applySetOfMasks mask (x:xs) = Map.union (applySetOfMasks mask xs) (Map.fromList (map (\ a -> (bti a, snd x)) maskList))
    where maskList = fillInMask (applyMask (fst x) mask)

bti :: String -> Int
bti = foldl (\ acc x -> 2 * acc + digitToInt x) 0

result :: Map.Map Int Int -> Int
result = Map.foldr (+) 0
