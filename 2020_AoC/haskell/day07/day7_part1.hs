import Data.List
import Data.Maybe

main :: IO ()
main = do input <- readFile "input.txt"
          print . (+(-1)) . length . filter (==True) . map (hasGold) . fillInDataStructure . parseInput $ input

parseInput :: String -> [Bag]
parseInput = parseLine . lines

parseLine :: [String] -> [Bag]
parseLine [] = []
parseLine (x:xs) = (turnIntoBag (splitBy ',' x)): parseLine xs

splitBy :: Eq a => a -> [a] -> [[a]]
splitBy seperator [] = []
splitBy seperator (x:xs) 
  | null xs = [[x]]
  | x == seperator = [[]] ++ (splitBy seperator xs)
  | otherwise = (\ (y:ys) -> (x:y):ys) (splitBy seperator xs)

turnIntoBag :: [String] -> Bag
turnIntoBag (x:xs) = makeBag 1 (first!!0 ++ first!!1) (firstSubBag :(makeSubBags xs))
  where 
    firstSubBag = if (first!!4) == "no" then Empty else makeBag (read (first!!4)) (first!!5 ++ first!!6) [Unknown]
    first = words x

makeSubBags :: [String] -> [Bag]
makeSubBags [] = []
makeSubBags (x:xs) = makeBag (read (first!!0)) (first!!1 ++ first!!2) [Unknown] : makeSubBags xs
  where first = words x
  
-- Bag is a datastructure consisting of number of bags, a bag color and a list of bags it contains. 
-- Boolean keeps track of whether it has been filled in in other data structures
data Bag =  Bag Int String [Bag] Bool |
            Empty |
            Unknown
            deriving (Show)
  
makeBag :: Int -> String -> [Bag] -> Bag
makeBag nb name bags = Bag nb name bags False

bagName :: Bag -> String
bagName (Bag _ name _ _) = name
bagName _ = "no_name"

bagNumber :: Bag -> Int
bagNumber (Bag number _ _ _) = number
bagNumber _ = 0

bagSubBags :: Bag -> [Bag]
bagSubBags (Bag _ _ bags _) = bags
bagSubBags _ = []

isName :: String -> Bag -> Bool
isName name1 (Bag _ name2 _ _) = if name1 == name2 then True else False
isName _ _ = False

hasName :: String -> Bag -> Bool
hasName name bag = checkBagsName name (bagSubBags bag)

checkBagsName :: String -> [Bag] -> Bool
checkBagsName _ [] = False 
checkBagsName name (x:xs) = isName name x || checkBagsName name xs

hasGold :: Bag -> Bool
hasGold bag = isName "shinygold" bag || checkBagsGold (bagSubBags bag)

checkBagsGold :: [Bag] -> Bool
checkBagsGold [] = False 
checkBagsGold (x:xs) = hasGold x || checkBagsGold xs

isEmpty :: Bag -> Bool 
isEmpty Empty = True
isEmpty _ = False

hasEmpty :: Bag -> Bool
hasEmpty bag = checkBagsEmpty (bagSubBags bag)

checkBagsEmpty :: [Bag] -> Bool
checkBagsEmpty [] = False 
checkBagsEmpty (x:xs) 
  | isEmpty x = True 
  | otherwise = hasEmpty x || checkBagsEmpty xs

isUnknown :: Bag -> Bool 
isUnknown Unknown = True
isUnknown _ = False

hasUnknown :: Bag -> Bool
hasUnknown bag = checkBagsUnknown (bagSubBags bag)

checkBagsUnknown :: [Bag] -> Bool
checkBagsUnknown [] = False 
checkBagsUnknown (x:xs) 
  | isUnknown x = True
  | otherwise = hasUnknown x || checkBagsUnknown xs

isUsed :: Bag -> Bool
isUsed (Bag _ _ _ used) = used

fillInDataStructure :: [Bag] -> [Bag]
fillInDataStructure list
  | checkBagsUnknown list = fillInDataStructure (fillInElements list list)
  | otherwise = list

fillInElements :: [Bag] -> [Bag] -> [Bag]
fillInElements [] list = list
fillInElements (x:xs) list 
  | not (isUsed x) && not (hasUnknown x)= fillInElements xs (map (fillIn x) list)
  | otherwise = fillInElements xs list

fillIn :: Bag -> Bag -> Bag 
fillIn bag1 (Bag nb name bags bool)
  | bagName bag1 == name = Bag (bagNumber bag1) (bagName bag1) (bagSubBags bag1) True
  | hasName (bagName bag1) (Bag nb name bags bool) = Bag nb name (map (fillIn bag1) bags) bool
  | otherwise = (Bag nb name bags bool)
