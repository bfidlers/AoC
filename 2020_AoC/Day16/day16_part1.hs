import Data.List.Split
import Debug.Trace

main :: IO ()
main = do input <- readFile "input.txt"
          print . parseInput $ input
          
parseInput :: String -> Int
parseInput input = checkInputs others rules
    where rules = foldr (\x1 x2 -> makeRule (last x1) : x2) [] . map (splitOn ": ") $ splitOn "\n" (head split)
          own = map (\ x -> read x :: Int) . splitOn "," . last $ splitOn "\n" (split!!1)
          others = foldr (\x1 x2 -> (map (\ x3 -> read x3 :: Int) x1) : x2) [] . map (splitOn ",") . tail $ splitOn "\n" (split!!2)
          split = splitOn "\n\n" input
          
--min1 max1 min2 max2
data Rule = Rule Int Int Int Int
    deriving (Show)
          
min1 :: Rule -> Int 
min1 (Rule min1 _ _ _) = min1

max1 :: Rule -> Int 
max1 (Rule _ max1 _ _) = max1

min2 :: Rule -> Int 
min2 (Rule _ _ min2 _) = min2

max2 :: Rule -> Int 
max2 (Rule _ _ _ max2) = max2

makeRule :: String -> Rule
makeRule input = Rule (split!!0) (split!!1) (split!!2) (split!!3) 
    where split = map read . foldr (\ x1 x2 -> splitOn "-" x1 ++ x2) [] $ splitOn " or " input
    
checkInputs :: [[Int]] -> [Rule] -> Int
checkInputs inputs rules = foldr (\ x1 x2 -> (checkInput x1 rules) + x2) 0 inputs

checkInput :: [Int] -> [Rule] -> Int
checkInput input rules = foldr (\ x1 x2 -> if checkRules x1 rules then x1 + x2 else x2) 0 input

checkRules :: Int -> [Rule] -> Bool
checkRules input rules = foldr (\ x1 x2 -> (checkRule input x1) && x2) True rules

checkRule :: Int -> Rule -> Bool
checkRule input rule = if input >= (min1 rule) &&
                          input <= (max1 rule) ||
                          input >= (min2 rule) &&
                          input <= (max2 rule)
                           then False
                       else True
