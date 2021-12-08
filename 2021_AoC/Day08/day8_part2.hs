import Data.List
import Data.List.Split
import Data.Char
import Data.Function
import qualified Data.HashMap as H
import Data.Maybe

main :: IO ()
main = do input <- readFile "input.txt"
          print . parse $ input
          print . f . parse $ input
          print . sum . f . parse $ input

f :: [([String], [String])] -> [Int]
f [] = []
f ((input,output):xs) = (decode2 key output) : f xs
    where key = crack input

crack :: [String] -> [(Int, String)]
crack input = H.toList (translateAll sorted H.empty)
    where sorted = sortBy (compare `on` length) $ input

--translate :: String -> [(Char, String)] -> [(Char, String)]
--translate l dec
--    | len == 2 = match [('c',l),('f',l)] dec
--    | len == 3 = [('a',l),('c',l),('f',l)]
--    | len == 4 = [('b',l),('c',l),('d',l),('f',l)]
--   | otherwise = []
--    where len = length l

translateAll :: [String] -> H.Map Int String -> H.Map Int String
translateAll [] dec = dec
translateAll (x:xs) dec = translateAll xs (translate2 x dec)

translate2 :: String -> H.Map Int String -> H.Map Int String
translate2 l dec 
    | len == 2 = H.insert 1 l dec
    | len == 3 = H.insert 7 l dec
    | len == 4 = H.insert 4 l dec
    | len == 5 = if sublist (fromJust (H.lookup 1 dec)) l 
                     then H.insert 3 l dec
                 else if common l (fromJust (H.lookup 4 dec)) == 3
                     then H.insert 5 l dec
                 else H.insert 2 l dec
    | len == 6 = if sublist (fromJust (H.lookup 3 dec)) l
                     then H.insert 9 l dec
                 else if sublist (fromJust (H.lookup 5 dec)) l
                     then H.insert 6 l dec
                 else H.insert 0 l dec
    | len == 7 = H.insert 8 l dec
    where len = length l

sublist :: Eq a => [a] -> [a] -> Bool
sublist a b = length (intersect a b) == length a

common :: Eq a => [a] -> [a] -> Int
common a b = length (intersect a b)

--match :: [(Char, String)] -> [(Char, String)] -> [(Char, String)]
--match dec [] = dec
--match [] dec = dec
--match (x:xs) dec = 
--    where match' (

decode :: String -> [(Char, Char)] -> Int
decode input dec = read . concat . map g $ input
    where g = show . (\x -> toInt . snd $ (dec!!(toInt x)))

decode2 :: [(Int, String)] -> [String] -> Int
decode2 dec input = read . concat . map (show . (\x -> findDigit x dec)) $ input

findDigit :: String -> [(Int, String)] -> Int
findDigit s ((a,b):xs)
    | sort s == sort b = a
    | otherwise = findDigit s xs

toInt :: Char -> Int
toInt c = ord c - ord 'a' 

parse :: String -> [([String], [String])] 
parse = map ((\l -> (l!!0, l!!1)) . map words . splitOn (" | ")) . lines 
