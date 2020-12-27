import Data.List
import Data.List.Split
import Data.Maybe

main :: IO ()
main = do input <- readFile "input.txt"
          print . head . playGame 2020 . reverse . splitOn "," $ input
          
playGame :: Int -> [String] -> [String]
playGame turns (x:xs)
    | length (x:xs) >= turns = (x:xs)
    | otherwise = if isNothing index
                      then playGame turns ("0" : (x:xs))
                  else playGame turns ((show (fromJust index + 1)) : (x:xs))
        where index = elemIndex x xs
