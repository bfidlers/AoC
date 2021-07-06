import Data.List
import Data.List.Split
import Data.Matrix
import Debug.Trace
import Data.Either

main :: IO ()
main = do input <- readFile "input.txt"
          print . parseInput $ input
          
parseInput :: String -> Int
parseInput input = foldr (*) 1 ticketValues
    where ticketValues = [own !! i | i <- depIndices]
          depIndices = map (\ x -> mod x 20) . take 6 . elemIndices 1 . toList $ solvedMatrix
          solvedMatrix = fromRight (zero 1 1) . inverse $ matches
          matches = selectMatches possMatches validTickets
          possMatches = matrix size size $ \_ -> 1
          size = length rules
          validTickets = checkInputs others rules
          rules = foldr (\x1 x2 -> makeRule (last x1) : x2) [] . map (splitOn ": ") $ splitOn "\n" (head split)
          own = map (\ x -> read x :: Int) . splitOn "," . last $ splitOn "\n" (split!!1)
          others = foldr (\x1 x2 -> (map (\ x3 -> read x3 :: Int) x1) : x2) [] . map (splitOn ",") . tail $ splitOn "\n" (split!!2)
          split = splitOn "\n\n" input
         
selectMatches :: Matrix Double -> [[[Bool]]] -> Matrix Double 
selectMatches m [] = m
selectMatches m (x:xs) = (\ iMatrix -> selectMatches2 0 iMatrix x) (selectMatches m xs)

selectMatches2 :: Int -> Matrix Double -> [[Bool]] -> Matrix Double 
selectMatches2 i m ticket 
    | i >= length ticket = m
    | otherwise = (\ iMatrix -> selectMatches3 i 0 iMatrix (ticket!!i)) (selectMatches2 (i+1) m ticket)

selectMatches3 :: Int -> Int -> Matrix Double -> [Bool] -> Matrix Double 
selectMatches3 i j m ticket 
    | j >= length ticket = m
    | otherwise = if ticket!!j == False
                      then selectMatches3 i (j+1) (setElem 0 (i+1, j+1) m) ticket
                  else selectMatches3 i (j+1) m ticket

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
    
checkInputs :: [[Int]] -> [Rule] -> [[[Bool]]]
checkInputs inputs rules = foldr (\ x1 x2 -> checkFalse (checkInput x1 rules) ++ x2) [] inputs
                                  
checkFalse :: [[Bool]] -> [[[Bool]]]
checkFalse list = if elem (replicate (length . head $ list) False) list
                      then []
                  else [list]

checkInput :: [Int] -> [Rule] -> [[Bool]]
checkInput input rules = foldr (\ x1 x2 -> (checkRules x1 rules) : x2) [] input

checkRules :: Int -> [Rule] -> [Bool]
checkRules input rules = foldr (\ x1 x2 -> (checkRule input x1) : x2) [] rules

checkRule :: Int -> Rule -> Bool
checkRule input rule = if input >= (min1 rule) &&
                          input <= (max1 rule) ||
                          input >= (min2 rule) &&
                          input <= (max2 rule)
                           then True
                       else False
