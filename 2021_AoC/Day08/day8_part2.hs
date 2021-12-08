{-# LANGUAGE MultiWayIf #-}

import Data.List
import Data.List.Split
import Data.Char
import Data.Function
import qualified Data.HashMap as H
import Data.Maybe

main :: IO ()
main = do input <- readFile "input.txt"
          print . sum . f . parse $ input

f :: [([String], [String])] -> [Int]
f = map (\(a,b) -> decode (crack a) b)

crack :: [String] -> [(Int, String)]
crack input = H.toList (translateAll sorted H.empty)
    where translateAll :: [String] -> H.Map Int String -> H.Map Int String
          translateAll l dec = foldl (\a b -> translate b a) dec l
          sorted = sortBy (compare `on` length) $ input

translate :: String -> H.Map Int String -> H.Map Int String
translate l dec 
    | len == 2 = H.insert 1 l dec
    | len == 3 = H.insert 7 l dec
    | len == 4 = H.insert 4 l dec
    | len == 5 = if 
        | sublist (fromJust (H.lookup 1 dec)) l     -> H.insert 3 l dec
        | common l (fromJust (H.lookup 4 dec)) == 3 -> H.insert 5 l dec
        | otherwise                                 -> H.insert 2 l dec
    | len == 6 = if
        | sublist (fromJust (H.lookup 3 dec)) l     -> H.insert 9 l dec
        | sublist (fromJust (H.lookup 5 dec)) l     -> H.insert 6 l dec
        | otherwise                                 -> H.insert 0 l dec
    | len == 7 = H.insert 8 l dec
    where len = length l

sublist :: Eq a => [a] -> [a] -> Bool
sublist a b = length (intersect a b) == length a

common :: Eq a => [a] -> [a] -> Int
common a b = length (intersect a b)

decode :: [(Int, String)] -> [String] -> Int
decode dec input = read . concat . map (show . (\x -> findDigit x dec)) $ input

findDigit :: String -> [(Int, String)] -> Int
findDigit s ((a,b):xs)
    | sort s == sort b = a
    | otherwise = findDigit s xs

parse :: String -> [([String], [String])] 
parse = map ((\l -> (l!!0, l!!1)) . map words . splitOn (" | ")) . lines 
